import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent

    property var moduleData
    property StackView stackViewRef

    property bool endlessMode: moduleData?.endlessMode ?? false

    property int totalRounds: 10
    property int roundCount: 0
    property int clickCount: 0
    property real totalReactionTime: 0
    property real lastReactionTime: 0
    property real bestReactionTime: 999999
    property bool waitingForGreen: false
    property bool isGreen: false
    property real roundStartTime: 0
    property bool paused: false

    property int falseStarts: 0

    Timer {
        id: waitTimer
        interval: 1000 + Math.random() * 3000
        running: false
        repeat: false
        onTriggered: {
            if (!paused) {
                showGreen()
            }
        }
    }

    // Игровой фон
    Frame {
        anchors.fill: parent
        //color: "white"
        z: 0
    }

    // Верхняя панель
    Rectangle {
        id: topBar
        height: 75
        width: parent.width
        anchors.top: parent.top

        color: Material.theme === Material.Dark ? Qt.darker(Material.background, 1.3) : Qt.darker(Material.background, 1.05)


        // Нижняя граница
        Rectangle {
            height: 2
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            color: "grey"
            z: 10
        }

        MouseArea {

            id: backArea
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 10
            width: row.implicitWidth
            height: row.implicitHeight+10
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: stackViewRef.pop()


            Rectangle {

                anchors.fill: parent
                color: Material.theme === Material.Dark ?
                           (backArea.pressed ? Qt.darker(Material.background ,1.2) : backArea.containsMouse ? Qt.darker("#32475c",1.1) : "#32475c") :
                           (backArea.pressed ? Qt.darker("white",1.2) : backArea.containsMouse ? Qt.darker("white",1.1) : "white")
                radius: 8
                border.color:  "grey"
                border.width: 2


            }

            Row {
                id: row
                spacing: 20
                anchors.fill: parent
                leftPadding: 10
                rightPadding: 10

                // Выравниваем содержимое по вертикальному центру:
                Layout.alignment: Qt.AlignVCenter


                Image {
                    source: Material.theme === Material.Dark ?moduleData.iconArrowLightUrl : moduleData.iconArrowDarkUrl
                    width: 40
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    text: moduleData && moduleData.name ? moduleData.name : "Без названия"
                    font.pixelSize: 26
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }


        Label {
            text: endlessMode
                  ? "Среднее время: " + (clickCount > 0
                                         ? Math.round(totalReactionTime / clickCount) + " мс"
                                         : "—")
                  : "Раунд: " + (roundCount + 1) + " из " + totalRounds
            font.pixelSize: 26
            visible: !gameOverOverlay.visible
            Layout.alignment: Qt.AlignVCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
        }



        RowLayout{
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter


            Item {
                width: 60
                height: 60
                visible: endlessMode && !gameOverOverlay.visible && !countdownOverlay.visible


                MouseArea {
                    id: pauseMouseArea
                    anchors.fill: parent
                    onClicked: root.togglePause()
                    cursorShape: Qt.PointingHandCursor
                }

                Rectangle {

                    anchors.fill: parent
                    radius: width / 2
                    color: Material.theme === Material.Dark ?
                               (pauseMouseArea.pressed ? Qt.darker("#32475c",1.2) : pauseMouseArea.containsMouse ? Qt.darker("#32475c",1.1) : "#32475c") :
                               (pauseMouseArea.pressed ? Qt.darker("#666",1.2) : pauseMouseArea.containsMouse ? Qt.darker("#666",1.1) : "#666")

                    border.color:  "grey"
                    border.width:  1
                }

                // Левая палочка
                Rectangle {
                    width: 5
                    height: 16
                    radius: 2
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.horizontalCenter
                    anchors.rightMargin: 2
                }

                // Правая палочка
                Rectangle {
                    width: 5
                    height: 16
                    radius: 2
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.horizontalCenter
                    anchors.leftMargin: 2
                }

            }


            Item {
                width: 60
                height: 60
                visible: endlessMode && !gameOverOverlay.visible && !countdownOverlay.visible


                MouseArea {
                    id: endMouseArea
                    anchors.fill: parent
                    onClicked: root.endGame()
                    cursorShape: Qt.PointingHandCursor
                }

                Rectangle {

                    anchors.fill: parent
                    radius: width / 2
                    color: Material.theme === Material.Dark ?
                               (endMouseArea.pressed ? Qt.darker("#32475c",1.2) : endMouseArea.containsMouse ? Qt.darker("#32475c",1.1) : "#32475c") :
                               (endMouseArea.pressed ? Qt.darker("#666",1.2) : endMouseArea.containsMouse ? Qt.darker("#666",1.1) : "#666")
                    border.color:  "grey"
                    border.width:  1
                }

                Rectangle {
                    width: 14
                    height: 14
                    color: "white"
                    radius: 3
                    anchors.centerIn: parent
                }


            }
        }
    }



    // Игровое поле
    Rectangle {
        id: gameArea
        anchors {
            top: topBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: "transparent"
        z: 5

        Label{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -200
            text: (clickCount > 0) ? "Последняя попытка: " + lastReactionTime + " мс": "Последняя попытка: — мс"
            font.pixelSize: 32
        }

        MouseArea {
               id: gameMouseArea
               anchors.fill: parent
               enabled: !countdownOverlay.visible && !gameOverOverlay.visible && !paused
               onClicked: {
                   if (waitingForGreen && !isGreen) {
                       falseStarts++
                       waitNext()
                   } else if (isGreen) {
                       const reactionTime = Date.now() - roundStartTime
                       lastReactionTime = reactionTime
                       totalReactionTime += reactionTime
                       if (reactionTime < bestReactionTime)
                           bestReactionTime = reactionTime
                       clickCount++
                       roundCount++
                       waitNext()
                   }
               }
           }

        Rectangle {
            id: circle
            width: 200
            height: 200
            radius: 100
            color: isGreen ? "limegreen" : "crimson"
            anchors.centerIn: parent
            visible: waitingForGreen || isGreen
        }
    }

    // Оверлей окончания
    Rectangle {
        id: gameOverOverlay
        visible: false
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.6)
        z: 1000

        Rectangle {
            id: dialogRect
            width: 800
            height: 300
            radius: 12
            anchors.centerIn: parent

            color: Material.theme === Material.Light ? "#C9E9FF" : "#2c3e50"
            border.color: Material.theme === Material.Light ? "#cccccc" : "#34495e"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                spacing: 16
                anchors.margins: 16

                Label {
                    text: "Тренировка окончена!"
                    font.pixelSize: 26

                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                }
                Item {
                    Layout.fillHeight: true // занимает все свободное пространство, сдвигая остальные элементы
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    spacing: 8


                    Label {
                        text: "Среднее время: " + (root.clickCount > 0
                                                   ? Math.round(root.totalReactionTime / root.clickCount) + " мс"
                                                   : "—")
                        font.pixelSize: 20

                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    Label {
                        text: "Лучшее время: " + (root.bestReactionTime < 999999
                                                  ? Math.round(root.bestReactionTime) + " мс"
                                                  : "—")
                        font.pixelSize: 20
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    Label {
                        text: "Фальстарты: " + root.falseStarts
                        font.pixelSize: 20
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }

                Item {
                    Layout.fillHeight: true // занимает все свободное пространство, сдвигая остальные элементы
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing:50


                    Button {
                        text: "Сыграть снова"

                        width:300
                        onClicked: resetGame()
                    }
                    Button {
                        text: "Выйти к настройкам"
                        width:300

                        onClicked: {
                            stackViewRef.pop()
                        }
                    }

                }
            }
        }
    }

    // Оверлей паузы
    Rectangle {
        id: pauseOverlay
        anchors.fill: parent
        visible: paused
        color: "#00000066"
        z: 90

        Rectangle {
            width: 150
            height: 150
            radius: width / 2
            color: Qt.rgba(0, 0, 0, 0.6)
            anchors.centerIn: parent

            Text {
                text: "Пауза"
                anchors.centerIn: parent
                font.pixelSize: 28
                color: "white"
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (root.paused) {
                    root.togglePause()
                }
            }
        }
    }

    Rectangle {
        id: countdownOverlay
        anchors.fill: parent
        visible: false
        color: "#00000066"
        z: 95

        property int countdownValue: 3

        Timer {
            id: countdownStartTimer
            interval: 1000
            running: false
            repeat: true
            onTriggered: {
                countdownOverlay.countdownValue--
                if (countdownOverlay.countdownValue < 0) {
                    countdownStartTimer.stop()
                    countdownOverlay.visible = false
                    startGame()  // запускать только после окончания отсчёта
                }
            }

        }

        Rectangle {
            width: 200
            height: 200
            radius: width / 2
            color: Qt.rgba(0, 0, 0, 0.6)
            anchors.centerIn: parent

            Text {
                anchors.centerIn: parent
                width: parent.width
                text: countdownOverlay.countdownValue > 0
                      ? countdownOverlay.countdownValue
                      : "Старт!"                      // 🔧 Здесь — фикс!
                font.pixelSize: 48
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }




    // --- Логика игры --- //

    function showGreen() {
        isGreen = true
        waitingForGreen = true
        roundStartTime = Date.now()
    }

    function waitNext() {
        isGreen = false
        waitingForGreen = false

        if (!endlessMode && roundCount >= totalRounds) {
            gameOverOverlay.visible = true
        } else {
            waitingForGreen = true
            waitTimer.interval = 1000 + Math.random() * 3000
            if (!paused) {
                waitTimer.restart()
            }
        }
    }

    function resetGame() {
        roundCount = 0
        clickCount = 0
        totalReactionTime = 0
        bestReactionTime = 999999

        isGreen = false
        waitingForGreen = false

        waitTimer.stop()            // остановить таймер ожидания появления зеленого круга
        countdownStartTimer.stop()  // остановить таймер отсчёта (на всякий случай)

        gameOverOverlay.visible = false
        paused = false

        countdownOverlay.countdownValue = 3
        countdownOverlay.visible = true
        countdownStartTimer.start() // запустить отсчёт заново
    }



    function startGame() {
        isGreen = false          // круг пока не зеленый
        waitingForGreen = true   // мы ждём момента зеленого круга, но круг виден

        waitTimer.interval = 1000 + Math.random() * 3000
        if (!paused) {
            waitTimer.start()
        }
    }



    function togglePause() {
        paused = !paused
        if (paused) {
            waitTimer.stop()
        } else {
            if (waitingForGreen) {
                waitTimer.restart()
            }
        }
    }

    function endGame() {
        gameOverOverlay.visible = true
    }

    Component.onCompleted: resetGame()
}

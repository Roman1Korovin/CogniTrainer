import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    visible: true
    anchors.fill: parent

    property StackView stackViewRef
    property var moduleData

    property int difficultyValue: moduleData ? moduleData.difficulty : 5
    property bool endlessMode: moduleData && moduleData.endlessMode === true

    property int clickCount: 0
    property int roundCount: 0
    property int totalRounds: 40
    property bool answeredThisRound: false
    property bool processingRound: false

    property bool paused: false


    Rectangle {
        anchors.fill: parent
        color: "#ffffff"


        // Верхняя панель
        Rectangle {
            id: topBar
            height: 65
            width: parent.width
            color: "#f0f0f0"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            border.color: "#cccccc"

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
                    color: backArea.pressed ? Qt.darker("white",1.2) : backArea.containsMouse ? Qt.darker("white",1.1) : "white"
                    radius: 8
                    border.color:  "#a0a0a0"
                    border.width: 1


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
                        source: moduleData.iconArrowUrl
                        width: 40
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: moduleData && moduleData.name ? moduleData.name : "Без названия"
                        font.pixelSize: 26
                        color: "black"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }


            }

            Text {
                text: "Попаданий: " + root.clickCount + " из " + root.roundCount + " (" +
                      (root.roundCount > 0
                       ? Math.round(root.clickCount / root.roundCount * 100) + " %"
                       : "0%") + ")"
                font.pixelSize: 26
                color: "#333"
                visible: !gameOverOverlay.visible
                Layout.alignment: Qt.AlignVCenter
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 20
            }


            RowLayout{
                anchors.centerIn: parent
                Item {
                    width: 60
                    height: 60
                    visible: endlessMode && !gameOverOverlay.visible && !countdownOverlay.visible

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: "#666666"
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

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.togglePause()
                        cursorShape: Qt.PointingHandCursor
                    }

                    Layout.alignment: Qt.AlignVCenter
                }


                Item {
                    width: 60
                    height: 60
                    visible: endlessMode && !gameOverOverlay.visible && !countdownOverlay.visible

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: "#666666"
                    }

                    Rectangle {
                        width: 14
                        height: 14
                        color: "white"
                        radius: 3
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.endGame()
                        cursorShape: Qt.PointingHandCursor
                    }

                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }


        Item {
            id: hitMarkerLayer
            anchors.fill: parent
        }

        Rectangle {
            id: circle
            visible: false
            radius: width / 2
            property int maxSize: 200
            property int minSize: 60

            width: {
                const clamped = Math.max(1, Math.min(10, root.difficultyValue));
                return maxSize - (clamped - 1) * ((maxSize - minSize) / 9);
            }
            height: width
            color: "dodgerblue"

            function moveToRandomPosition() {
                const h = root.height - topBar.height;
                x = Math.random() * (root.width - width);
                y = topBar.height + Math.random() * (h - height);
            }

            MouseArea {
                id: circleMouseArea
                anchors.fill: parent
                enabled: false
                onClicked: {
                    if (!circle.visible || root.answeredThisRound)
                        return;

                    root.answeredThisRound = true;
                    root.clickCount++;
                    root.roundCount++;
                    root.createMarker("#00ff00");

                    if (!endlessMode && root.roundCount >= root.totalRounds) {
                        root.endGame();
                    } else {
                        circle.visible = false;
                        Qt.callLater(() => {
                                         root.answeredThisRound = false;
                                         circle.moveToRandomPosition();
                                         circle.visible = true;
                                         circleMouseArea.enabled = true;
                                         autoMoveTimer.restart();
                                     });
                    }
                }
            }
        }


        Rectangle {
            id: gameOverOverlay
            visible: false
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.6)
            z: 1000

            Rectangle {
                width: 800
                height: 300
                radius: 12
                anchors.centerIn: parent
                color: "#ffffff"
                border.color: "#cccccc"
                border.width: 1

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 16
                    anchors.margins: 16

                    Text {
                        text: "Тренировка\nзавершена!"
                        font.pixelSize: 26
                        color: "black"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    }
                    Item {
                        Layout.fillHeight: true // занимает все свободное пространство, сдвигая остальные элементы
                    }
                    Text {
                        text: "Точность: " +
                              (root.roundCount > 0
                               ? Math.round(root.clickCount / root.roundCount * 100) + " %"
                               : "0 %")
                        font.pixelSize: 20
                        color: "black"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                    Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing:50

                        Button {
                            text: "Сыграть снова"

                            onClicked: {
                                root.clickCount = 0;
                                root.roundCount = 0;
                                root.answeredThisRound = false;
                                root.processingRound = false;
                                gameOverOverlay.visible = false;
                                countdownOverlay.countdownValue = 3;
                                countdownOverlay.visible = true;
                                countdownTimer.start();
                                autoMoveTimer.stop();
                                circle.visible = false;
                            }
                        }
                        Button {
                            text: "Выйти к настройкам"

                            onClicked: {
                                stackViewRef.pop()
                            }
                        }

                    }

                }
            }
        }

        Item {
            id: countdownOverlay
            anchors.fill: parent
            visible: true
            z: 999
            property int countdownValue: 3

            Rectangle {
                width: 200
                height: 200
                radius: width / 2
                color: Qt.rgba(0, 0, 0, 0.6)
                anchors.centerIn: parent

                Text {
                    text: countdownOverlay.countdownValue > 0 ? countdownOverlay.countdownValue : "Старт!"
                    anchors.centerIn: parent
                    font.pixelSize: 50
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                }
            }


        }

        Item {
            id: pauseOverlay
            anchors.fill: parent
            visible: false
            z: 998

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
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Синхронизируем состояние паузы при клике на оверлей
                    if (root.paused) {
                        root.togglePause();
                    }
                }
            }
        }
    }

    Timer {
        id: autoMoveTimer
        interval: 3000 - (root.difficultyValue * 250)
        repeat: true
        running: false

        onTriggered: {
            if (root.answeredThisRound)
                return;

            root.answeredThisRound = true;
            root.roundCount++;
            root.createMarker("#ff0000");

            if (!endlessMode && root.roundCount >= root.totalRounds) {
                root.endGame();
            } else {
                circle.visible = false;
                Qt.callLater(() => {
                                 root.answeredThisRound = false;
                                 circle.moveToRandomPosition();
                                 circle.visible = true;
                                 circleMouseArea.enabled = true;
                                 autoMoveTimer.restart();
                             });
            }
        }
    }

    Timer {
        id: countdownTimer
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            countdownOverlay.countdownValue--;
            if (countdownOverlay.countdownValue < 0) {
                countdownTimer.stop();
                countdownOverlay.visible = false;
                autoMoveTimer.start();

                circle.moveToRandomPosition();
                circle.visible = true;
                circleMouseArea.enabled = true;
            }
        }
    }

    function createMarker(color) {
        var marker = Qt.createQmlObject(`
                                        import QtQuick 2.15
                                        Rectangle {
                                        id: markerRect
                                        width: ${circle.width}
                                        height: ${circle.height}
                                        radius: width / 2
                                        color: "${color}"
                                        opacity: 0.5
                                        x: ${circle.x}
                                        y: ${circle.y}
                                        z: -1

                                        SequentialAnimation {
                                        running: true
                                        PropertyAnimation {
                                        target: markerRect
                                        property: "opacity"
                                        to: 0
                                        duration: 800
                                        }
                                        ScriptAction {
                                        script: markerRect.destroy()
                                        }
                                        }
                                        }
                                        `, hitMarkerLayer);
    }

    function endGame() {
        autoMoveTimer.stop();
        gameOverOverlay.visible = true;
        circle.visible = false;
    }


    function togglePause() {
        paused = !paused;
        if (paused) {
            autoMoveTimer.stop();
            circle.visible = false;
            circleMouseArea.enabled = false;
            pauseOverlay.visible = true;
        } else {
            pauseOverlay.visible = false;
            circle.moveToRandomPosition();
            circle.visible = true;
            circleMouseArea.enabled = true;
            autoMoveTimer.start();
        }
    }
}

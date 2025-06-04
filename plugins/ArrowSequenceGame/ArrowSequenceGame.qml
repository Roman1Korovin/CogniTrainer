import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Item {
    id: root
    focus: true
    Keys.forwardTo: []
    property var moduleData
    property var stackViewRef



    property var directions: ["left", "up", "right", "down"]
    property var currentSequence: []
    property int round: 0
    property int targetRound: 10
    property int inputIndex: 0

    property double trainingTime: 0
    property double startTime: 0
    property double avgRoundTime: 0

    property bool errorFlash: false
    property bool successFlash: false

    property int difficultyMode
    property bool endlessMode
    property bool blindMode

    property int difficultyLength: {
        switch (difficultyMode) {
        case 1: return 3
        case 2: return 4
        case 3: return 5
        case 4: return 6
        case 5: return 7
        case 6: return 8
        case 7: return 9
        case 8: return 10
        case 9: return 11
        case 10: return 12
        case 11: return 13
        case 12: return 14
        case 13: return 15

        default: return 3
        }
    }

    Component.onCompleted: {
        countdownTimer.start()

    }


    Timer {
        id: updateTimer
        interval: 100
        running: false
        repeat: true
        onTriggered: {
            if (startTime > 0) {

                trainingTime = (Date.now() - startTime) / 1000.0
            }
        }
    }

    Timer {
        id: errorFlashResetTimer
        interval: 300
        running: false
        repeat: false
        onTriggered: errorFlash = false
    }

    Timer {
        id: countdownTimer

        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            countdownOverlay.countdownValue--;
            if (countdownOverlay.countdownValue < 0) {
                countdownTimer.stop();
                countdownOverlay.visible = false;
                mainScreen.visible = true

                updateTimer.start()
                startTime = Date.now()
                startRound()
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



    function generateSequence() {
        let result = []
        for (let i = 0; i < difficultyLength; i++) {
            result.push(directions[Math.floor(Math.random() * 4)])
        }
        return result
    }

    function startRound() {
        currentSequence = generateSequence()
        inputIndex = 0
    }



    function endGame() {
        updateTimer.stop()
        avgRoundTime = trainingTime / round
        gameOverOverlay.visible = true

    }

    function resetParams() {
        gameOverOverlay.visible = false
        round = 0
        trainingTime = 0
        avgRoundTime = 0
        countdownOverlay.countdownValue = 3
        countdownOverlay.visible = true
        mainScreen.visible = false
        countdownTimer.start()

    }

    function processInput(dir) {
        if (currentSequence[inputIndex] === dir) {
            inputIndex++
            if (inputIndex === currentSequence.length) {
                successFlash = true

                Qt.createQmlObject(`
                                   import QtQuick 2.0
                                   Timer {
                                   interval: 500
                                   repeat: false
                                   onTriggered: {
                                   successFlash = false
                                   round++
                                   if (!endlessMode && targetRound <= round) {
                                   endGame()
                                   } else {
                                   startRound()
                                   }
                                   }
                                   }
                                   `, parent, "SuccessTimer").start()
            }

        } else {
            inputIndex = 0 // сброс при ошибке
            errorFlash = true
            errorFlashResetTimer.restart()
        }
    }

    Keys.onPressed: (event) => {
        const ch = event.text.toLowerCase()

        switch (event.key) {
            case Qt.Key_Left:
                processInput("left")
                break
            case Qt.Key_Up:
                processInput("up")
                break
            case Qt.Key_Right:
                processInput("right")
                break
            case Qt.Key_Down:
                processInput("down")
                break
            default:
                switch (ch) {
                    case "a": case "ф":
                        processInput("left")
                        break
                    case "w": case "ц":
                        processInput("up")
                        break
                    case "d": case "в":
                        processInput("right")
                        break
                    case "s": case "ы":
                        processInput("down")
                        break
                }
                break
        }
    }

    // Верхняя панель
    Rectangle {
        id: topBar
        height: 75
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

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
                           (backArea.pressed ? Qt.darker("#32475c",1.2) : backArea.containsMouse ? Qt.darker("#32475c",1.1) : "#32475c") :
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
                    text: moduleData && moduleData.name ? moduleData.name : ""
                    font.pixelSize: 26
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

        }

        Row{


            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
            spacing: 50


            Label {
                text: "Время тренировки: " + trainingTime.toFixed(0) + " сек"
                font.pixelSize: 26
            }

        }

        Item {
            width: 60
            height: 60

            anchors.horizontalCenter: parent.horizontalCenter
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

    //основной экран
    Column {
        id: mainScreen
        visible: false
        anchors.centerIn: parent
        spacing: 40


        Label {
            text: "Раунд: " + (round + 1) + (endlessMode ? "" : " / " + targetRound)
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 26
            font.weight: Font.DemiBold

        }

        Item {
            width: 1
            height: 30
        }

        Row {
            spacing: 20
            Repeater {
                model: currentSequence.length
                Rectangle {
                    width: 64
                    height: 64
                    radius: 8
                    border.width: 1
                    border.color: "#ccc"

                    color: {
                        if (errorFlash) return "red"
                        else if (successFlash) return "lightgreen"
                        else if (index < inputIndex) return "lightgreen"
                        else return "#f0f0f0"
                    }
                    scale: (errorFlash || successFlash) ? 1.3 : 1.0
                    transformOrigin: Item.Center

                    Behavior on color {
                        ColorAnimation {
                            duration: errorFlash ? 200 : 0
                        }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }

                    Image {
                        anchors.centerIn: parent
                        source: moduleData.iconArrowDarkUrl
                        visible: blindMode ? false : true
                        width: 40
                        fillMode: Image.PreserveAspectFit

                        rotation: {
                            switch (currentSequence[index]) {
                            case "left": return 0
                            case "up": return 90
                            case "right": return 180
                            case "down": return -90
                            }
                        }
                    }
                }
            }
        }

        Text {
            text: "Управление: ← ↑ → ↓ или WASD"
            font.pixelSize: 20
            color: "#777"
            anchors.horizontalCenter: parent.horizontalCenter
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
            color: Material.theme === Material.Light ? "white" : "#2c3e50"
            border.color: Material.theme === Material.Light ? "#cccccc" : "#34495e"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                Label {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    text: "Тренировка\nзавершена!"
                    font.pixelSize: 26
                }

                Item {
                    Layout.fillHeight: true // занимает все свободное пространство, сдвигая остальные элементы
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    spacing: 8

                    Label{
                        text: "Раундов пройдено: " + round
                        font.pixelSize: 20
                    }
                     Label {
                        text: "Время тренировки: " + trainingTime.toFixed(2) + " сек"
                        font.pixelSize: 20

                    }
                    Label {
                        text: round != 0 ?"Среднее время раунда: " + avgRoundTime.toFixed(2) + " сек" : ""
                        font.pixelSize: 20

                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing:50

                    Button {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                        text: "Сыграть снова"
                        width:300

                        onClicked: {
                            resetParams()
                        }
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
}

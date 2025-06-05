import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Item {
    id:root
    property var moduleData
    property var stackViewRef

    Rectangle {
        id: gameArea
        anchors.fill: parent

        color: Material.background

        property bool isPaused: false

        //Данные
        property var colorNames: ["Красный", "Синий", "Зелёный", "Жёлтый", "Чёрный", "Белый"]
        property var colorValues: ["red", "blue", "green", "yellow", "black", "white"]
        property string currentWord: ""
        property string currentColor: ""
        property string correctAnswer: ""

        property var buttonTextColors: []

        property int correctCount: 0

        property string selectedAnswer: ""
        property bool answerCorrect: false

        //Состояния
        property real timeLeft: 3
        property int score: 0
        property int currentRound: 0
        property int maxRounds: 10
        property int roundDuration: 3000

        property bool isCountdownActive: true


        //верхняя панель
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
                        border.color: "grey"
                        border.width: 2
                    }

                    Row {
                        id: row
                        spacing: 20
                        anchors.fill: parent
                        leftPadding: 10
                        rightPadding: 10
                        Layout.alignment: Qt.AlignVCenter

                        Image {
                            source: Material.theme === Material.Dark ?moduleData.iconArrowLightUrl : moduleData.iconArrowDarkUrl
                            width: 40
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                            anchors.verticalCenter: parent.verticalCenter
                        }

                       Label {
                            text: moduleData?.name || ""
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
                        id: roundsCounter
                        text: moduleData.endlessMode
                            ? (gameArea.currentRound === 0 ? "" : "Правильно: " + gameArea.correctCount + " из " + (gameArea.currentRound-1))
                            : "Слово " + gameArea.currentRound + " из " + gameArea.maxRounds
                        font.pixelSize: 26
                    }
                }


                RowLayout{
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.horizontalCenter: parent.horizontalCenter


                    Item {
                        width: 60
                        height: 60
                        visible: moduleData.endlessMode && !gameOverOverlay.visible && !countdownOverlay.visible

                        MouseArea {
                            id: endMouseArea
                            anchors.fill: parent
                            onClicked: gameArea.endGame()
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

        //Основной экран

        // Обратный отсчёт
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
                    id: countdownText
                    text: countdownOverlay.countdownValue > 0 ? countdownOverlay.countdownValue : "Старт!"
                    anchors.centerIn: parent
                    font.pixelSize: 50
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Timer {
                id: countdownStartTimer
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    countdownOverlay.countdownValue--
                    if (countdownOverlay.countdownValue < 0) {
                        countdownStartTimer.stop()
                        countdownOverlay.visible = false
                        gameArea.isCountdownActive = false
                        gameArea.startGame()
                    }
                }
            }
        }

        Timer {
            id: countdownTimer
            interval: 100
            repeat: true
            running: false
            onTriggered: {
                if (!gameArea.isPaused && gameArea.roundDuration > 0) {
                    gameArea.timeLeft -= 0.1
                    if (gameArea.timeLeft <= 0) {
                        countdownTimer.stop()
                        gameArea.nextRound(false)
                    }
                }
            }
        }

        Timer {
            id: answerFeedbackTimer
            interval: 300
            running: false
            repeat: false
            onTriggered: {
                gameArea.selectedAnswer = ""
                gameArea.nextRound(true)
            }
        }

        function startGame() {
            gameArea.score = 0
            gameArea.correctCount = 0
            gameArea.currentRound = 0
            gameOverOverlay.visible = false
            gameArea.isPaused = false

            let difficulty = moduleData.difficulty
            if (difficulty === 1) {
                gameArea.roundDuration = -1
            } else {
                let maxTime = 10000
                let minTime = 1500
                gameArea.roundDuration = maxTime - ((difficulty - 1) * (maxTime - minTime) / 9)
            }

            gameArea.nextRound()
        }


        function nextRound(isUserAnswer = false) {
            if (!moduleData.endlessMode && gameArea.currentRound >= gameArea.maxRounds) {
                gameOverOverlay.visible = true
                countdownTimer.stop()
                return
            }
            console.log("Цвета кнопок:", gameArea.buttonTextColors.join(", "))

            if (!gameArea.isPaused) {
                gameArea.currentRound++

                // Подготовка нового слова и цвета
                let wordIndex = Math.floor(Math.random() * gameArea.colorNames.length)
                let colorIndex = Math.floor(Math.random() * gameArea.colorValues.length)

                gameArea.currentWord = gameArea.colorNames[wordIndex]
                gameArea.currentColor = gameArea.colorValues[colorIndex]
                gameArea.correctAnswer = gameArea.colorNames[colorIndex]

                // Генерируем массив случайных цветов для кнопок (тексты)
                let newColors = []
                for (let i = 0; i < gameArea.colorNames.length; i++) {
                    let randomColorIndex = Math.floor(Math.random() * gameArea.colorValues.length)
                    newColors.push(gameArea.colorValues[randomColorIndex])
                }
                gameArea.buttonTextColors = newColors


                gameArea.timeLeft = gameArea.roundDuration > 0 ? gameArea.roundDuration / 1000.0 : -1
                if (gameArea.roundDuration > 0) {
                    countdownTimer.restart()
                }
            }
        }


        function checkAnswer(answer) {
            if (gameArea.isPaused) return
            countdownTimer.stop()
            selectedAnswer = answer
            answerCorrect = (answer === correctAnswer)

            if (answerCorrect) {
                gameArea.score++
                gameArea.correctCount++
            }

            answerFeedbackTimer.start()
        }



        Item {
            id: contentArea
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -200


            Text {
                id: wordText
                text: gameArea.currentWord
                visible: gameArea.currentWord !== "" && !gameArea.isCountdownActive
                color: gameArea.currentColor
                font.pixelSize: 60
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                layer.enabled: true
                layer.effect: DropShadow {
                    color: "black"
                    radius: 10
                    samples: 32  // большее сглаживание
                    horizontalOffset: 0
                    verticalOffset: 0
                    transparentBorder: true
                }
            }




            GridLayout {
                id: colorGrid
                columns: 3
                rowSpacing: 15
                columnSpacing: 15
                anchors.top: wordText.bottom
                anchors.topMargin: 70
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: gameArea.colorNames
                    delegate: Button {

                        required property string modelData
                        required property int index

                        text: modelData
                        enabled: !gameArea.isCountdownActive && gameArea.selectedAnswer === ""
                        onClicked: gameArea.checkAnswer(modelData)
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        implicitWidth: 300

                        background: Rectangle {
                            color: {
                                if (gameArea.selectedAnswer === modelData) {
                                    return gameArea.answerCorrect ? "#4caf50" : "#b00020" // зелёный/красный
                                } else {
                                    return Material.theme === Material.Dark ? "#2c3e50" : "#bdbdbd"
                                }
                            }
                            border.color: Material.theme === Material.Dark ? "#aaaaaa" : "#444444"
                            radius: 8

                            Behavior on color {
                                ColorAnimation {
                                    duration: 300
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }

                        contentItem: Text {
                            text: modelData
                            color: gameArea.buttonTextColors[index] !== undefined
                                   ? gameArea.buttonTextColors[index]
                                   : (Material.theme === Material.Dark ? "white" : "black")
                            font.pixelSize: 38
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.fill: parent
                            padding: 6

                            layer.enabled: color === "white" && Material.theme === Material.Light
                            layer.effect: DropShadow {
                                color: "black"
                                radius: 4
                                samples: 16
                                horizontalOffset: 0
                                verticalOffset: 0
                                transparentBorder: true
                            }
                        }
                    }
                }
            }

        }

        Rectangle {
            id: timerBarBackground
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 10
            color: Material.theme === Material.Dark ? "#444" : "#ccc"  // фон полосы

            Rectangle {
                id: timerBar
                height: parent.height
                width: parent.width * (gameArea.timeLeft * 1000 / gameArea.roundDuration)
                color: Material.theme === Material.Dark ? "#00FFFF" : "#4682B4"

                anchors.left: parent.left

                Behavior on width {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.Linear
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
                color: Material.theme === Material.Light ? "white" : "#2c3e50"
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


                    Label {
                        text: moduleData.endlessMode
                            ? "Точность: " + (gameArea.currentRound > 0 ? Math.round((gameArea.correctCount / (gameArea.currentRound-1)) * 100) : 0) + " %"
                            : "Точность: " + Math.round((gameArea.score / gameArea.maxRounds) * 100) + " %"
                        font.pixelSize: 20
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
                            width:300

                        onClicked: {
                            gameArea.isCountdownActive = true
                            countdownOverlay.countdownValue = 3
                            countdownOverlay.visible = true
                            countdownStartTimer.restart()
                            gameOverOverlay.visible = false
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


        Item {
            id: pauseOverlay
            anchors.fill: parent
            visible: gameArea.isPaused
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
                onClicked: gameArea.togglePause()
            }
        }

        function togglePause() {
            gameArea.isPaused = !gameArea.isPaused
            if (gameArea.isPaused) {
                countdownTimer.stop()
            } else if (!gameArea.isCountdownActive && gameArea.timeLeft > 0) {
                countdownTimer.start()
            }
        }

        function endGame() {
            countdownTimer.stop()
            gameOverOverlay.visible = true
        }


        Component.onCompleted: {
            gameArea.isCountdownActive = true
            countdownOverlay.countdownValue = 3
            countdownOverlay.visible = true
            countdownStartTimer.start()
        }
    }
}

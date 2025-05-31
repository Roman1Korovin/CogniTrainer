import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtTextToSpeech

Item {
    id: root

    property var moduleData
    property var stackViewRef
    property bool endlessMode
    property int wordDisplayMode  // 0 = всё время, 1 = 3 секунды, 2 = аудио
    property string currentWord: ""
    property string userInput: ""

    property int round: 0
    property int targetRound: 5

    property real startTime : 0
    property real averageWordTime : 0
    property real trainingTime: 0

    property bool showWord: true

    property bool hasError: false

    Timer {
        id: hideTimer
        interval: 3000
        repeat: false
        onTriggered: showWord = false
    }


    Component.onCompleted: {

        countdownTimer.start()
    }

    function initParameters() {


        round = 0
        startTime = Date.now()
        trainingTime = 0
        averageWordTime = 0

        mainScreen.visible = true
        textField.focus = true

        updateTimer.start()
        loadNextWord()
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
        id: countdownTimer

        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            countdownOverlay.countdownValue--;
            if (countdownOverlay.countdownValue < 0) {
                countdownTimer.stop();
                countdownOverlay.visible = false;

                initParameters()
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


    function loadNextWord() {
        if (moduleData && typeof moduleData.nextWord === "function") {
            currentWord = moduleData.nextWord()
            console.log("Получил слово: "+ currentWord)

            if (wordDisplayMode === 0) {
                showWord = true
            } else if (wordDisplayMode === 1) {
                hideTimer.start()
                showWord = true

            }else if (wordDisplayMode === 2)
            {
                showWord = false
                speech.say(currentWord)
            }
        }
    }


    // Верхняя панель
    Rectangle {
        id: topBar
        height: 65
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
                    source: moduleData && moduleData.iconArrowUrl ? moduleData.iconArrowUrl : ""
                    width: 40

                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: moduleData && moduleData.name ? moduleData.name : ""
                    font.pixelSize: 26
                    color: "black"
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



            Text {
                text: "Время тренировки: " + trainingTime.toFixed(0) + " сек"
                font.pixelSize: 26
                color: "black"

            }


            Text {
                text: !endlessMode ? "Осталось слов: " + (targetRound - round) : ""
                font.pixelSize: 26
                color: "black"
            }
        }

        Item {
            width: 60
            height: 60

            anchors.centerIn: parent
            visible: endlessMode && !gameOverOverlay.visible

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

    //основной экран

    TextToSpeech {
        id: speech

        locale: Qt.locale("ru_RU")
    }

    Column {
        id: mainScreen
        visible: false
        spacing: 80
        anchors.centerIn: parent

        Text {
            text: "Раунд: " + (round + 1) + (endlessMode ? "" : " / " + targetRound)
            font.pixelSize: 28
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: wordDisplay
            text: currentWord
            anchors.horizontalCenter:  parent.horizontalCenter
            font.pixelSize: 50
            font.bold: true
            visible: true

            opacity: showWord ? 1 : 0
        }

        TextField {
            id: textField
            width: 500

            font.pixelSize: 20
            text: userInput

            placeholderText: "Введите слово"


            onTextChanged: {
                userInput = text
                hasError = false
            }
            onActiveFocusChanged: {
                if (!activeFocus) {
                    hasError = false
                }
            }
            Material.accent: hasError? "red" : "gray"

        }

        Button {
            text: "Проверить"
            width:300
            font.pixelSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                if (moduleData && typeof moduleData.checkAnswer === "function") {
                    const correct = moduleData.checkAnswer(userInput)
                    if (correct){

                        round++
                        userInput = ""
                        hasError = false

                        hideTimer.stop()

                        //конец тренировки
                        if (round === targetRound && !endlessMode) {

                            endGame()
                            return
                        }

                        loadNextWord()



                    } else {
                        hasError = true
                        textField.focus = true
                    }
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
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                Text {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    text: "Тренировка\nзавершена!"
                    font.pixelSize: 26
                    color: "black"
                }

                Item {
                    Layout.fillHeight: true // занимает все свободное пространство, сдвигая остальные элементы
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    spacing: 8

                    Text {
                        text: endlessMode ? "Слов пройдено: " + round: ""
                        font.pixelSize: 18
                        color: "black"
                    }
                    Text {
                        text: "Время тренировки: " + trainingTime.toFixed(2) + " сек"
                        font.pixelSize: 18
                        color: "black"

                    }
                    Text {
                        text: round != 0 ?"Среднее время на слово: " + averageWordTime.toFixed(2) + " сек" : ""
                        font.pixelSize: 18
                        color: "black"

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
                        width: 150
                        onClicked: {
                            resetParams()
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

    function endGame()
    {
        averageWordTime = trainingTime/ round

        gameOverOverlay.visible = true
        updateTimer.stop()
    }

    function resetParams()
    {
        gameOverOverlay.visible = false
        countdownOverlay.countdownValue = 3
        countdownOverlay.visible = true
        mainScreen.visible = false


        round = 0
        trainingTime = 0
        averageWordTime = 0

        countdownTimer.restart()
    }
}

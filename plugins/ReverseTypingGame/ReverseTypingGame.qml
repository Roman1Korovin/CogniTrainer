import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtTextToSpeech

Item {
    id: root

    property var moduleData
    property var stackViewRef
    property bool endlessMode: false
    property int wordDisplayMode: 0 // 0 = всё время, 1 = 3 секунды, 2 = аудио
    property string currentWord: ""
    property string userInput: ""

    property int score: 0
    property int targetScore: 2

    property real startTime : 0
    property real averageWordTime : 0
    property real trainingTime: 0


    property bool hasError: false

    Timer {
        id: hideTimer
        interval: 3000
        repeat: false
        onTriggered: wordDisplay.visible = false
    }

    Component.onCompleted: {

        textField.focus = true
        initParameters()
    }

    function initParameters() {

        loadNextWord()
        startTime = Date.now()
        updateTimer.start()
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


    function loadNextWord() {
        if (moduleData && typeof moduleData.nextWord === "function") {
            currentWord = moduleData.nextWord()
            console.log("Получил слово: "+ currentWord)

            if (wordDisplayMode === 0) {
                wordDisplay.visible = true
            } else if (wordDisplayMode === 1) {
                hideTimer.start()
                wordDisplay.visible = true

            }else if (wordDisplayMode === 2)
            {
                wordDisplay.visible = false
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
                text: !endlessMode ? "Осталось слов: " + (targetScore - score) : ""
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

    TextToSpeech {
        id: speech
        locale: Qt.locale("ru_RU")
    }

    Column {
        spacing: 20
        anchors.centerIn: parent

        Text {
            id: wordDisplay
            text: currentWord
            font.pixelSize: 32
            visible: true
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
            onClicked: {
                if (moduleData && typeof moduleData.checkAnswer === "function") {
                    const correct = moduleData.checkAnswer(userInput)
                    if (correct){

                         score++
                        userInput = ""
                        hasError = false



                        hideTimer.stop()
                        hideTimer.start()

                        //конец тренировки
                        if (score === targetScore && !endlessMode) {

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

        Text {
            text: "Текущий счёт: " + score
            font.pixelSize: 22
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
                        text: endlessMode ? "Слов пройдено: " + score: ""
                        font.pixelSize: 18
                        color: "black"
}
                    Text {
                        text: "Время тренировки: " + trainingTime.toFixed(2) + " сек"
                        font.pixelSize: 18
                        color: "black"

                    }
                    Text {
                        text: score != 0 ?"Среднее время на слово: " + averageWordTime.toFixed(2) + " сек" : ""
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
        averageWordTime = trainingTime/ score

        gameOverOverlay.visible = true
        updateTimer.stop()
    }

    function resetParams()
    {
        gameOverOverlay.visible = false

        score = 0
        startTime = Date.now()
        trainingTime = 0
        averageWordTime = 0

        updateTimer.start()
        loadNextWord()

    }
}

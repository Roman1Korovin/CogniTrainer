import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id:root

    property var moduleData
    property var stackViewRef

    property string fullText: ""
    property var allSentences: moduleData.sentences
    property int currentIndex: 0
    property var stateList: []

    property int totalTyped: 0             // Общее количество вводов
    property int correctTyped: 0           // Количество правильных символов
    property real startTime: 0             // Время начала тренировки
    property real elapsedTime: 0           // Прошедшее время
    property real spm: 0                   // Скорость в символах в минуту (speed per minute)
    property real accuracy: 0              // Точность в процентах
    property bool timerRunning: false


    Component.onCompleted: {
          console.log(allSentences)

           generateFullText()
           stateList = new Array(fullText.length).fill(0)
           forceActiveFocus()
    }

    function generateFullText() {
        if (allSentences && allSentences.length >= 5) {
            var copy = allSentences.slice()
            var selected = []
            for (var i = 0; i < 5; i++) {
                var index = Math.floor(Math.random() * copy.length)
                selected.push(copy.splice(index, 1)[0])
            }
            fullText = selected.join(" ")  // Объединить в одну строку с пробелами
        } else {
            console.warn("Недостаточно предложений в allSentences")
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
                    source: moduleData && moduleData.iconArrowPath ? moduleData.iconArrowPath : ""
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
                text: "Скорость: " + spm.toFixed(1) + " сим/мин"
                font.pixelSize: 26
                color: "black"
            }

            Text {
                text: "Точность: " + accuracy.toFixed(1) + "%"
                font.pixelSize:26
                color: "black"

            }
        }

    }
    //основной экран
    Item {
        id: contentArea
        anchors {
            top: topBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        Column {

            id:column
            anchors.centerIn: parent

            Text {
                id: displayText
                width: contentArea.width * 0.5
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.pixelSize: 24
                textFormat: Text.RichText
                horizontalAlignment: Text.AlignHCenter

                text: {
                    var result = ""

                    for (var i = 0; i < fullText.length; i++) {
                        var c = fullText[i]
                        var style = ""

                        if (stateList[i] === 1) {
                            style += "background-color:#ccffcc;"
                        } else if (stateList[i] === 2) {
                            style += "background-color:#ffcccc;"
                        }

                        if (i === currentIndex) {
                            style += "text-decoration: underline;"
                        }

                        if (style.length > 0) {
                            result += "<span style='" + style + "'>" + c + "</span>"
                        } else {
                            result += c
                        }
                    }
                    return result
                }

            }

            Item {
                width: 1
                height: Math.max(root.height * 0.03, 5)
            }

            Button {
                text: "Перезапустить"
                width: 150

                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    resetParams()
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
                    spacing: 20

                    Text {
                        text: "Скорость: " + spm.toFixed(1) + " символов в минуту"
                        font.pixelSize: 18
                        color: "black"

                    }
                    Text {
                        text: "Точность: " + accuracy.toFixed(1) + "%"
                        font.pixelSize: 18
                        color: "black"

                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                Button {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    text: "Сыграть снова"
                    width: 150
                    onClicked: {
                       resetParams()
                    }
                }
            }
        }
    }


    Timer {
        id: updateTimer
        interval: 1000  // 1 секунда
        running: false
        repeat: true
        onTriggered: {
            if (startTime > 0) {
                elapsedTime = (Date.now() - startTime) / 1000.0
                if (elapsedTime > 0) {
                    spm = (correctTyped / elapsedTime) * 60.0
                    accuracy = totalTyped > 0 ? (correctTyped / totalTyped) * 100.0 : 0
                }
            }
        }
    }

    function resetParams()
    {
        fullText = ""
        generateFullText()
        currentIndex = 0
        stateList = new Array(fullText.length).fill(0)
        correctTyped = 0
        startTime = 0
        elapsedTime = 0
        spm = 0
        accuracy = 0
        timerRunning = false
        updateTimer.stop()
        gameOverOverlay.visible = false
        root.forceActiveFocus()
    }

    Keys.onPressed: function(event) {

        var inputChar = event.text
        if (inputChar === "") return

        if (!timerRunning) {
                startTime = Date.now()
                updateTimer.start()
                timerRunning = true
            }

            totalTyped++

        var expectedChar = fullText[currentIndex]
        if (inputChar === expectedChar) {
            stateList[currentIndex] = 1
            stateList = stateList
            currentIndex++
            correctTyped++

            if (currentIndex >= fullText.length) {
                updateTimer.stop()
                           timerRunning = false
                           gameOverOverlay.visible = true
                    }

        } else {
            stateList[currentIndex] = 2
            stateList = stateList         //заставляю сработать триггер на изменение текста
        }
        event.accepted = true
    }
}

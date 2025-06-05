import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    property var moduleData
    property var stackViewRef

    property int score: 0
    property int currentRound: -1
    property int maxRounds: 10

    property color baseColor: "#6699cc"
    property color targetColor: "#6699cc"
    property var figuresData: []

    property bool isCountdownActive: false
    property bool awaitingNextRound: false
    property int selectedIndex: -1
    property bool lastChoiceCorrect: false

    property int totalGridWidth: 0
    property int totalGridHeight: 0

    property bool isPaused: false
    property bool isGameOver: false

    Frame {
        anchors.fill: parent
    }

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
                text: moduleData.endlessMode
                      ? "Раунд: " + (currentRound+ 1)
                      : "Раунд: " + Math.min(currentRound + 1, maxRounds) +" / " + maxRounds
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



    RowLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        spacing: 10

        Item { Layout.fillWidth: true }


    }

    Item {
        id: playArea
        anchors {
            top: topBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom

            topMargin: parent.height * 0.1
            leftMargin: 20
            rightMargin: 20
            bottomMargin: parent.height * 0.1
        }

    }




    Item {
        id: figuresContainer
        anchors.centerIn: playArea
        width: totalGridWidth
        height: totalGridHeight
        visible: !root.isCountdownActive

        Repeater {
            model: figuresData
            delegate: Rectangle {
                width: modelData.size
                height: modelData.size
                radius: 10
                x: modelData.x
                y: modelData.y
                color: modelData.color
                border.color: {
                    if (root.awaitingNextRound) {
                        if (index === root.selectedIndex)
                            return root.lastChoiceCorrect ? "lime" : "red"
                        else if (modelData.isTarget)
                        {
                            return "#00BFFF"
                        }
                    }
                    return "black"
                }
                border.width:
                {
                    if (root.awaitingNextRound) {
                        if (index === root.selectedIndex)
                            return 3
                        else if (modelData.isTarget)
                        {
                            3
                        }
                    }
                    return 2
                }

                MouseArea {

                    anchors.fill: parent
                    enabled: !root.awaitingNextRound && !root.isCountdownActive && !root.isPaused
                    onClicked: {
                        root.selectedIndex = index
                        root.awaitingNextRound = true
                        root.lastChoiceCorrect = (modelData.isTarget === true)
                        if (root.lastChoiceCorrect) root.score++
                        selectionTimer.stop()
                        timerBarAnimation.stop()
                        nextRoundDelay.start()
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
        color: Material.theme === Material.Dark ? "#444" : "#ccc"

        Rectangle {
            id: timerBar
            visible: true
            height: parent.height
            width: parent.width
            color: Material.theme === Material.Dark ? "#00FFFF" : "#4682B4"
            anchors.left: parent.left
        }

        PropertyAnimation {
            id: timerBarAnimation
            target: timerBar
            property: "width"
            from: timerBarBackground.width
            to: 0
            duration: 5000
        }
    }


    Item {
        id: countdownOverlay
        anchors.fill: parent
        visible: false
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

        Timer {
            id: countdownTimer
            interval: 1000
            running: false
            repeat: true
            onTriggered: {
                countdownOverlay.countdownValue--
                if (countdownOverlay.countdownValue < 0) {
                    countdownTimer.stop()
                    countdownOverlay.visible = false
                    isCountdownActive = false
                    generateFigures()
                }
            }
        }
    }




    Timer {
        id: nextRoundDelay
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            if (root.isPaused) return
            awaitingNextRound = false
            selectedIndex = -1
            nextRound()
        }

    }

    Timer {
        id: selectionTimer
        interval: 5000
        running: false
        repeat: false
        onTriggered: {
            if (root.isPaused) return
            root.awaitingNextRound = true
            root.lastChoiceCorrect = false
            root.selectedIndex = -1
            nextRoundDelay.start()
        }

    }

    // окно окончания
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
                    text: root.moduleData && root.moduleData.endlessMode
                          ? "Результат: " + score + " из " + currentRound
                          : "Результат: " + score + " из " + maxRounds
                    font.pixelSize: 20
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
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
                        onClicked: {
                            gameOverOverlay.visible = false
                            startCountdown()
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

    function startCountdown() {
        score = 0
        currentRound = 0
        isGameOver = false
        isCountdownActive = true
        awaitingNextRound = false
        selectedIndex = -1
        lastChoiceCorrect = false
        countdownOverlay.countdownValue = 3
        countdownOverlay.visible = true
        countdownTimer.start()
    }

    function togglePause() {
        root.isPaused = !root.isPaused
        if (root.isPaused) {
            selectionTimer.stop()
            timerBarAnimation.pause()
        } else {
            if (!root.awaitingNextRound && !root.isCountdownActive) {
                selectionTimer.start()
                timerBarAnimation.resume()
            }
        }
    }


    function nextRound() {
         if (isGameOver) return

        if (!moduleData.endlessMode && (currentRound+1) >= maxRounds) {
            figuresData = []
            gameOverOverlay.visible = true
            return
        }
        currentRound++
        generateFigures()
    }

    function generateFigures() {
        if (playArea.width === 0 || playArea.height === 0) {
            Qt.callLater(generateFigures)
            return
        }

        let difficulty = moduleData && moduleData.difficulty ? moduleData.difficulty : 1
        difficulty = Math.max(1, Math.min(difficulty, 6))

        let figuresCount = Math.pow(4 + difficulty, 2)

        let r = Math.floor(Math.random() * 200) + 30
        let g = Math.floor(Math.random() * 200) + 30
        let b = Math.floor(Math.random() * 200) + 30
        baseColor = Qt.rgba(r / 255, g / 255, b / 255, 1)

        let shift = 0.04
        targetColor = Qt.rgba(
                    Math.min((r + shift * 255) / 255, 1),
                    Math.max((g - shift * 255) / 255, 0),
                    b / 255,
                    1
                    )

        let side = Math.ceil(Math.sqrt(figuresCount))
        let spacing = Math.max(1, 8 - difficulty)  // от 7 до 1
        let cellSize = Math.min(
                (playArea.width - spacing * (side + 1)) / side,
                (playArea.height - spacing * (side + 1)) / side
                )

        // Расчёт размеров контейнера
        totalGridWidth = side * cellSize + (side - 1) * spacing
        totalGridHeight = (side * cellSize + (side - 1) * spacing)

        let newFigures = []
        let index = 0
        for (let row = 0; row < side; row++) {
            for (let col = 0; col < side; col++) {
                if (index >= figuresCount) break
                newFigures.push({
                                    x: col * (cellSize + spacing),
                                    y: row * (cellSize + spacing),
                                    size: cellSize,
                                    color: baseColor,
                                    isTarget: false
                                })
                index++
            }
        }

        let targetIndex = Math.floor(Math.random() * newFigures.length)
        newFigures[targetIndex].color = targetColor
        newFigures[targetIndex].isTarget = true

        figuresData = newFigures

        let duration;
        if (difficulty === 1) {
            duration = -1; // бесконечно
        } else {

            duration = 10000 - (difficulty - 2) * 2200
            duration = Math.max(duration, 1500)
        }

        if (duration === -1) {
            selectionTimer.stop()
            timerBarAnimation.stop()
            timerBar.width = timerBarBackground.width
            timerBar.visible = false
        } else {
            selectionTimer.interval = duration
            selectionTimer.restart()
            timerBar.width = timerBarBackground.width
            timerBarAnimation.duration = duration
            timerBarAnimation.start()
            timerBar.visible = true
        }


        if(difficulty !== 1)
            selectionTimer.restart()

        timerBar.width = timerBarBackground.width
        timerBarAnimation.start()

    }

    function endGame() {
        if (awaitingNextRound && selectedIndex !== -1)
                    currentRound++  // учесть текущий выбор, если раунд не завершён
        isPaused = false
        isGameOver = true
        selectionTimer.stop()
        timerBarAnimation.stop()
        nextRoundDelay.stop()
        figuresData = []
        gameOverOverlay.visible = true
    }


    Component.onCompleted: startCountdown()
}

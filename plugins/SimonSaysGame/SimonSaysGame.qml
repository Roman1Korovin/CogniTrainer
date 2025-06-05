import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: simonGame

    property var moduleData
    property var stackViewRef

    property var baseColors: ["#f41310", "#006400", "#000080", "#FEFE22"]

    property var colors: Material.theme === Material.Light
        ? baseColors
        : baseColors.map(function(c) { return Qt.darker(c, 1.3); }) // затемнение на 50%

    property var sequence: []
    property int step: 0
    property bool acceptingInput: false

    property int flashIndex: 0
    property bool flashing: false

    property color successFeedbackColor: "#66FF00"
    property color failFeedbackColor: "#800000"

    property int flashAllCount: 0
    property color flashAllColor: "transparent"
    property bool flashAllOn: false

    property int score: 0

    signal gameOver()

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
        }


    Column {
        spacing: 20
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 35

        GridLayout {
            id: buttonGrid
            columns: 2
            columnSpacing: 20
            rowSpacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            property var buttons: []

            Component.onCompleted: {
                for (let i = 0; i < simonGame.colors.length; ++i) {
                    let button = Qt.createComponent("SimonButton.qml").createObject(buttonGrid, {
                        index: i,
                        baseColor: simonGame.colors[i]
                    });

                    button.clicked.connect(function (i) {
                        if (!simonGame.acceptingInput) return;

                        simonGame.flashButton(i);

                        if (i === simonGame.sequence[simonGame.step]) {
                            simonGame.step++;
                            if (simonGame.step === simonGame.sequence.length) {
                                simonGame.acceptingInput = false;
                                simonGame.flashAllButtons(simonGame.successFeedbackColor, 3);

                                Qt.createQmlObject(`
                                    import QtQuick 2.15
                                    Timer {
                                        interval: 1800
                                        repeat: false
                                        running: true
                                        onTriggered: simonGame.nextRound();
                                    }
                                `, buttonGrid);
                            }
                        } else {
                            simonGame.flashAllButtons(simonGame.failFeedbackColor, 3);
                            simonGame.gameOver();
                        }
                    });

                    buttonGrid.buttons.push(button);
                }

                simonGame.startGame();
            }
        }
    }


    Timer {
        id: flashTimer
        interval: 500
        repeat: true
        running: false
        onTriggered: {
            let btn = buttonGrid.buttons[simonGame.sequence[simonGame.flashIndex]];
            if (simonGame.flashing) {
                btn.isFlashing = false;
                simonGame.flashing = false;
                simonGame.flashIndex += 1;

                if (simonGame.flashIndex >= simonGame.sequence.length) {
                    flashTimer.stop();
                    simonGame.acceptingInput = true;
                    simonGame.step = 0;
                }
            } else {
                btn.isFlashing = true;
                simonGame.flashing = true;
            }
        }
    }

    Timer {
        id: flashAllTimer
        interval: 200
        repeat: true
        running: false
        onTriggered: {
            flashAllOn = !flashAllOn;
            for (let i = 0; i < buttonGrid.buttons.length; ++i) {
                buttonGrid.buttons[i].currentColor = flashAllOn
                    ? flashAllColor
                    : buttonGrid.buttons[i].baseColor;
            }

            if (!flashAllOn) {
                flashAllCount--;
                if (flashAllCount <= 0) {
                    flashAllTimer.stop();
                    for (let i = 0; i < buttonGrid.buttons.length; ++i) {
                        buttonGrid.buttons[i].currentColor = buttonGrid.buttons[i].baseColor;
                    }
                }
            }
        }
    }

    function flashAllButtons(color, times) {
        flashAllColor = color;
        flashAllCount = times;
        flashAllOn = false;
        flashAllTimer.start();
    }

    function startGame() {
        simonGame.sequence = [];
        simonGame.score = 0;
        simonGame.nextRound();
    }

    function nextRound() {
        simonGame.sequence.push(Math.floor(Math.random() * 4));
        simonGame.score = simonGame.sequence.length - 1;
        simonGame.playSequence();
    }

    function playSequence() {
        simonGame.acceptingInput = false;
        simonGame.flashIndex = 0;
        simonGame.flashing = false;
        flashTimer.start();
    }

    function flashButton(i) {
        buttonGrid.buttons[i].isFlashing = true;
        Qt.createQmlObject(`
            import QtQuick 2.15
            Timer {
                interval: 400
                repeat: false
                running: true
                onTriggered: buttonGrid.buttons[${i}].isFlashing = false;
            }
        `, buttonGrid);
    }


    Rectangle {
        id: gameOverOverlay
        visible: false
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.6)  // тёмная полупрозрачная подложка
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
                    text: "Длина цепочки: " + simonGame.score
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
                            gameOverOverlay.visible = false;
                            simonGame.startGame();
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

    onGameOver: {
        simonGame.acceptingInput = false;
        console.log("Игра окончена. Правильная последовательность:", simonGame.sequence);
        gameOverOverlay.visible = true;
    }
}

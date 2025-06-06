import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: window
    anchors.fill: parent
    visible: true

    property var moduleData
    property var stackViewRef
    property int difficulty: moduleData ? moduleData.difficulty : 1
    property int sequenceLength: Math.min(2 + difficulty, 10)

    property var cards: []
    property var originalValues: []
    property int currentStep: 0
    property bool inputPhase: false
    property bool success: false

    property real cardSpacing: 10
    property int estimatedMinCardWidth: 50
    property int maxCardsInRow: Math.floor((window.width - 40) / (estimatedMinCardWidth + cardSpacing))
    property real cardWidth: 100
    property real cardHeight: 170



    // Верхняя панель
    Rectangle {
        id: topBar
        height: 75
        color: Material.theme === Material.Dark ? Qt.darker(Material.background, 1.3) : Qt.darker(Material.background, 1.05)
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

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
                           (backArea.pressed ? Qt.darker("#32475c" ,1.2) : backArea.containsMouse ? Qt.darker("#32475c",1.1) : "#32475c") :
                           (backArea.pressed ? Qt.darker("white",1.2) : backArea.containsMouse ? Qt.darker("white",1.1) : "white")
                radius: 8
                border.color:  "#a0a0a0"
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
    }

    Item {
        id: cardArea
        width: parent.width
        height: parent.height

        Grid {
            id: contentRow
            columns: maxCardsInRow
            columnSpacing: cardSpacing
            rowSpacing: cardSpacing
            anchors.centerIn: parent
        }
    }

    // Показываем открытые карты
    Timer {
        id: showOpenTimer
        interval: 10000
        repeat: false
        onTriggered: {
            for (let c of cards) {
                c.flip()
                //c.flipped = false;
            }
            showClosedTimer.start();
        }
    }

    // Показываем закрытые карты
    Timer {
        id: showClosedTimer
        interval: 2000
        repeat: false
        onTriggered: {
            let shuffledValues = shuffleArray(originalValues);

            // Удаляем старые карты
            for (let i = contentRow.children.length - 1; i >= 0; --i) {
                contentRow.children[i].destroy();
            }
            cards = [];

            // Создаем перемешанные карты (закрытые)
            for (let i = 0; i < shuffledValues.length; ++i) {
                let card = Qt.createComponent("Card.qml").createObject(contentRow, {
                    value: shuffledValues[i],
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    allowFlipAnimation: false,
                    flipped: false

                });


                card.onClicked.connect(() => {
                    if (!inputPhase) return;

                    if (card.value === originalValues[currentStep]) {
                            card.matched = true;
                        currentStep++;
                        if (currentStep === originalValues.length) {
                            success = true;
                            inputPhase = false;
                            gameOverOverlay.visible = true;
                        }
                    } else {
                        if (card.hasOwnProperty("backColor"))
                            card.backColor = "indianred";
                        success = false;
                        inputPhase = false;
                        gameOverOverlay.visible = true;
                    }
                });

                cards.push(card);
            }

            showShuffledOpenTimer.start();
        }
    }

    // Показываем перемешанные карты открытыми (3 секунды)
    Timer {
        id: showShuffledOpenTimer
        interval: 3000
        repeat: false
        onTriggered: {
            for (let c of cards) {
                //c.flipped = true;
                c.flip()
            }
            inputPhase = true;
            currentStep = 0;
        }
    }

    function shuffleArray(array) {
        let newArray = array.slice();
        for (let i = newArray.length - 1; i > 0; i--) {
            let j = Math.floor(Math.random() * (i + 1));
            [newArray[i], newArray[j]] = [newArray[j], newArray[i]];
        }
        return newArray;
    }

    function generateCards() {
        for (let i = contentRow.children.length - 1; i >= 0; --i)
            contentRow.children[i].destroy();

        cards = [];
        currentStep = 0;
        inputPhase = false;
        success = false;

        let allValues = [
            "🐶", "🐱", "🦊", "🐻", "🐼", "🐸", "🐵", "🐯",
            "🐷", "🐰", "🦁", "🐮", "🦝", "🐔", "🦄", "🐙"
        ];

        let values = shuffleArray(allValues).slice(0, sequenceLength);
        originalValues = values.slice();

        for (let i = 0; i < values.length; ++i) {
            let card = Qt.createComponent("Card.qml").createObject(contentRow, {
                value: values[i],
                cardWidth: cardWidth,
                cardHeight: cardHeight,
                flipped: true,
                //allowFlipAnimation: true
            });

            // Обработка клика
            card.onClicked.connect(() => {
                if (!inputPhase) return;

                if (card.value === originalValues[currentStep]) {
                    if (card.hasOwnProperty("backColor"))
                        card.backColor = "lightgreen";
                    currentStep++;
                    if (currentStep === originalValues.length) {
                        success = true;
                        inputPhase = false;
                        gameOverOverlay.visible = true;
                    }
                } else {
                    if (card.hasOwnProperty("backColor"))
                        card.backColor = "indianred";
                    success = false;
                    inputPhase = false;
                    gameOverOverlay.visible = true;
                }
            });

            cards.push(card);
        }

        showOpenTimer.start();
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
                    font.bold: true
                    font.pixelSize: 26
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                }

                Item {
                    Layout.fillHeight: true // занимает все свободное пространство, сдвигая остальные элементы
                }

                Label {
                    id: resultLabel
                    text: window.success
                        ? "Вы успешно\nповторили последовательность!"
                        : "Ошибка! Последовательность  нарушена."
                    font.pixelSize: 20
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
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
                            generateCards();
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
    Component.onCompleted: generateCards()
}

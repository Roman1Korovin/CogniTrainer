import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: window
    anchors.fill: parent
    visible: true

    property var moduleData
    property var stackViewRef
    property var cards: []
    property int flippedCount: 0
    property var flippedIndices: []

    property int difficulty: moduleData.difficulty

    property int gridColumns: gridColumns
    property int gridRows: gridRows

    property int pairCount: (gridColumns * gridRows) / 2
    property real cardSpacing: 8
    property real cardWidth: Math.min((grid.width - (gridColumns - 1) * cardSpacing) / gridColumns,
                                      cardHeight / 1.25)
    property real cardHeight: Math.min((grid.height - (gridRows - 1) * cardSpacing) / gridRows, maxCardHeight)


    property real maxCardHeight: 90

    property int moveCount: 0

    Timer {
        id: previewTimer
        interval: 3000
        running: false
        repeat: false
        onTriggered: {
            for (let i = 0; i < cards.length; ++i) {
                cards[i].allowFlipAnimation = true;   // включаем анимацию
                if (!cards[i].matched) {
                    cards[i].flipped = false;
                }
            }
        }
    }

    Timer {
        id: resetTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            let i1 = flippedIndices[0];
            let i2 = flippedIndices[1];
            cards[i1].flipped = false;
            cards[i2].flipped = false;
            flippedCount = 0;
            flippedIndices = [];
        }
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
        }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 70
            }


        GridLayout {
            id: grid
            columns: gridColumns
            rowSpacing: cardSpacing
            columnSpacing: cardSpacing
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: false
            Layout.fillHeight: false
            width: parent.width * 0.80
            height: parent.height * 0.75
        }
    }

    function shuffleCards() {
        for (let i = grid.children.length - 1; i >= 0; --i)
            grid.children[i].destroy();

        cards = [];
        flippedCount = 0;
        flippedIndices = [];

        let allValues = [
            "🐶", "🐱", "🦊", "🐻", "🐼", "🐸", "🐵", "🐯",
            "🐷", "🐰", "🦁", "🐮", "🦝", "🐔", "🦄", "🐙",
            "🐳", "🐞", "🦋", "🦓", "🐢", "🐬", "🦕", "🦉", "🐍"
        ];
        let selected = allValues.slice(0, pairCount);
        let values = selected.concat(selected);
        values.sort(() => Math.random() - 0.5);

        for (let i = 0; i < values.length; ++i) {
            let card = Qt.createComponent("CardComponent.qml").createObject(grid, {
                value: values[i],
                cardWidth: cardWidth,
                cardHeight: cardHeight,
                flipped: true,               // сначала показываем
                allowFlipAnimation: false    // без анимации
            });

            card.onClicked.connect(function () {
                if (card.flipped || card.matched || flippedCount === 2)
                    return;

                card.flipped = true;
                flippedIndices.push(i);
                flippedCount++;

                if (flippedCount === 2) {
                    moveCount++;
                    let i1 = flippedIndices[0];
                    let i2 = flippedIndices[1];

                    if (cards[i1].value === cards[i2].value) {
                        cards[i1].matched = true;
                        cards[i2].matched = true;
                        flippedCount = 0;
                        flippedIndices = [];

                        // Проверка завершения
                        if (cards.every(c => c.matched)) {
                            gameOverOverlay.visible = true;
                        }
                    } else {
                        resetTimer.start();
                    }
                }
            });

            cards.push(card);
        }

        previewTimer.start(); // закрываем после показа
    }


    // КНО ОКОНЧАНИЯ ИГРЫ
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
                    text: "Ходов: " + moveCount
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
                            moveCount = 0
                            gameOverOverlay.visible = false
                            shuffleCards()
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

    Component.onCompleted: shuffleCards()
}

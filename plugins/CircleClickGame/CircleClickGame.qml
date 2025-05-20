import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    visible: true


    property int clickCount: 0
    property int roundCount: 0
    property int totalRounds: 50
    property var moduleData
    property var stackViewRef

    Rectangle {
        id: root
        anchors.fill: parent
        color: "#ffffff"

        property int difficultyValue: moduleData ? moduleData.difficulty : 5


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
                        source: moduleData.iconArrowPath
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
        }


        Rectangle {
            id: circle

            property int maxSize: 80
            property int minSize: 20

            width: {
                const clamped = Math.max(1, Math.min(10, root.difficultyValue))
                return maxSize - (clamped - 1) * ((maxSize - minSize) / 9)
            }
            height: width
            radius: width / 2
            color: "dodgerblue"

            // Учитываем верхнюю панель, чтобы круг не накрывал её
            function moveToRandomPosition() {
                const availableHeight = root.height - topBar.height;
                circle.x = Math.random() * (root.width - circle.width)
                circle.y = topBar.height + Math.random() * (availableHeight - circle.height)
            }

            Timer {
                id: autoMoveTimer
                interval: 2000 - (root.difficultyValue * 150)
                running: true
                repeat: true
                onTriggered: {
                    // Если игра завершена — не продолжаем
                    if (roundCount >= totalRounds) {
                        autoMoveTimer.stop()
                        gameOverOverlay.visible = true
                        return
                    }

                    roundCount++

                    // Красный след
                    var missMarker = Qt.createQmlObject(`
                                                        import QtQuick 2.15
                                                        Rectangle {
                                                        width: ${circle.width}
                                                        height: ${circle.height}
                                                        radius: width / 2
                                                        color: "#ff0000"
                                                        opacity: 0.5
                                                        x: ${circle.x}
                                                        y: ${circle.y}
                                                        z: -1
                                                        Behavior on opacity {
                                                            NumberAnimation { duration: 800; from: 0.5; to: 0 }
                                                        }
                                                        Timer {
                                                        interval: 800; running: true; repeat: false
                                                            onTriggered: parent.destroy()
                                                        }
                                                        }
                                                        `, hitMarkerLayer)

                    circle.moveToRandomPosition()
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: autoMoveTimer.running
                onClicked: {
                    // Нажал — попадание
                    var hitMarker = Qt.createQmlObject(`
                                                       import QtQuick 2.15
                                                       Rectangle {
                                                       width: ${circle.width}
                                                       height: ${circle.height}
                                                       radius: width / 2
                                                       color: "#00ff00"
                                                       opacity: 0.5
                                                       x: ${circle.x}
                                                       y: ${circle.y}
                                                       z: -1
                                                       Behavior on opacity {
                                                       NumberAnimation { duration: 800; from: 0.5; to: 0 }
                                                       }
                                                       Timer {
                                                       interval: 800; running: true; repeat: false
                                                       onTriggered: parent.destroy()
                                                       }
                                                       }
                                                       `, hitMarkerLayer)

                    clickCount++
                    roundCount++

                    if (roundCount >= totalRounds) {
                        autoMoveTimer.stop()
                        gameOverOverlay.visible = true
                    } else {
                        circle.moveToRandomPosition()
                        autoMoveTimer.restart()
                    }
                }
            }

            Component.onCompleted: {
                autoMoveTimer.start()
                moveToRandomPosition()
            }
        }

        // Слой для маркеров
        Item {
            id: hitMarkerLayer
            anchors.fill: parent
        }


    }
    // === ОКНО ОКОНЧАНИЯ ИГРЫ ===
    Rectangle {
        id: gameOverOverlay
        visible: false
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.6)  // чёрный с 80% непрозрачности  // Почти полностью черный, но немного прозрачный
        z: 1000

        // Центрированный белый блок
        Rectangle {
            width: parent.width * 0.5
            height: parent.height * 0.35
            radius: 12
            anchors.centerIn: parent
            color: "#ffffff"
            border.color: "#cccccc"
            border.width: 1

            Column {
                anchors.centerIn: parent
                spacing: 16
                width: parent.width
                //horizontalAlignment: Qt.AlignHCenter

                Text {
                    text: "Тренировка\nокончена!"
                    font.pixelSize: 26
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Точность: " + Math.round(clickCount / roundCount * 100) + " %"
                    font.pixelSize: 20
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    text: "Сыграть снова"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        clickCount = 0
                        roundCount = 0
                        gameOverOverlay.visible = false
                        circle.moveToRandomPosition()
                        autoMoveTimer.restart()
                    }
                }
            }
        }
    }
}

import QtQuick 2.15
import QtQuick.Controls 2.15

Window {
    id: window
    width: 1536; height: 864
    minimumHeight: 495
    minimumWidth: 800
    visible: true
    title: "Cognitive Trainer"

    Rectangle {
        id: header
        width: parent.width
        height: 60
        color: "#2c3e50"

        Row {
            id: headerRow
            anchors.fill: parent
            anchors.leftMargin: 20
            spacing: 0


            // Название приложения
            Text {
                text: qsTr("CogniTrainer")
                color: "white"
                font.pixelSize: 28
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }

            // Растяжка, чтобы кнопки были справа
            Item {
                id: spacer
                width: 70
                height: 1

            }

            MouseArea {
                id: trainingButtonArea
                width: 120
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor




                Text {
                    text: qsTr("Тренировки")
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 20
                }
            }


            // Текстовые "кнопки"

            MouseArea {
                id: testsButtonArea
                width: 120
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor


                Text {
                    text: qsTr("Тесты")
                    color: "white"
                    font.pixelSize: 20
                    anchors.centerIn: parent
                }
            }

            MouseArea {
                id: settingsButtonArea
                width: 120
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                Text {
                    text: qsTr("Настройки")
                    color: "white"
                    font.pixelSize: 20
                    anchors.centerIn: parent
                }
            }

        }
    }




        // Контейнер для нижней части экрана
        Row {
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            // Левый столбец с категориями
            Flickable {
                id: categoriesListFlickable
                width: parent.width * 0.25
                height: parent.height
                clip:true
                contentWidth: width
                contentHeight: categoryColumn.height

                Column {
                    id: categoryColumn
                    width: parent.width

                    spacing: 15
                    padding: 30

                    Repeater {

                        model: 5  // Пример количества категорий

                        delegate: Rectangle {
                            width: parent.width - 60
                            height: 120
                            radius: 30
                            color: "#ffffff"

                            border.color: "#cccccc"
                            border.width: 1

                            Row {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 8

                                Image {

                                }

                                Text {
                                    text: "Category " + (index + 1)
                                    anchors.centerIn: parent
                                    font.pixelSize: 18
                                    wrapMode: Text.Wrap

                                }
                            }
                        }
                    }
                }
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.OnDemand
                    anchors.right: parent.right
                }
            }

            // Граница между левой и правой частью
                Rectangle {
                    width: 2
                    height: parent.height
                    color: "#cccccc"  // Цвет границы
                }

            // Правая часть с тренировками категории
            Flickable {
                id: trainingListFlickable
                width: parent.width * 0.75
                height: parent.height
                contentWidth: flowContent.width
                contentHeight: flowContent.height
                clip: true

                Flow {
                    id: flowContent
                    width: trainingListFlickable.width
                    spacing: 16
                    padding: 30

                    Repeater {
                        model: 20  // Примерное количество тренировок

                        delegate: Rectangle {
                            width: 260
                            height: 120
                            radius: 12
                            color: "#ffffff"
                            border.color: "#cccccc"
                            border.width: 1

                            Column {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 8

                                Text {
                                    text: "Тренировка " + (index + 1)
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#333"
                                    wrapMode: Text.Wrap
                                }

                                Text {
                                    text: "Краткое описание текущей тренировки ..."
                                    font.pixelSize: 14
                                    color: "#666"
                                    wrapMode: Text.Wrap
                                    width: parent.width
                                }
                            }
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.OnDemand
                    anchors.right: parent.right
                    width: 20
                }
            }
        }
}


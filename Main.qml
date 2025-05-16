import QtQuick
import QtQuick.Controls


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
            spacing:20

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
                width: 60
                height: 1

            }
            MouseArea {
                id: trainingButtonArea
                width: trainingsText.width+10
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor


                Text {
                    id:trainingsText
                    text: qsTr("Тренировки")
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 20
                }
            }


            // Текстовые "кнопки"

            MouseArea {
                id: testsButtonArea
                width: testsText.width+10
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor


                Text {
                    id:testsText
                    text: qsTr("Тесты")
                    color: "white"
                    font.pixelSize: 20
                    anchors.centerIn: parent
                }
            }

            MouseArea {
                id: settingsButtonArea
                width: settingsText.width+10
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                Text {
                    id:settingsText
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
        anchors{
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        // Левый столбец с категориями
        ListView {
            id: categoryListView
            width: parent.width * 0.25
            height: parent.height

            model:categoryManager.categories

            clip:true

            spacing: 20
            topMargin:30


            delegate: Rectangle {

                width: parent.width - 60
                height: 120
                radius: 30

                anchors.horizontalCenter: parent.horizontalCenter

                color: "#ffffff"
                border.color: "#cccccc"
                border.width: 1


                    Image {
                        width: 50
                        height: 50
                        source: model.imagePath
                        fillMode: Image.PreserveAspectCrop
                    }




                    Text {
                        text: model.name
                        anchors.centerIn: parent
                        font.pixelSize: 18
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        font.bold: true
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
            color: "#cccccc"
        }

        // Правая часть с тренировками категории
        GridView {
            id: trainingGrid
            width: parent.width * 0.75
            height: parent.height
            cellWidth: 260 + 16 // ширина карточки + отступ
            cellHeight: 120 + 16 // высота карточки + отступ

            topMargin: 30
            leftMargin: 30
            rightMargin: 10



            model: moduleList

            clip: true


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
                        text: modelData.name
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333"
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }

                    Text {
                        text: modelData.description
                        font.pixelSize: 14
                        color: "#666"
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        width: parent.width
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



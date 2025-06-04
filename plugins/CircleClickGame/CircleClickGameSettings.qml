import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root


    // Входные параметры
    property var moduleData
    property var stackViewRef

    // Выбранная сложность
    property int difficulty: (moduleData && typeof moduleData.difficulty === "number") ? moduleData.difficulty : 5
    property bool endlessMode: (moduleData && typeof moduleData.endlessMode === "boolean") ? moduleData.endlessMode : false

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
                border.color:  "grey"
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

    //основной экран

    Item {
        anchors {
            top: topBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        Column {

            id:column

            anchors.centerIn: parent

            Label {

                anchors.horizontalCenter: parent.horizontalCenter
                text: "Инструкция"
                font.pixelSize: 30
                font.bold: true

            }

            Item {
                width: 1
                height: Math.max((Window.height - 702) * 0.07, 15)
            }

            Label {
                text: moduleData && moduleData.manual ? moduleData.manual : ""

                font.pixelSize: 22
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                   horizontalAlignment: Text.AlignJustify
            }

            Item {
                width: 1
                height: Math.max((Window.height - 702) * 0.15, 40)
            }


            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Выберите уровень сложности"
                font.weight: Font.DemiBold
                font.pixelSize: 22
            }

            Item {
                width: 1
                height: Math.max((Window.height - 702) * 0.07, 15)
            }

            //набор кнопок для выбора сложности
            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter


                // Надпись "Легко"
                Label {
                    text: "Легко"
                    font.pixelSize: 22
                    Layout.alignment: Qt.AlignTop
                    rightPadding: 15
                }

                //набор radioButton
                RowLayout {

                    Repeater {
                        model: 10

                        ColumnLayout {
                            spacing: -20

                            RadioButton {
                                id: radioBtn
                                checked: index + 1 === difficulty
                                onClicked: difficulty = index + 1

                                indicator: Rectangle {
                                    implicitWidth: 32
                                    implicitHeight: 32
                                    radius: width / 2
                                    border.width: 2
                                    border.color: radioBtn.checked ? "blue" : "gray"
                                    color: radioBtn.checked ? "blue" : "transparent"

                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: parent.width * 0.5
                                        height: parent.height * 0.5
                                        radius: width / 2
                                        color: "white"
                                        visible: radioBtn.checked
                                    }
                                }
                            }

                            Label {
                                text: "  "+(index + 1).toString()
                                font.pixelSize: 20
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                }

                // Надпись "Сложно"
                Label {
                    leftPadding: -10
                    text: "Сложно"
                    font.pixelSize: 22
                    Layout.alignment: Qt.AlignTop

                }
            }
            Item {
                width: 1
                height: Math.max(root.height * 0.015, 10)

            }
            CheckBox {
                id: endlessCheckBox
                text: "Бесконечный режим"
                font.pixelSize: 22
                checked: endlessMode

                Layout.alignment: Qt.AlignHCenter
                onCheckedChanged: {
                    endlessMode = checked
                }
            }

            Item {
                width: 1
                height: Math.max((Window.height - 702) * 0.1, 10)

            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width:300
                text: "Продолжить"
                font.pixelSize: 20


                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    if (moduleData && typeof moduleData.setDifficulty === "function") {
                        moduleData.setDifficulty(difficulty)
                        moduleData.endlessMode = endlessMode
                        stackViewRef.push(moduleData.qmlComponentUrl, {
                                              moduleData: moduleData,
                                              stackViewRef: stackViewRef
                                          })
                    } else {
                        console.warn("Ошибка: moduleData или setDifficulty не определены")
                    }
                }
            }

        }
    }
}

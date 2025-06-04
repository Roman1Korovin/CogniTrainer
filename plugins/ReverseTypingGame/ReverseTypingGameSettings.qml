import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    property var moduleData
    property var stackViewRef

    property bool endlessMode:  false
    property int wordDisplayMode: 1

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

    //основной экран

    Item {
        id: mainScreed
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
                height: Math.max((Window.height - 702) * 0.07, 5)
            }

            Label {
                text: moduleData && moduleData.manual ? moduleData.manual : ""

                font.pixelSize: 22
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }


            Item {
                width: 1
                height: Math.max((Window.height - 702) * 0.15, 30)
            }

            Label{
                anchors.horizontalCenter: parent.horizontalCenter
                font.weight: Font.DemiBold
                text:"Режим игры"
                font.pixelSize: 26
                font.bold: true
            }

            Item {
                width: 1
                height: Math.max((Window.height - 702) * 0.03, 5)
            }



            Column {

                RadioButton {
                    text: "Показывать всё время"
                    font.pixelSize: 22
                    onClicked: wordDisplayMode = 0
                }

                RadioButton {
                    text: "Показывать 3 секунды"
                    font.pixelSize: 22
                    checked: true
                    onClicked: wordDisplayMode = 1
                }

                RadioButton {
                    text: "Только аудиопроизношение"
                    font.pixelSize: 22
                    onClicked: wordDisplayMode = 2
                }
            }

            Item {
                width: 1
                height: Math.max((Window.height - 702) * 0.05, 5)
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
                height: Math.max((Window.height - 702) * 0.1, 5)
            }


            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width:300
                text: "Продолжить"
                font.pixelSize: 20


                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    if (moduleData) {
                        stackViewRef.push(moduleData.qmlComponentUrl, {
                                              moduleData: moduleData,
                                              stackViewRef: stackViewRef,
                                              wordDisplayMode: wordDisplayMode,
                                              endlessMode : endlessMode
                                          })
                    } else {
                        console.warn("Ошибка: moduleDataне определены")
                    }
                }
            }


        }
    }
}


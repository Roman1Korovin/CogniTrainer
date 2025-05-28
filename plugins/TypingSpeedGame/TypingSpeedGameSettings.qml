import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root


    // Входные параметры
    property var moduleData
    property var stackViewRef


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

            Text {

                anchors.horizontalCenter: parent.horizontalCenter
                text: "Инструкция"
                font.pixelSize: 30
                font.bold: true

            }

            Item {
                width: 1
                height: Math.max(root.height * 0.03, 5)
            }

            Text {
                text: moduleData && moduleData.manual ? moduleData.manual : ""

                font.pixelSize: 22
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }

            Item {
                width: 1
                height: Math.max(root.height * 0.07, 5)
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
                                              stackViewRef: stackViewRef
                                          })
                    } else {
                        console.warn("Ошибка: moduleDataне определены")
                    }
                }
            }

            Item {
                width: 1
                height: Math.max(root.height * 0.1, 5)
            }
        }
    }
}

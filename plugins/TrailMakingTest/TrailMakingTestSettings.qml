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

    property bool isAgeValid: true
    property int age: 60

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
            anchors.topMargin: 15
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
            }

            Item {
                width: 1
                height: Math.max((Window.height - 702) * 0.15, 40)
            }


            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Укажите свой возраст"
                font.weight: Font.DemiBold
                font.pixelSize: 22
            }

            Item {
                width: 1
                height: Math.max((Window.height - 702) * 0.07, 15)
            }

            //поле для ввода

            RowLayout {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                // Кнопка уменьшения возраста
                Button {
                    text: "-"
                    enabled: age !==6
                    onClicked: {
                        if (age > 6)
                        {
                            age--
                            ageField.text = age.toString()
                        }
                    }
                }

                // Поле для ввода возраста
                TextField {
                    id: ageField
                    width: 80
                    height: 40
                    font.pixelSize: 20

                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 0; top: 90 }

                    text: age.toString()

                    onTextChanged:  {
                        const parsed = parseInt(text)
                        if (!isNaN(parsed) && parsed >= 6 && parsed <= 90) {
                            isAgeValid = true
                            age = parsed
                        } else {
                            isAgeValid = false
                        }
                    }

                    onEditingFinished: {
                        if (text === "") {
                            age = 40
                            text = "40"
                        }
                    }
                }


                // Кнопка увеличения возраста
                Button {
                    text: "+"
                    enabled: age !==90
                    onClicked: {
                        if (age < 90)
                        {
                            age++
                            ageField.text = age.toString()
                        }
                    }
                }
            }



            Item {
                width: 1
                height: Math.max((Window.height - 702) * 0.2, 50)
            }

            Button {
                id: confirmButton
                anchors.horizontalCenter: parent.horizontalCenter
                width:300
                text: "Продолжить"
                font.pixelSize: 20
                enabled: isAgeValid

                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    if (moduleData && typeof moduleData.setAge === "function") {
                        moduleData.setAge(age)
                        stackViewRef.push(moduleData.qmlComponentUrl, {
                                              moduleData: moduleData,
                                              stackViewRef: stackViewRef
                                          })
                    } else {
                        console.warn("Ошибка: moduleData или setAge+ не определены")
                    }
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.settings

Page {
    id: settingsPage
    title: "Настройки"

    property Settings appSettingsRef
    property bool initialized: false

    Dialog {
        id: restartDialog
        title: "Требуется перезапуск"
        standardButtons: Dialog.Ok

        width: 600
        height: 300

        x: (settingsPage.width - width) / 2
        y: (settingsPage.height - height) / 2

        font.pixelSize: 28
        font.bold: true

        modal: true

        onAccepted: restartDialog.close()

        contentItem: Label {
            text: "Перезапустите приложение, чтобы применить новую тему."
            wrapMode: Text.WordWrap
            padding: 16
            font.pixelSize: 20
            font.bold: false
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Label {

            text: "Тема оформления"
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: visualImpairment ? 20*1.3 : 20
        }

        RowLayout {
            spacing: 12
            Layout.alignment: Qt.AlignHCenter



            Switch {
                id: themeSwitch
                checked: appSettingsRef.value("theme", "light") === "dark"

                Component.onCompleted: initialized = true

                onCheckedChanged: {
                    if (initialized) {
                        appSettingsRef.setValue("theme", checked ? "dark" : "light")
                        restartDialog.open()
                    }
                }
            }


        }

        Label {

            text: "Режим для слабовидящих"
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: visualImpairment ? 20*1.3 : 20

            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            Layout.maximumWidth: parent.width * 0.9
        }

        RowLayout {
            spacing: 12
            Layout.alignment: Qt.AlignHCenter



            Switch {
                id: accessibilitySwitch

                checked: visualImpairment

                onCheckedChanged: {
                    visualImpairment = accessibilitySwitch.checked
                }
            }
        }

    }
}


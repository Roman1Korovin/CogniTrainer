import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    width: 800; height: 600
    visible: true
    title: "Cognitive Trainer"

    Row {
        anchors.fill: parent

        // Левая панель со списком модулей
        ListView {
            id: listView
            width: 200
            model: moduleList
            delegate: ItemDelegate {
                width: parent.width
                text: modelData.name
                onClicked: {
                    loader.source = modelData.url
                }
            }
        }
        // Правый блок для показа модуля
        Loader {
            id: loader
            anchors.fill: parent
            anchors.leftMargin: listView.width
        }
    }
}


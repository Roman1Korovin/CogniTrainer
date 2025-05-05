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
            model: moduleNames
            delegate: ItemDelegate {
                width: parent.width
                text: modelData
                onClicked: {
                    // Здесь пока просто логируем
                    console.log("Выбрали модуль:", modelData)
                }
            }
        }

        // Правый блок для показа модуля (Loader пока пуст)
        Rectangle {
            id: contentArea
            anchors.fill: parent
            anchors.leftMargin: listView.width
            color: "#f0f0f0"

            // Пока заглушка
            Text {
                anchors.centerIn: parent
                text: "Выберите модуль слева"
                color: "#888"
            }
        }
    }
}

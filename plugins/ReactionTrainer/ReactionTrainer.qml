import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    width: 400
    height: 300
    color: "#d0eaff"

    Column {
        anchors.centerIn: parent
        spacing: 10

        Text {
            text: "Модуль: Тренировка реакции"
            font.pointSize: 20
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            text: "Нажми меня"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}

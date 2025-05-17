import QtQuick

Rectangle {
    id:root
    property string name
    property string description

    width: 260
    height: 120
    radius: 12
    color: "#ffffff"
    border.color: "#cccccc"
    border.width: 1

    Column{
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

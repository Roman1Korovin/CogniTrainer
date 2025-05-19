import QtQuick

Rectangle {

    id: root
    property string name
    property string description

    signal clicked(string name)

    property int sharedMaxHeight:0
    signal heightReported(int h)

    width: 260
    height: sharedMaxHeight > implicitHeight ? sharedMaxHeight : implicitHeight
    radius: 12
    border.color: "#cccccc"
    border.width: 1


    property color baseColor: "#ffe066"

    color: if(buttonMouseArea.containsPress) {
               return Qt.lighter(root.baseColor,1.2)
           } else if (buttonMouseArea.containsMouse) {
               return Qt.darker(root.baseColor,1.1)
           } else {
               return root.baseColor
           }

    // Размеры подстраиваются под содержимое
    implicitHeight: contentItem.implicitHeight + 24

    // Содержимое
    Column {
        id: contentItem
        anchors.margins: 12
        anchors.fill: parent
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

    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked(root.name)
    }

    Component.onCompleted: {
        heightReported(root.height)
    }
}


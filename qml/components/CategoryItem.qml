import QtQuick

Rectangle {
    id: root
    property string name
    property string imagePath

    signal clicked(string name)

    width: 200
    height: 120
    radius: 30
    color: "#ffffff"
    border.color: "#cccccc"
    border.width: 1

    anchors.horizontalCenter: parent.horizontalCenter


    MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.clicked(root.name)

            Image {
                width: 50
                height: 50
                source: model.imagePath
                fillMode: Image.PreserveAspectCrop
            }


            Text {
                text: model.name
                anchors.centerIn: parent
                font.pixelSize: 18
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.bold: true
            }
        }
}

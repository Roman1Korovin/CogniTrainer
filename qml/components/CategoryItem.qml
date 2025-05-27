import QtQuick

Rectangle {

    id: root
    property string name
    property string imagePath
    property bool isSelected: false

    signal clicked(string name)

    width: 200
    height: 120
    topRightRadius: 30

    border.color: "#cccccc"
    border.width: 1

    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined

    //цвет в зависимости от того выюран ли элемент
    property color baseColor: isSelected ? "#A0522D" : "#ffe066"

    //изменения цветов при наведении и удерживании
    color: {
        if (isSelected)
            return baseColor;
        else if (buttonMouseArea.containsPress)
            return Qt.lighter(baseColor, 1.2);
        else if(buttonMouseArea.containsMouse)
            return Qt.darker(baseColor, 1.1);
        else{
        return baseColor;
        }
    }


    MouseArea {

        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: true

        //выключаем элемент, если он уже выбран
        enabled: !root.isSelected
        cursorShape: root.isSelected ? Qt.ArrowCursor : Qt.PointingHandCursor

        onClicked: root.clicked(root.name)

        Image {
            width: 50
            height: 50
            source: root.imagePath
            fillMode: Image.PreserveAspectCrop
        }


        Text {
            text: root.name
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter


            font.pixelSize: 18
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            width: parent.width
            font.bold: true
        }
    }
}

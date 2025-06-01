import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {

    id: root
    property string name
    property string description

    signal clicked(string name)

    property int sharedMaxHeight:0
    signal heightReported(int h)

    width: 400
    height: sharedMaxHeight > implicitHeight ? sharedMaxHeight : implicitHeight
    radius: 12
    border.color: Material.theme === Material.Dark ? "white" : "black"
    border.width: 2


    //цвет в зависимости от темы и того выюран ли элемент
    property color baseColor: Material.theme === Material.Dark ? "#2c3e50" : "#C9E9FF"  // цвет при выборе, разный для тем


    //изменения цветов при наведении и удерживании
    color: {
        // Тема тёмная
        if (Material.theme === Material.Dark) {
            if (buttonMouseArea.containsPress)
                return Qt.lighter(baseColor, 1.2); // светлее при нажатии
            else if (buttonMouseArea.containsMouse)
                return Qt.darker(baseColor, 1.1);  // темнее при наведении
        } else {
            // Тема светлая
            if (buttonMouseArea.containsPress)
                return Qt.darker(baseColor, 1.1);  // темнее при нажатии
            else if (buttonMouseArea.containsMouse)
                return Qt.lighter(baseColor, 1.05); // светлее при наведении
        }
        return baseColor;
    }





    // Размеры подстраиваются под содержимое
    implicitHeight: contentItem.implicitHeight + 24

    // Содержимое
    Column {
        id: contentItem
        anchors.margins: 12
        anchors.fill: parent
        spacing: 8

        Label {
            text: modelData.name
            font.pixelSize: 20
            font.bold: true

            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            width: parent.width
        }

        Label {
            text: modelData.description
            font.pixelSize: 15
            color: Material.theme === Material.Dark ? "#ccc" : "#666"
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


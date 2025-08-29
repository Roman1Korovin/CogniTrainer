import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {

    id: root
    property string name
    property string description
    property string iconUrl
    signal clicked(string name)

    property int sharedMaxHeight:0
    signal heightReported(int h)

    width: visualImpairment ? 350 * 1.3: 350
    height: visualImpairment ? 525 * 1.3: 525
    radius: 12



    //цвет в зависимости от темы и того выюран ли элемент
    property color baseColor: Material.theme === Material.Dark ? "#32475c" : "#C9E9FF"  // цвет при выборе, разный для тем



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


    Image {

        anchors {
            left:parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        anchors.margins: 3

        source: Material.theme === Material.Dark
            ? "qrc:/assets/backgrounds/DarkFrame.png"
            : "qrc:/assets/backgrounds/LightFrame.png"

    }


    Image {

        anchors.bottom: parent.bottom
        source: iconUrl

        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 30
        width: visualImpairment ? 280 * 1.3: 280
    }





    // Содержимое
    Column {
        id: contentItem
        anchors.margins: 12
        anchors.fill: parent
        spacing: 8

        Label {
            text: modelData.name
            font.pixelSize: visualImpairment? 24* 1.3 : 24
            font.bold: true


            height: 65
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            leftPadding: 30
            rightPadding: 30
            topPadding: 10

            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

        }


        Label {
            id: textItem

            width: parent.width
            horizontalAlignment: Text.AlignJustify
            topPadding: visualImpairment? 10: 0
            leftPadding: 8
            rightPadding: 8
            text: modelData.description
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: visualImpairment? 20* 1.3 : 20
            color: Material.theme === Material.Dark ? "#ccc" : "#666"
        }

    }

    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked(root.name)
    }

}


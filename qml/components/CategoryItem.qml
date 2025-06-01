import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {

    id: root
    property string name
    property string imageUrl
    property bool isSelected: false

    signal clicked(string name)

    width: 400
    height: 120
    radius: 25

    border.color: Material.theme === Material.Dark ? "white" : "black"
    border.width: 2

    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined

    //цвет в зависимости от темы и того выюран ли элемент
    property color baseColor: isSelected
        ? (Material.theme === Material.Dark ? "#4073ad" : "#5288c4")  // цвет при выборе, разный для тем
        : (Material.theme === Material.Dark ? "#2c3e50" : "#C9E9FF")  // базовый цвет по теме



    //изменения цветов при наведении и удерживании
    color: {
        if (isSelected) {
            return baseColor;
        }

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



    MouseArea {

        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: true

        //выключаем элемент, если он уже выбран
        enabled: !root.isSelected
        cursorShape: root.isSelected ? Qt.ArrowCursor : Qt.PointingHandCursor

        onClicked: root.clicked(root.name)

        RowLayout{

            anchors.fill: parent
            anchors.rightMargin: 10
            Layout.alignment: Qt.AlignVCenter
            Image {

                id:image
                source: root.imageUrl
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: Layout.preferredHeight-4
                Layout.leftMargin: 2


                Layout.alignment: Qt.AlignVCenter
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }


            Label {
                text: root.name
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.bold: true
            }
        }
    }
}

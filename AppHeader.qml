import QtQuick

Rectangle {
    id: header
    width: parent.width
    height: 60
    color: "#2c3e50"

    property string currentTab

    signal trainingsClicked()
    signal testsClicked()
    signal settingsClicked()



    Row {
        id: headerRow
        anchors.fill: parent
        anchors.leftMargin: 20
        spacing: 20

        Text {
            text: qsTr("CogniTrainer")
            color: "white"
            font.pixelSize: 28
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            id: spacer
            width: 60
            height: 1
        }

        MouseArea {
            width: trainingsText.width + 10
            height: 40
            anchors.verticalCenter: parent.verticalCenter
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                currentTab = "trainings"
                header.trainingsClicked()
            }

            Text {
                id: trainingsText
                text: qsTr("Тренировки")
                anchors.centerIn: parent
                color: currentTab === "trainings" ? "#ffcc00" : "white"
                font.pixelSize: 20
                font.bold: currentTab === "trainings"
            }
        }

        MouseArea {
            width: testsText.width + 10
            height: 40
            anchors.verticalCenter: parent.verticalCenter
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked:
            {
                currentTab = "tests"
                header.testsClicked()
            }

            Text {
                id: testsText
                text: qsTr("Тесты")
                anchors.centerIn: parent
                color: currentTab === "tests" ? "#ffcc00" : "white"
                font.pixelSize: 20
                font.bold: currentTab === "tests"
            }
        }

        MouseArea {
            width: settingsText.width + 10
            height: 40
            anchors.verticalCenter: parent.verticalCenter
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                            currentTab = "settings"
                            header.settingsClicked()
                        }

            Text {
                id: settingsText
                text: qsTr("Настройки")
                anchors.centerIn: parent
                color: currentTab === "settings" ? "#ffcc00" : "white"
                                font.pixelSize: 20
                                font.bold: currentTab === "settings"
            }
        }
    }
}

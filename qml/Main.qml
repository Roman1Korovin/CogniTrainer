import QtQuick
import QtQuick.Controls


Window {
    id: mainWindow
    width: 1536; height: 864
    minimumHeight: 495
    minimumWidth: 800
    visible: true
    title: "Cognitive Trainer"

    property string currentTab: "trainings"

    AppHeader {
        id: appHeader
        width: parent.width
        currentTab: mainWindow.currentTab

        onTrainingsClicked: mainWindow.currentTab = "trainings"
        onTestsClicked: mainWindow.currentTab = "tests"
        onSettingsClicked: mainWindow.currentTab = "settings"
    }

    // Контейнер для основной части экрана
    Loader {
        id:pageLoader
        anchors {
            top:appHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        active: true

        sourceComponent: {
            if (currentTab === "trainings") {
                return trainingComponent
            } else if (currentTab === "tests") {
                return testsComponent
            } else if (currentTab === "settings") {
                return settingsComponent
            } else {
                return null
            }
        }
    }

    // Компоненты (обёртки вокруг отдельных QML файлов)
    Component {
        id: trainingComponent
        TrainingPage {
            width: parent.width
            height: parent.height
        }
    }

    Component {
        id: testsComponent
        TestsPage {
            width: parent.width
            height: parent.height
        }
    }

    Component {
        id: settingsComponent
        SettingsPage {
            width: parent.width
            height: parent.height
        }
    }
}




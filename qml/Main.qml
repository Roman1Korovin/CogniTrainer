import QtQuick
import QtQuick.Controls
import "pages"
import "components"

Window {
    id: mainWindow
    Component.onCompleted: {
           width = Screen.width * 0.8
           height = Screen.height * 0.8
           x = (Screen.width - width) / 2
           y = (Screen.height - height) / 2
       }
    minimumHeight: 702
    minimumWidth: 1248
    visible: true
    title: "Cognitive Trainer"

    property string currentTab: "trainings"

    AppHeader {
        id: appHeader
        width: parent.width
        currentTab: mainWindow.currentTab

        onTrainingsClicked: {
            if (mainWindow.currentTab === "trainings") {
                mainWindow.currentTab = ""
                Qt.callLater(() => mainWindow.currentTab = "trainings")
            } else {
                mainWindow.currentTab = "trainings"
            }
        }

        onTestsClicked: {
            if (mainWindow.currentTab === "tests") {
                mainWindow.currentTab = ""
                Qt.callLater(() => mainWindow.currentTab = "tests")
            } else {
                mainWindow.currentTab = "tests"
            }
        }

        onSettingsClicked: {
            if (mainWindow.currentTab === "settings") {
                mainWindow.currentTab = ""
                Qt.callLater(() => mainWindow.currentTab = "settings")
            } else {
                mainWindow.currentTab = "settings"
            }
        }
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
        TrainingsPage {
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

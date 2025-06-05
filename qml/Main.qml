import QtQuick
import QtQuick.Controls
import Qt.labs.settings
import "pages"
import "components"

ApplicationWindow {
    id: mainWindow


    Settings {
            id: appSettings
        }

        // Читаем тему из настроек один раз при старте
        property int savedTheme: Material.Light


        function getBoolSetting(key, defaultValue) {
            let raw = appSettings.value(key, defaultValue)
            return raw === true || raw === "true"
        }


        // Реактивно меняем фон под тему
        Material.background: Material.theme === Material.Light ? "fffbf5" : "#17222e"
        Material.accent: Material.Blue


    //Material.theme: !Material.theme

    //background: Material.theme === Material.Light ? "#fffbf5" : "#17222e"

    property color backgroundColor: Material.theme === Material.Light ? "#fffbf5" : "#17222e"

    Component.onCompleted: {
           width = Screen.width * 0.8
           height = Screen.height * 0.8
           x = (Screen.width - width) / 2
           y = (Screen.height - height) / 2

        var themeStr = appSettings.value("theme", "light")
        Material.theme = themeStr === "dark" ? Material.Dark : Material.Light
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


    Rectangle {
       id: gradientShadow
        anchors {
            top: appHeader.bottom
            left: parent.left
            right: parent.right
        }
        height: 10
        gradient: Material.theme === Material.Light ? lightGradient : darkGradient

            Gradient {
                id: lightGradient
                GradientStop { position: 0.0; color: "#121314" }
                GradientStop { position: 1.0; color: Qt.darker(backgroundColor, 1.05) }
            }

            Gradient {
                id: darkGradient
                GradientStop { position: 0.0; color: "#121212" }
                GradientStop { position: 1.0; color: Qt.darker(backgroundColor, 1.2) }
            }


    }

    // Контейнер для основной части экрана
    Loader {
        id:pageLoader
        anchors {
            top:gradientShadow.bottom
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
            appSettingsRef: appSettings
            width: parent.width
            height: parent.height
        }
    }
}

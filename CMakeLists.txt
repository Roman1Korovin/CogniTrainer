cmake_minimum_required(VERSION 3.16)

project(CogniTrainer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS Quick QuickControls2 TextToSpeech REQUIRED)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appCogniTrainer
    main.cpp
)

qt_add_resources(appCogniTrainer "app_images"
    PREFIX "/"
    FILES
        assets/backgrounds
        assets/icons
)

qt_add_qml_module(appCogniTrainer
    URI CogniTrainer
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/components/CategoryItem.qml
        qml/components/TrainingCardItem.qml
        qml/components/AppHeader.qml
        qml/pages/TrainingsPage.qml
        qml/pages/TestsPage.qml
        qml/pages/SettingsPage.qml
    SOURCES
        core/ModuleInterface.h
        core/BaseModule.h
        core/ModuleLoader.h core/ModuleLoader.cpp
        core/Category.h
        core/CategoryManager.h core/CategoryManager.cpp
    RESOURCES application.qrc
    RESOURCES plugins/SimonSaysGame/SimonSaysGame.qrc
    RESOURCES plugins/FindPairGame/FindPairGame.qrc
)

set_target_properties(appCogniTrainer PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCogniTrainer
    PRIVATE Qt6::Quick
    Qt6::QuickControls2
    Qt6::TextToSpeech
)

include(GNUInstallDirs)
install(TARGETS appCogniTrainer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

add_subdirectory(plugins/TypingSpeedGame)
add_subdirectory(plugins/CircleClickGame)
add_subdirectory(plugins/CircleHoldGame)
add_subdirectory(plugins/ReverseTypingGame)
add_subdirectory(plugins/ArrowSequenceGame)
add_subdirectory(plugins/ReactionClickGame)
add_subdirectory(plugins/FindAnotherColorGame)
add_subdirectory(plugins/SimonSaysGame)
add_subdirectory(plugins/FindPairGame)
add_subdirectory(plugins/StroopEffectGame)

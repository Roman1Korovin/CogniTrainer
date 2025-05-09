cmake_minimum_required(VERSION 3.16)

project(CogniTrainer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appCogniTrainer
    main.cpp
)

qt_add_qml_module(appCogniTrainer
    URI CogniTrainer
    VERSION 1.0
    QML_FILES
        Main.qml
    SOURCES
        interfaces/ModuleInterface.h
        core/ModuleLoader.h
        core/ModuleLoader.cpp
        SOURCES core/Category.h
        SOURCES core/CategoryManager.h core/CategoryManager.cpp
)

set_target_properties(appCogniTrainer PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCogniTrainer
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appCogniTrainer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

add_subdirectory(plugins/ReactionTrainer)

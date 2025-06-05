cmake_minimum_required(VERSION 3.16)

project(FindAnotherColorGame LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core)

add_library(FindAnotherColorGame SHARED
  ../../core/BaseModule.h
  FindAnotherColorGame_global.h
  FindAnotherColorGame.cpp
  FindAnotherColorGame.h
  FindAnotherColorGame.qrc
)

target_link_libraries(FindAnotherColorGame
    PRIVATE
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
)

set_target_properties(FindAnotherColorGame PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/modules"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/modules"
)

target_compile_definitions(FindAnotherColorGame PRIVATE FINDANOTHERCOLORGAME_LIBRARY)

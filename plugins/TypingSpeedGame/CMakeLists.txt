cmake_minimum_required(VERSION 3.16)

project(TypingSpeedGame LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core)



add_library(TypingSpeedGame SHARED
  ../../core/BaseModule.h
  TypingSpeedGame_global.h
  TypingSpeedGame.cpp
  TypingSpeedGame.h
  TypingSpeedGame.qrc
)

target_link_libraries(TypingSpeedGame
    PRIVATE
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
)
set_target_properties(TypingSpeedGame PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/modules"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/modules"
)

target_compile_definitions(TypingSpeedGame PRIVATE TYPINGSPEEDGAME_LIBRARY)


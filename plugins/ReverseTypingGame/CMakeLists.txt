cmake_minimum_required(VERSION 3.16)

project(ReverseTypingGame LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 TextToSpeech REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core)

add_library(ReverseTypingGame SHARED
  ../../core/BaseModule.h
  ReverseTypingGame_global.h
  ReverseTypingGame.cpp
  ReverseTypingGame.h
  ReverseTypingGame.qrc
  ReverseTypingGame.qrc
)

target_link_libraries(ReverseTypingGame
    PRIVATE
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
        Qt6::TextToSpeech
)
set_target_properties(ReverseTypingGame PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/modules"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/modules"
)

target_compile_definitions(ReverseTypingGame PRIVATE REVERSETYPINGGAME_LIBRARY)

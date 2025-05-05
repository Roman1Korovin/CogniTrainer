cmake_minimum_required(VERSION 3.16)

project(ReactionTrainer LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick)

add_library(ReactionTrainer MODULE
    ReactionTrainer_global.h
    ReactionTrainer.cpp
    ReactionTrainer.h
    ReactionTrainer.qrc
)

target_link_libraries(ReactionTrainer
    PRIVATE
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
)

set_target_properties(ReactionTrainer PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/modules"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/modules"
)

target_compile_definitions(ReactionTrainer PRIVATE REACTIONTRAINER_LIBRARY)

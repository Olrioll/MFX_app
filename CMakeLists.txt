cmake_minimum_required(VERSION 3.0.0)

project(MFX VERSION 0.1)

find_package(Qt5 COMPONENTS Widgets Multimedia Qml Quick REQUIRED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

add_executable(${PROJECT_NAME} WIN32 "build/packaging/windows/appIcon.rc" "qml/qml.qrc" "resources/resources.qrc" "src/main.cpp" "src/AudioTrackRepresentation.cpp" "src/WaveformWidget.cpp"
                                        "src/SettingsManager.cpp" "src/JsonSerializable.cpp" "src/ProjectManager.cpp" "src/CursorManager.cpp" "src/ActionsManager.cpp")

target_link_libraries(${PROJECT_NAME} Qt5::Widgets Qt5::Qml Qt5::Quick Qt5::Multimedia)

add_executable("MFX_launcher" WIN32 "build/packaging/windows/appIcon.rc" "src/launcher.cpp")
target_link_libraries("MFX_launcher" Qt5::Widgets)


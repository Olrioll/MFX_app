cmake_minimum_required(VERSION 3.19.0 FATAL_ERROR)

# ┌──────────────────────────────────────────────────────────────────┐
# │                       Версия приложения                          │
# └──────────────────────────────────────────────────────────────────┘

set(VERSION_MAJOR 0)
set(VERSION_MINOR 1)
set(VERSION_PATCH 0)

set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

# ┌──────────────────────────────────────────────────────────────────┐
# │                       Настройки                                  │
# └──────────────────────────────────────────────────────────────────┘

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED)

set(QT_VERSION 5.15.2)

set(MFX_PROJECT_NAME "MFX" CACHE STRING "Название проекта")
set(MFX_LAUNCHER_PROJECT_NAME "MFXLauncher" CACHE STRING "Название лаунчера для проекта MFX")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(QML_IMPORT_PATH ${CMAKE_SOURCE_DIR}/qml/ CACHE STRING "Директория импорта QML-модулей" FORCE)

set(QSUPERMACROS_USE_QT_SIGNALS ON)
set(QSUPERMACROS_USE_QT_GETTERS_GET ON)
set(QSUPERMACROS_USE_QT_GETTERS ON)
set(QSUPERMACROS_USE_QT_SETTERS ON)
set(QSUPERMACROS_USE_QT_RESETS ON)
set(QSUPERMACROS_BUILD_SHARED OFF)
set(QSUPERMACROS_BUILD_STATIC ON)
set(QSUPERMACROS_BUILD_DOC OFF)

# ┌──────────────────────────────────────────────────────────────────┐
# │                       Зависимости                                │
# └──────────────────────────────────────────────────────────────────┘

include(build/cmake/Dependencies.cmake)
include(build/cmake/FetchQSuperMacros.cmake)

# ┌──────────────────────────────────────────────────────────────────┐
# │                       Сборка                                     │
# └──────────────────────────────────────────────────────────────────┘

project(${MFX_PROJECT_NAME}
    VERSION ${VERSION}
    LANGUAGES CXX
)

find_package(Qt5 ${QT_VERSION} COMPONENTS
    Core
    Gui
    Network
    NetworkAuth
    SerialPort
    Multimedia
    Qml
    Quick
    QuickControls2
    Svg
    EXACT REQUIRED
)

add_executable(${MFX_PROJECT_NAME} WIN32
    "build/packaging/windows/appIcon.rc"
    "qml/qml.qrc"
    "resources/resources.qrc"
    "src/main.cpp"
    "src/AudioTrackRepresentation.cpp"
    "src/WaveformWidget.cpp"
    "src/SettingsManager.cpp"
    "src/JsonSerializable.cpp"
    "src/ProjectManager.cpp"
    "src/CursorManager.cpp"
    "src/ActionsManager.cpp"
    "src/PatchPositionController.cpp"
    "src/Cue.cpp"
    "src/Action.cpp"
    "src/PatternModel.cpp"
    "src/Device.cpp"
    "src/SequenceDevice.cpp"
    "src/Group.cpp"
    "src/DeviceManager.cpp"
    "src/CueManager.cpp"
)

target_link_libraries(${MFX_PROJECT_NAME}
    PRIVATE
    Qt5::Widgets
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
    Qt5::Multimedia
    Qt5::SerialPort
    Qt5::Network
    Qt5::NetworkAuth
    QSuperMacros
)

add_executable(${MFX_LAUNCHER_PROJECT_NAME} WIN32
    "build/packaging/windows/appIcon.rc"
    "src/launcher.cpp"
)

target_link_libraries(${MFX_LAUNCHER_PROJECT_NAME}
    PRIVATE
    Qt5::Widgets
)


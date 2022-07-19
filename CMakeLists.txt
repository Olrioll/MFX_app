cmake_minimum_required(VERSION 3.19.0 FATAL_ERROR)

# ┌──────────────────────────────────────────────────────────────────┐
# │                       Версия приложения                          │
# └──────────────────────────────────────────────────────────────────┘

set(VERSION_MAJOR 0)
set(VERSION_MINOR 1)
set(VERSION_PATCH 1)

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

set(QSUPERMACROS_USE_QT_PREFIX ON CACHE BOOL "")
set(QSUPERMACROS_USE_QT_SIGNALS ON CACHE BOOL "")
set(QSUPERMACROS_USE_QT_GETTERS_GET OFF CACHE BOOL "")
set(QSUPERMACROS_USE_QT_GETTERS ON CACHE BOOL "")
set(QSUPERMACROS_USE_QT_SETTERS ON CACHE BOOL "")
set(QSUPERMACROS_USE_QT_RESETS ON CACHE BOOL "")
set(QSUPERMACROS_BUILD_SHARED OFF CACHE BOOL "")
set(QSUPERMACROS_BUILD_STATIC ON CACHE BOOL "")
set(QSUPERMACROS_BUILD_DOC OFF CACHE BOOL "")
set(UPDATE_TRANSLATIONS OFF CACHE BOOL "Если ON, то просканирует все CPP и QML файлы на наличие строк перевода и создаст/обновит *.ts файлы")

add_compile_options(/wd4819)

# ┌──────────────────────────────────────────────────────────────────┐
# │                       Зависимости                                │
# └──────────────────────────────────────────────────────────────────┘

include(build/cmake/Dependencies.cmake)
include(build/cmake/FetchQSuperMacros.cmake)
#include_directories("../../Firebase/")
#link_directories("../../Firebase/x64/Debug/")
#include_directories("E:/Programs/firebase_cpp_sdk/include")
#add_library(firebase_admob STATIC "../../Firebase/x64/Debug/firebase_admob.lib")
#add_library(firebase_analytics STATIC "../../Firebase/x64/Debug/firebase_analytics.lib")
#add_library(firebase_app STATIC "d:/Firebase/x64/Debug/firebase_app.lib")
#add_library(firebase_auth STATIC "../../Firebase/x64/Debug/firebase_auth.lib")
#add_library(firebase_database STATIC "../../Firebase/x64/Debug/firebase_database.lib")
#add_library(firebase_dynamic_links STATIC "../../Firebase/x64/Debug/firebase_dynamic_links.lib")
#add_library(firebase_firestore STATIC "../../Firebase/x64/Debug/firebase_firestore.lib")
#add_library(firebase_functions STATIC "../../Firebase/x64/Debug/firebase_functions.lib")
#add_library(firebase_installations STATIC "../../Firebase/x64/Debug/firebase_installations.lib")
#add_library(firebase_messaging STATIC "../../Firebase/x64/Debug/firebase_messaging.lib")
#add_library(firebase_remote_config STATIC "../../Firebase/x64/Debug/firebase_remote_config.lib")
#add_library(firebase_storage STATIC "../../Firebase/x64/Debug/firebase_storage.lib")
#include(build/cmake/FetchZLib.cmake)
#set (ZLIB_INCLUDE_DIR ${CMAKE_BINARY_DIR}/_deps/zlib-src ${CMAKE_BINARY_DIR}/_deps/zlib-build)
#set (ZLIB_LIBRARY ${CMAKE_BINARY_DIR}/_deps/zlib-build/libzlibstatic.a)
#include(build/cmake/FetchQuaZip.cmake)

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
    LinguistTools
    EXACT REQUIRED
)

#add_subdirectory(quazip-1.1)

file(GLOB_RECURSE CPP_SOURCES
    ${CMAKE_SOURCE_DIR}/src/*.h}
    ${CMAKE_SOURCE_DIR}/src/*.hpp}
    ${CMAKE_SOURCE_DIR}/src/*.cpp}
    )

file(GLOB_RECURSE QML_SOURCES
    ${CMAKE_SOURCE_DIR}/qml/*.qml
    )

add_custom_target(QML SOURCES ${QML_SOURCES})

#Работа с переводами
file(GLOB_RECURSE TRANSLATION_TS_FILES
    resources/translations/*.ts
    )

set(SCAN_FOR_TRANSLATIONS_FILES
    ${CPP_SOURCES}
    ${QML_SOURCES}
    )

if(UPDATE_TRANSLATIONS)
    qt5_create_translation(TRANSLATION_QM_FILES
        ${SCAN_FOR_TRANSLATIONS_FILES}
        ${TRANSLATION_TS_FILES}
        )
else(UPDATE_TRANSLATIONS)
    qt5_add_translation(TRANSLATION_QM_FILES
        ${TRANSLATION_TS_FILES}
        )
endif(UPDATE_TRANSLATIONS)

add_executable(${MFX_PROJECT_NAME} WIN32
    "build/packaging/windows/appIcon.rc"
    "qml/qml.qrc"
    "resources/resources.qrc"
    "resources/translations.qrc"
    "src/main.cpp"
    "src/AudioTrackRepresentation.cpp"
    "src/WaveformWidget.cpp"
    "src/SettingsManager.cpp"
    "src/JsonSerializable.cpp"
    "src/ProjectManager.cpp"
    "src/CursorManager.cpp"
    "src/Cue.cpp"
    "src/Action.cpp"
    "src/Device.cpp"
    "src/SequenceDevice.cpp"
    "src/Group.cpp"
    "src/DeviceManager.cpp"
    "src/CueManager.cpp"
    "src/QQmlObjectListModel.h"
    "src/ComPortModel"
    "src/CueSortingModel.cpp"
    "src/DmxWorker.cpp"
    "src/Pattern.cpp"
    "src/PatternManager.cpp"
    "src/PatternFilteringModel.cpp"
    "src/Operation.cpp"
    "src/TranslationManager.cpp"
    "src/CueContent.cpp"
    "src/CueContentManager.cpp"
    "src/Language.cpp"
    "src/CueContentSortingModel.cpp"
    "src/DMXDevice.cpp"
    "src/DMXPlugin.cpp"
    "src/DMXWriter.cpp"
    "src/FireBaseClouds.cpp"
 )
#if (NOT "$ENV{FIREBASE_CPP_SDK_DIR}" STREQUAL "")
#  set(DEFAULT_FIREBASE_CPP_SDK_DIR "$ENV{FIREBASE_CPP_SDK_DIR}")
#else()
#  set(DEFAULT_FIREBASE_CPP_SDK_DIR "d:/Firebase/firebase_cpp_sdk")
#endif()
#if ("${FIREBASE_CPP_SDK_DIR}" STREQUAL "")
#  set(FIREBASE_CPP_SDK_DIR ${DEFAULT_FIREBASE_CPP_SDK_DIR})
#endif()
#if(NOT EXISTS ${FIREBASE_CPP_SDK_DIR})
#  message(FATAL_ERROR "The Firebase C++ SDK directory does not exist: ${FIREBASE_CPP_SDK_DIR}. See the readme.md for more information")
#endif()

set(MSVC_RUNTIME_MODE MD)

if(MSVC)
  set(ADDITIONAL_LIBS advapi32 ws2_32 crypt32)
else()
  set(ADDITIONAL_LIBS pthread)
endif()

#add_subdirectory(${FIREBASE_CPP_SDK_DIR} bin/ EXCLUDE_FROM_ALL)
## Note that firebase_app needs to be last in the list.
#set(firebase_libs firebase_storage firebase_auth firebase_app)


target_link_libraries(${MFX_PROJECT_NAME}
    PRIVATE
    "ftd2xx"
    Qt5::Widgets
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
    Qt5::Multimedia
    Qt5::SerialPort
    Qt5::Network
    Qt5::NetworkAuth
    QSuperMacros
#    ${firebase_libs}
    ${ADDITIONAL_LIBS}
#    QuaZip::QuaZip
)


add_executable(${MFX_LAUNCHER_PROJECT_NAME} WIN32
    "build/packaging/windows/appIcon.rc"
    "src/launcher.cpp"
)

target_link_libraries(${MFX_LAUNCHER_PROJECT_NAME}
    PRIVATE
    Qt5::Widgets
)

# ┌──────────────────────────────────────────────────────────────────┐
# │                       Цели сборки                                │
# └──────────────────────────────────────────────────────────────────┘

add_custom_target(updateTranslations DEPENDS ${TRANSLATION_QM_FILES} ${TRANSLATION_TS_FILES})

#Копируем созданные файлы переводов в результурующую папку с артефактами сборки
add_custom_command(TARGET updateTranslations POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/translations
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${TRANSLATION_QM_FILES} ${CMAKE_BINARY_DIR}/translations
    )

#Копируем созданные файлы с переводами в папку ресурсов приложения, чтобы поставлять базовые переводы внутри, и в инсталлер
add_custom_command(TARGET updateTranslations POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${TRANSLATION_QM_FILES} ${CMAKE_SOURCE_DIR}/resources/translations
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${TRANSLATION_QM_FILES} ${CMAKE_SOURCE_DIR}/installer/files/translations
    )

#Генерируем ресурсный файл переводов
if(UPDATE_TRANSLATIONS)
    file(WRITE ${CMAKE_SOURCE_DIR}/resources/translations.qrc "<!DOCTYPE RCC>\n")
    file(APPEND ${CMAKE_SOURCE_DIR}/resources/translations.qrc "<RCC>\n")
    file(APPEND ${CMAKE_SOURCE_DIR}/resources/translations.qrc "    <qresource prefix=\"/\">\n")
    foreach(FILE ${TRANSLATION_QM_FILES})
        string(REPLACE "${CMAKE_CURRENT_BINARY_DIR}/" "translations/" RELATIVE_PATH ${FILE})
        file(APPEND ${CMAKE_SOURCE_DIR}/resources/translations.qrc "        <file>${RELATIVE_PATH}</file>\n")
    endforeach()
    file(APPEND ${CMAKE_SOURCE_DIR}/resources/translations.qrc "    </qresource>\n")
    file(APPEND ${CMAKE_SOURCE_DIR}/resources/translations.qrc "</RCC>\n")
endif()

##firebase
#target_link_libraries(${target_name} "${firebase_libs}" ${ADDITIONAL_LIBS})

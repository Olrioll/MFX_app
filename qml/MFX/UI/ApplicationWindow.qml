import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI.Styles 1.0
import MFX.UI.MainScreen 1.0
import MFX.UI.Components.Basic 1.0

import "qrc:/"

ApplicationWindow
{
    id: applicationWindow
    width: 1280
    height: 660
    x: 300
    y: 70
    visible: true
    color: "#222222"
    title: translationsManager.translationTrigger + qsTr("MFX")
    flags: Qt.Window | Qt.FramelessWindowHint

    property int previousX
    property int previousY

    property int previousGeometryX: x
    property int previousGeometryY: y
    property int previousGeometryWidth: 1280
    property int previousGeometryHeight: 960

    property bool isPatchEditorOpened: false
    property bool isMouseCursorVisible: true
    onIsMouseCursorVisibleChanged: if(isMouseCursorVisible){
                                       cursorManager.showCursor()
                                   }else cursorManager.hideCursor()

    property alias projectSettingsWidget: projectSettingsWidget
    property alias screensLayout: screensLayout

    Component.onCompleted:
    {
        runProject()
    }

    function childWidgetsArea()
    {
        return {x:0, width:width, y:mainMenu.height, height:height}
    }

    Timer
    {
        id: startTimer
        interval: 200
        running: false
        onTriggered: patchMenuButton.checked = true
    }

    function runProject()
    {
        mainScreen.playerWidget.hidePlayerElements()
        mainScreen.playerWidget.waitingText.text = qsTr("Not available")

        backuper.runProject()

        if(project.property("backgroundImageFile") !=="" )
        {
            sceneWidget.backgroundImage.source = "file:///" + settingsManager.workDirectory() + "/" + project.property("backgroundImageFile")
            sceneWidget.centerBackgroundImage()
        }

        screensLayout.currentIndex = 1
        startTimer.running = true
    }

    function createNewProject()
    {
        patchScreen.deviceLibWidget.setActive(false)
        patchScreen.deviceListWidget.setActive(false)
        patchScreen.groupListWidget.setActive(false)

        projectSettingsWidget.isNewProject = true
        projectSettingsWidget.visible = true
    }

    function openProject()
    {
        let openingProject = project.openProjectDialog();
        if(openingProject)
        {
            project.loadProject(openingProject);

            patchMenuButton.checked = true
            sceneWidget.sceneFrameItem.restorePreviousGeometry()
        }
    }


    SceneWidget
    {
        id: sceneWidget

        blockEditions: screensLayout.currentIndex !== 1
        /*onHideSceneFrame: {
            patchScreen.deviceLibWidget.expandButton.clicked()
            patchScreen.deviceListWidget.expandButton.clicked()
            patchScreen.groupListWidget.expandButton.clicked()
        }*/
    }

    MfxMouseArea
    {
        id: overallArea
        anchors.fill: parent
        propagateComposedEvents: true
        acceptedButtons: Qt.NoButton
    }

    MouseArea
    {
        id: bottomResizeArea
        height: 4
        anchors
        {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        cursorShape: Qt.SizeVerCursor

        visible: !fullButton.maximized

        onPressed:
        {
            applicationWindow.previousY = mouseY
        }

        onMouseYChanged:
        {
            var dy = mouseY - applicationWindow.previousY
            applicationWindow.setHeight(applicationWindow.height + dy)
        }
    }

    MouseArea
    {
        id: leftResizeArea
        width: 4
        anchors
        {
            top: mainMenu.bottom
            bottom: bottomResizeArea.top
            left: parent.left
        }
        cursorShape: Qt.SizeHorCursor

        visible: !fullButton.maximized

        onPressed:
        {
            applicationWindow.previousX = mouseX
        }

        onMouseXChanged:
        {
            var dx = mouseX - applicationWindow.previousX
            applicationWindow.setX(applicationWindow.x + dx)
            applicationWindow.setWidth(applicationWindow.width - dx)
        }
    }

    MouseArea
    {
        id: rightResizeArea
        width: 4
        anchors
        {
            top: mainMenu.bottom
            bottom: bottomResizeArea.top
            right: parent.right
        }
        cursorShape:  Qt.SizeHorCursor

        visible: !fullButton.maximized

        onPressed:
        {
            applicationWindow.previousX = mouseX
        }

        onMouseXChanged:
        {
            var dx = mouseX - applicationWindow.previousX
            applicationWindow.setWidth(applicationWindow.width + dx)
        }
    }


    StackLayout
    {
        id: screensLayout

        anchors
        {
            topMargin: 2
            top: mainMenu.bottom
            bottom: bottomResizeArea.top
            right: rightResizeArea.left
            left: leftResizeArea.right
        }

        StartScreen
        {
            id: startScreen
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            visible: false
        }

        PatchScreen
        {
            id: patchScreen
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        MainScreen
        {
            id: mainScreen
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Component.onCompleted: setupSceneWidget(sceneWidget)
        }

        OutputScreen
        {
            id: outputScreen
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
    }

    ProjectSettingsWidget
    {
        id: projectSettingsWidget
        x: applicationWindow.width / 2 - projectSettingsWidget.width / 2
        y: applicationWindow.height / 2 - projectSettingsWidget.height / 2
        visible: false
    }

    Item
    {
        id: mainMenu
        height: 28
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        MouseArea
        {
            id: topResizeArea
            height: 5
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            visible: !fullButton.maximized

            cursorShape: Qt.SizeVerCursor

            onPressed:
            {
                applicationWindow.previousY = mouseY
            }

            onMouseYChanged:
            {
                var dy = mouseY - applicationWindow.previousY
                applicationWindow.setY(applicationWindow.y + dy)
                applicationWindow.setHeight(applicationWindow.height - dy)
            }
        }

        MouseArea
        {
            id: appWindowMoveArea
            height: mainMenu.height - topResizeArea.height
            anchors.top: topResizeArea.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            visible: !fullButton.maximized

            onPressed:
            {
                applicationWindow.previousX = mouseX
                applicationWindow.previousY = mouseY
            }

            onMouseXChanged:
            {
                var dx = mouseX - applicationWindow.previousX
                applicationWindow.setX(applicationWindow.x + dx)
            }

            onMouseYChanged:
            {
                var dy = mouseY - applicationWindow.previousY
                applicationWindow.setY(applicationWindow.y + dy)
            }
        }

        Rectangle
        {
            anchors.fill: parent
            color: "#111111"

            ButtonGroup
            {
                id: mainMenuButtons
            }

            Image
            {
                id: logoImage
                source: "qrc:/menuLogo"
                x: parent.x + 10
            }

            Button
            {
                id: fileMenuButton
                text: translationsManager.translationTrigger + qsTr("File")
                width: 48
                height: 28
                x: logoImage.x + logoImage.width + 10
                layer.enabled: false
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#222222" : "#111111"
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: Fonts.robotoRegular.name
                }

                onCheckedChanged:
                {
                    checked ? fileMenu.open() : fileMenu.close()
                }

                MfxMenu
                {
                    id: fileMenu
                    y: fileMenuButton.height

                    Action
                    {
                        text: translationsManager.translationTrigger + qsTr("New") + " (Ctrl + N)"
                        shortcut: "Ctrl+N"

                        onTriggered:
                        {
                            applicationWindow.createNewProject()
                        }
                    }

                    Action
                    {
                        text: translationsManager.translationTrigger + qsTr("Open") + " (Ctrl + O)"
                        shortcut: "Ctrl+O"

                        onTriggered:
                        {
                            if(project.hasUnsavedChanges())
                            {
                                var confirmSaveDialog = Qt.createComponent("ConfirmationDialog.qml").createObject(applicationWindow);
                                confirmSaveDialog.x = applicationWindow.width / 2 - confirmSaveDialog.width / 2
                                confirmSaveDialog.y = applicationWindow.height / 2 - confirmSaveDialog.height / 2
                                confirmSaveDialog.caption = qsTr("Save project")
                                confirmSaveDialog.dialogText = qsTr("Save changes for the current project?")
                                confirmSaveDialog.acceptButtonText = qsTr("Save changes")
                                confirmSaveDialog.cancelButtonText = qsTr("Do not save")
                                confirmSaveDialog.acceptButtonColor = "#27AE60"
                                confirmSaveDialog.cancelButtonColor = "#EB5757"

                                confirmSaveDialog.accepted.connect(() =>
                                {
                                    project.saveProject()
                                    applicationWindow.openProject()
                                })

                                confirmSaveDialog.declined.connect(() =>
                                {
                                    applicationWindow.openProject()
                                })
                            }
                            else
                                applicationWindow.openProject()
                        }
                    }

                    Action
                    {
                        text: translationsManager.translationTrigger + qsTr("Save") + " (Ctrl + S)"
                        shortcut: "Ctrl+S"

                        onTriggered:
                        {
                            project.saveProject()
                        }
                    }

                    MfxMenu
                    {
                        title: translationsManager.translationTrigger + qsTr("Import")

                        Action
                        {
                            text: translationsManager.translationTrigger + qsTr("Audio track")

                            onTriggered:
                            {
                                project.importAudioTrack()
                            }
                        }

                        Action
                        {
                            text: translationsManager.translationTrigger + qsTr("Background img")

                            onTriggered:
                            {
                                project.importBackgroundImage()
                            }
                        }
                    }

                    MfxMenu
                    {
                        title: translationsManager.translationTrigger + qsTr("Export")

                        Action
                        {
                            text: translationsManager.translationTrigger + qsTr("Audio track")

                            onTriggered:
                            {
                                project.exportAudioTrack()
                            }
                        }

                        Action
                        {
                            text: translationsManager.translationTrigger + qsTr("Background img")

                            onTriggered:
                            {
                                project.exportBackgroundImage()
                            }
                        }

                        Action
                        {
                            text: translationsManager.translationTrigger + qsTr("Output json file")

                            onTriggered:
                            {
                                project.exportOutputJson(false)
                            }
                        }
                    }

                    Action
                    {
                        text: translationsManager.translationTrigger + qsTr("Preferences")
                        onTriggered:
                        {
                            var preferencesPopup = Qt.createComponent("UtilityWindow.qml").createObject(applicationWindow);
                            preferencesPopup.addContentItem("PreferencesPopup.qml");

                            preferencesPopup.width = 220
                            preferencesPopup.height = 298
                            preferencesPopup.workAreaColor = "#444444"
                            preferencesPopup.x = applicationWindow.width / 2 - preferencesPopup.width / 2
                            preferencesPopup.y = applicationWindow.height / 2 - preferencesPopup.height / 2
                            preferencesPopup.caption = qsTr("Preferences")
                        }
                    }

                    onClosed: fileMenuButton.checked = false
                }
            }

            Button
            {
                id: editMenuButton
                text: translationsManager.translationTrigger + qsTr("Edit")
                width: 48
                height: 28
                anchors.left: fileMenuButton.right
                anchors.leftMargin: 4
                layer.enabled: false
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle
                {
                    color: parent.checked ? "#222222" : "#111111"
                }

                contentItem: Text
                {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: Fonts.robotoRegular.name
                }

                onCheckedChanged:
                {
                    checked ? editMenu.open() : editMenu.close()
                }

                MfxMenu
                {
                    id: editMenu
                    y: editMenuButton.height

                    Action
                    {
                        text: translationsManager.translationTrigger + qsTr("Scene frame")
                        onTriggered:
                        {
                            sceneWidget.showFrame()
                        }
                    }

                    Action
                    {
                        text: translationsManager.translationTrigger + qsTr("Project settings")
                        onTriggered:
                        {
                            projectSettingsWidget.isNewProject = false
                            projectSettingsWidget.visible = true
                        }
                    }

                    onClosed: editMenuButton.checked = false
                }
            }

            Button
            {
                id: patchMenuButton
                text: translationsManager.translationTrigger + qsTr("Patch")
                width: 48
                height: 28
                anchors.left: editMenuButton.right
                anchors.leftMargin: 4
                layer.enabled: false
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#222222" : "#111111"
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: Fonts.robotoRegular.name
                }

                ButtonGroup.group: mainMenuButtons

                onCheckedChanged:
                {
                    if(checked)
                    {
                        screensLayout.currentIndex = 1
                        patchScreen.setupSceneWidget(sceneWidget)
                    }
                }
            }

            Button
            {
                id: mainMenuButton
                text: translationsManager.translationTrigger + qsTr("Main")
                width: 48
                height: 28
                anchors.left: patchMenuButton.right
                anchors.leftMargin: 4
                layer.enabled: false
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#222222" : "#111111"
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: Fonts.robotoRegular.name
                }

                onCheckedChanged:
                {
                    if(checked)
                    {
                        screensLayout.currentIndex = 2
                        mainScreen.setupSceneWidget(sceneWidget)
                    }
                }

                ButtonGroup.group: mainMenuButtons
            }

            Button
            {
                id: outputMenuButton
                text: translationsManager.translationTrigger + qsTr("Output")
                width: 56
                height: 28
                anchors.left: mainMenuButton.right
                anchors.leftMargin: 7
                layer.enabled: false
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#222222" : "#111111"
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: Fonts.robotoRegular.name
                }

                onCheckedChanged:
                {
                    if(checked) {
                        screensLayout.currentIndex = 3
                    }
                }

                ButtonGroup.group: mainMenuButtons
            }

            Button
            {
                id: keyButton
                text: translationsManager.translationTrigger + qsTr("Key")
                width: 60
                height: 24
                x: outputMenuButton.x + outputMenuButton.width + 36
                y: mainMenu.y + 2
                layer.enabled: false
                font.pointSize: 12
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#5F27CD" : "#222222"
                    radius: 2
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: Fonts.robotoRegular.name
                }

                onCheckedChanged:
                {
                    if(checked)
                        midiButton.checked = false
                }
            }

            Button
            {
                id: midiButton
                text: "MIDI"
                width: 60
                height: 24
                x: keyButton.x + keyButton.width + 8
                y: mainMenu.y + 2
                layer.enabled: false
                font.pointSize: 12
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#6BAAFF" : "#222222"
                    radius: 2
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: Fonts.robotoRegular.name
                }

                onCheckedChanged:
                {
                    if(checked)
                        keyButton.checked = false
                }
            }

            Button
            {
                id: dmxButton
                text: translationsManager.translationTrigger + qsTr("DMX out")
                width: 80
                height: 24
                x: midiButton.x + midiButton.width + 64
                y: mainMenu.y + 2
                layer.enabled: false
                font.pointSize: 12
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#EB5757" : "#222222"
                    radius: 2
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: Fonts.robotoRegular.name
                }
            }

            Button
            {
                id: hideButton
                x: fullButton.x - width - 1
                width: 28
                height: 28

                bottomPadding: 0
                topPadding: 0
                rightPadding: 0
                leftPadding: 0

                Image
                {
                    source: "qrc:/hideButton"
                }

                onClicked:
                {
                    applicationWindow.showMinimized()
                }

            }

            Button
            {
                id: fullButton
                x: closeButton.x - width - 1
                width: 28
                height: 28

                bottomPadding: 0
                topPadding: 0
                rightPadding: 0
                leftPadding: 0

                property bool maximized: false

                Image
                {
                    id: fullButtonImage
                    source: "qrc:/fullButton"
                }

                onClicked:
                {
                    if(fullButton.maximized)
                    {
                        fullButtonImage.source = "qrc:/fullButton"
                        fullButton.maximized = false
                        applicationWindow.showNormal()
                    }

                    else
                    {
                        fullButtonImage.source = "qrc:/prevSizeButton"
                        fullButton.maximized = true
                        applicationWindow.showMaximized()
                    }
                }
            }

            Button
            {
                id: closeButton
                width: 28
                height: 28
                anchors.right: parent.right

                bottomPadding: 0
                topPadding: 0
                rightPadding: 0
                leftPadding: 0

                Image
                {
                    source: "qrc:/closeButton"
                }

                onClicked:
                {
                    if(project.hasUnsavedChanges())
                    {
                        var confirmSaveDialog = Qt.createComponent("ConfirmationDialog.qml").createObject(applicationWindow);
                        confirmSaveDialog.x = applicationWindow.width / 2 - confirmSaveDialog.width / 2
                        confirmSaveDialog.y = applicationWindow.height / 2 - confirmSaveDialog.height / 2
                        confirmSaveDialog.caption = qsTr("Save project")
                        confirmSaveDialog.dialogText = qsTr("Save changes before quitting?")
                        confirmSaveDialog.acceptButtonText = qsTr("Save changes")
                        confirmSaveDialog.cancelButtonText = qsTr("Do not save")
                        confirmSaveDialog.acceptButtonColor = "#27AE60"
                        confirmSaveDialog.cancelButtonColor = "#EB5757"

                        confirmSaveDialog.declined.connect(() =>
                        {
                            Qt.quit()
                        })

                        confirmSaveDialog.accepted.connect(() =>
                        {
                            project.saveProject()
                            Qt.quit()
                        })
                    }

                    else
                        Qt.quit()
                }
            }
        }
    }

    function showPatchScreen()
    {
        patchMenuButton.checked = true
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

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
    title: qsTr("MFX")
    flags: Qt.Window | Qt.FramelessWindowHint

    property int previousX
    property int previousY

    property int previousGeometryX: x
    property int previousGeometryY: y
    property int previousGeometryWidth: 1280
    property int previousGeometryHeight: 960

    property bool isPatchEditorOpened: false
    property bool isMouseCursorVisible: true

    property alias projectSettingsWidget: projectSettingsWidget
    property alias screensLayout: screensLayout

    function childWidgetsArea()
    {
        return {x:0, width:width, y:mainMenu.height, height:height}
    }

    function createNewProject()
    {
        mainScreen.playerWidget.hidePlayerElements()
        mainScreen.playerWidget.waitingText.text = qsTr("Not available")
        project.newProject()
        projectSettingsWidget.visible = true

        patchScreen.deviceLibWidget.setActive(false)
        patchScreen.deviceListWidget.setActive(false)
        patchScreen.groupListWidget.setActive(false)
    }

    function openProject()
    {
        let openingProject = project.openProjectDialog();
        if(openingProject)
        {
            project.loadProject(openingProject);

            if(project.property("audioTrackFile") !== "")
                mainScreen.playerWidget.waitingText.text = qsTr("Downloading...")
            else
                mainScreen.playerWidget.waitingText.text = qsTr("Not available")

            patchMenuButton.checked = true
        }
    }


    SceneWidget
    {
        id: sceneWidget
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
                text: qsTr("File")
                width: 40
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
                    font.family: "Roboto"
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
                        text: qsTr("New")
                        onTriggered:
                        {
                            applicationWindow.createNewProject()
                        }
                    }

                    Action
                    {
                        text: qsTr("Open")
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

                    MfxMenu
                    {
                        title: qsTr("Save")
                        id: saveSubMenu

                        Action { text: qsTr("Project") }
                        Action { text: qsTr("Workspace") }
                        Action { text: qsTr("Patch") }
                    }

                    Action { text: qsTr("Export") }
                    Action
                    {
                        text: qsTr("Preferences")
                        onTriggered:
                        {
                            var test = Qt.createComponent("UtilityWindow.qml").createObject(applicationWindow);
                            test.x = 100
                            test.y = 100
                            test.caption = qsTr("Preferences")
                        }
                    }

                    onClosed: fileMenuButton.checked = false
                }


            }

            Button
            {
                id: patchMenuButton
                text: qsTr("Patch")
                width: 40
                height: 28
                anchors.left: fileMenuButton.right
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
                    font.family: "Roboto"
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
                text: qsTr("Main")
                width: 40
                height: 28
                anchors.left: patchMenuButton.right
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
                    font.family: "Roboto"
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
                text: qsTr("Output")
                width: 48
                height: 28
                anchors.left: mainMenuButton.right
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
                    font.family: "Roboto"
                }

                onCheckedChanged:
                {
                    if(checked)
                        screensLayout.currentIndex = 2
                }

                ButtonGroup.group: mainMenuButtons
            }

            Button
            {
                id: keyButton
                text: qsTr("Key")
                width: 60
                height: 24
                x: outputMenuButton.x + outputMenuButton.width + 30
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
                    font.family: "Roboto"
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
                x: keyButton.x + keyButton.width + 10
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
                    font.family: "Roboto"
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
                text: qsTr("DMX out")
                width: 60
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
                    font.family: "Roboto"
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

    Connections
    {
        target: projectSettingsWidget
        function onCreateButtonClicked()
        {
            patchMenuButton.checked = true
        }
    }

}

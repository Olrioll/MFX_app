import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
    id: startScreen

    Rectangle
    {
        id: background
        anchors.fill: parent
        color: "#000000"
    }

    Image
    {
        id: logo
        source: "qrc:/startScreenLogo"
        width: sourceSize.width
        height: sourceSize.height
        anchors.centerIn: parent
    }

    MfxButton
    {
        id: openProjectButton
        text: translationsManager.translationTrigger + qsTr("Open Project")
        color: "#2F80ED"
        width: 200
        height: 48

        anchors.topMargin: 36
        anchors.top: logo.bottom
        anchors.horizontalCenter: logo.horizontalCenter

        onClicked: applicationWindow.openProject()
    }

    MfxButton
    {
        id: createProjectButton
        text: translationsManager.translationTrigger + qsTr("Create Project")
        color: "#2F80ED"
        width: 200
        height: 48

        anchors.topMargin: 36
        anchors.top: logo.bottom
        anchors.rightMargin: 20
        anchors.right: openProjectButton.left

        onClicked: applicationWindow.createNewProject()
    }

    MfxButton
    {
        id: openWorkspaceButton
        text: translationsManager.translationTrigger + qsTr("Open Workspace")
        color: "#2F80ED"
        width: 200
        height: 48

        anchors.topMargin: 36
        anchors.top: logo.bottom
        anchors.leftMargin: 20
        anchors.left: openProjectButton.right
    }
}

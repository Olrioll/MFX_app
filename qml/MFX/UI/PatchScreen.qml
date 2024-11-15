import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI.Components.Basic 1.0

Item
{
    id: patchScreen

    property var sceneWidget: null

    property alias deviceLibWidget: deviceLib
    property alias deviceListWidget: deviceList
    property alias groupListWidget: groupList

    function setupSceneWidget(widget)
    {
        console.log( "PatchScreen.setupSceneWidget" )

        sceneWidget = widget

        if(!sceneWidget)
            return

        sceneWidget.parent = sceneWidgetItem
        sceneWidget.anchors.fill = sceneWidgetItem
        sceneWidget.visible = true

        sceneWidget.setProportion()
    }

    Item
    {
        id: sceneWidgetItem

        anchors.margins: 2
        anchors.left: patchScreen.left
        anchors.right: groupList.left
        anchors.top: patchScreen.top
        anchors.bottom: patchScreen.bottom
    }

    SideDockedWindow
    {
        id: deviceLib
        anchors.right: patchScreen.right
        anchors.top: patchScreen.top
        anchors.bottom: patchScreen.bottom

        caption: translationsManager.translationTrigger + qsTr("Library")
        expandedWidth: 140

        contentItem: DeviceLibWidget
        {

        }
    }

    SideDockedWindow
    {
        id: deviceList
        anchors.rightMargin: 2
        anchors.right: deviceLib.left
        anchors.top: patchScreen.top
        anchors.bottom: patchScreen.bottom

        caption: translationsManager.translationTrigger + qsTr("Devices list")
        minWidth: 200

        contentItem: GeneralDeviceListWidget
        {
            id: devListWidget
        }

        Button
        {
            id: changeViewButton
            width: 20
            height: 20
            anchors.rightMargin: 22
            anchors.right: parent.right
            anchors.topMargin: 6
            anchors.top: parent.top
            visible: deviceList.isExpanded

            bottomPadding: 0
            topPadding: 0
            rightPadding: 0
            leftPadding: 0

            background: Rectangle {
                    color: "#444444"
                    opacity: 0
                    radius: 2
                }

            Image
            {
                source: "qrc:/changeView"
            }
        }

        Connections
        {
            target: changeViewButton
            function onClicked()
            {
                devListWidget.changeView()
            }
        }
    }

    SideDockedWindow
    {
        id: groupList
        anchors.rightMargin: 2
        anchors.right: deviceList.left
        anchors.top: patchScreen.top
        anchors.bottom: patchScreen.bottom

        caption: translationsManager.translationTrigger + qsTr("Device groups")
        minWidth: 160

        contentItem: DeviceGroupWidget
        {
            width: collapsed ? 184 : 348
        }
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
    id: patchScreen

    property var sceneWidget: null

    property alias deviceLibWidget: deviceLib
    property alias deviceListWidget: deviceList
    property alias groupListWidget: groupList

    function setupSceneWidget(widget)
    {
        sceneWidget = widget

        if(!sceneWidget)
            return

        sceneWidget.parent = sceneWidgetItem
        sceneWidget.anchors.fill = sceneWidgetItem
        sceneWidget.visible = true

//        console.log(sceneWidget.height)
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

        Connections
        {
            target: deviceLib
            function onWidthChanged()
            {

//                let dx = deviceLib.expandedWidth - deviceLib.collapsedWidth

//                if(deviceLib.width === deviceLib.collapsedWidth)
//                {
//                    sceneWidget.adjustBackgroundImageOnX(-dx)
//                }

//                else
//                {
//                    sceneWidget.adjustBackgroundImageOnX(dx)
//                }
                sceneWidget.adjustBackgroundImageOnX()
            }
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

        Connections
        {
            target: deviceList
            function onWidthChanged()
            {
                sceneWidget.adjustBackgroundImageOnX()

//                let dx = deviceList.expandedWidth - deviceList.collapsedWidth

//                if(deviceList.width === deviceList.collapsedWidth)
//                {
//                    sceneWidget.adjustBackgroundImageOnX(-dx)
//                }

//                else
//                {
//                    sceneWidget.adjustBackgroundImageOnX(dx)
//                }
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

        contentItem: DeviceGroupWidget
        {
            width: collapsed ? 184 : 348
        }

        Connections
        {
            target: groupList
            function onWidthChanged()
            {
                sceneWidget.adjustBackgroundImageOnX()

//                let dx = groupList.expandedWidth - groupList.collapsedWidth

//                if(groupList.width === groupList.collapsedWidth)
//                {
//                    sceneWidget.adjustBackgroundImageOnX(-dx)
//                }

//                else
//                {
//                    sceneWidget.adjustBackgroundImageOnX(dx)
//                }
            }
        }
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
    id: patchScreen

    property var sceneWidget: null

    function setupSceneWidget(widget)
    {
        sceneWidget = widget

        if(!sceneWidget)
            return

        sceneWidget.parent = this
        sceneWidget.anchors.margins = 2
        sceneWidget.anchors.left = patchScreen.left
        sceneWidget.anchors.right = groupList.left
        sceneWidget.anchors.top = patchScreen.top
        sceneWidget.anchors.bottom = patchScreen.bottom
    }

    SideDockedWindow
    {
        id: deviceLib
        anchors.right: patchScreen.right
        anchors.top: patchScreen.top
        anchors.bottom: patchScreen.bottom

        caption: qsTr("Library")
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

        caption: qsTr("Devices list")

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
            visible: parent.isExpanded

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

        caption: qsTr("Device groups")

        contentItem: DeviceGroupWidget
        {

        }
    }

//    SceneWidget
//    {
//        id: sceneWidget
//        anchors.margins: 2
//        anchors.left: patchScreen.left
//        anchors.right: groupList.left
//        anchors.top: patchScreen.top
//        anchors.bottom: patchScreen.bottom
//    }
}

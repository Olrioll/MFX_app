import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
    id: patchScreen

    SideDockedWindow
    {
        id: deviceLib
        anchors.right: patchScreen.right
        anchors.top: patchScreen.top
        anchors.bottom: patchScreen.bottom

        caption: qsTr("Library")
        expandedWidth: 140

        Component.onCompleted:
        {
            addContentItem("DeviceLibWidget.qml", {})
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
        expandedWidth: 400

        Component.onCompleted:
        {
            addContentItem("GeneralDeviceListWidget.qml", {})
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
        expandedWidth: 430

        Component.onCompleted:
        {
            addContentItem("DeviceGroupWidget.qml", {})
        }
    }

    Item
    {
        id: sceneWidget
        anchors.margins: 2
        anchors.left: patchScreen.left
        anchors.right: groupList.left
        anchors.top: patchScreen.top
        anchors.bottom: patchScreen.bottom

        Flickable
        {
            id: sceneImage
            anchors.fill: parent
            contentWidth: backgroundImage.width
            contentHeight: backgroundImage.height
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { /*policy: ScrollBar.AlwaysOn*/ }
            ScrollBar.horizontal: ScrollBar { /*policy: ScrollBar.AlwaysOn*/ }

            property real scaleFactor: 1.0

            function zoom(step)
            {
                sceneImage.scaleFactor += step
            }

            Image
            {
                id: backgroundImage
                width: sourceSize.width * sceneImage.scaleFactor
                height: sourceSize.height * sceneImage.scaleFactor
                source: "file:///d:/Upwork/MFX/scene.png"
            }

        }

        Item
        {
            id: zoomControls
            width: 24
            height: 60

            anchors.leftMargin: 10
            anchors.left: parent.left

            anchors.bottomMargin: 48
            anchors.bottom: parent.bottom

            Rectangle
            {
                y: 20
                width: 24
                height: 30
                color: "#333333"
            }

            Button
            {
                id: zoomInButton

                width: 24
                height: 30

                bottomPadding: 0
                topPadding: 0
                rightPadding: 0
                leftPadding: 0

                text: "+"

                background: Rectangle
                {
                    color: parent.pressed ? "#222222" : "#333333"
                    radius: 20
                }

                contentItem: Text
                {
                    color: parent.enabled ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: "Roboto"
                    font.pixelSize: 16
                }

                onClicked: sceneImage.zoom(0.05)
            }

            Button
            {
                id: zoomOutButton

                y: 32
                width: 24
                height: 30

                bottomPadding: 0
                topPadding: 0
                rightPadding: 0
                leftPadding: 0

                text: "-"

                background: Rectangle
                {
                    color: parent.pressed ? "#222222" : "#333333"
                    radius: 20
                }

                contentItem: Text
                {
                    color: parent.enabled ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: "Roboto"
                    font.pixelSize: 20
                }

                onClicked: sceneImage.zoom(-0.05)
            }

            Rectangle
            {
                x: 2
                y: 30
                width: 20
                height: 2
                color: "#222222"
            }

        }


    }
}

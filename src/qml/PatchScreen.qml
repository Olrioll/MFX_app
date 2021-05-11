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
        clip: true

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

            property real scaleFactor: project.property("sceneScaleFactor")

            function zoom(step)
            {
                sceneImage.scaleFactor += step
                project.setProperty("sceneScaleFactor", sceneImage.scaleFactor)
            }

            Image
            {
                id: backgroundImage
                width: sourceSize.width * sceneImage.scaleFactor
                height: sourceSize.height * sceneImage.scaleFactor
                source: "file:///d:/Upwork/MFX/scene.png"
            }

        }

        Rectangle
        {
            id: sceneFrame
            x: project.property("sceneFrameX") * sceneImage.contentWidth + ( - sceneImage.visibleArea.xPosition * sceneImage.contentWidth)
            y: project.property("sceneFrameY") * sceneImage.contentHeight + ( - sceneImage.visibleArea.yPosition * sceneImage.contentHeight)
            width: project.sceneFrameWidth * sceneImage.contentWidth
            height: width * project.property("sceneHeight") / project.property("sceneWidth")
            color: "transparent"
            border.width: 2
            border.color: "#507FE6"
            radius: 2

            property int minWidth: 100

            Item
            {
                id: resizeControls
                width: 24
                height: 60

                anchors.topMargin: 10
                anchors.top: parent.top
                anchors.rightMargin: 10
                anchors.right: parent.right

                anchors.bottomMargin: 48
                anchors.bottom: parent.bottom

                Rectangle
                {
                    y: 20
                    width: 24
                    height: 30
                    color: "#507FE6"
                }

                Button
                {
                    id: button_plus

                    width: 24
                    height: 30

                    bottomPadding: 0
                    topPadding: 0
                    rightPadding: 0
                    leftPadding: 0

                    text: "+"

                    background: Rectangle
                    {
                        color: parent.pressed ? "#666666" : "#507FE6"
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

                    onClicked:
                    {
                        project.sceneFrameWidth += 0.01
                    }
                }

                Button
                {
                    id: button_minus

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
                        color: parent.pressed ? "#666666" : "#507FE6"
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

                    onClicked:
                    {
                        project.sceneFrameWidth -= 0.01
                    }
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

        Rectangle
        {
            id: sceneTitle
            x: sceneFrame.x + sceneFrame.width / 2 - width / 2
            y: sceneFrame.y - height / 2
            width: 62
            height: 20
            color: "#507FE6"
            radius: 26

            Text
            {
                anchors.centerIn: parent
                text: qsTr("SCENE")
                color: "#ffffff"
                font.family: "Roboto"
                font.pixelSize: 12
            }

            MouseArea
            {
                id: mouseArea
                anchors.fill: parent
                preventStealing: true

                drag.target: sceneFrame
                drag.axis: Drag.XandYAxis

                drag.minimumX: sceneWidget.mapToItem(sceneImage, 0, 0).x
                drag.maximumX: sceneImage.contentWidth - sceneFrame.width
                drag.minimumY: sceneWidget.mapToItem(sceneImage, 0, 0).y + 10
                drag.maximumY: sceneImage.contentHeight - sceneFrame.height

                onReleased:
                {
                    project.setProperty("sceneFrameX", (sceneFrame.x + sceneImage.visibleArea.xPosition * sceneImage.contentWidth) / sceneImage.contentWidth)
                    project.setProperty("sceneFrameY", (sceneFrame.y + sceneImage.visibleArea.yPosition * sceneImage.contentHeight) / sceneImage.contentHeight)
                }
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

            Button
            {
                id: fitButton

                y: 76
                width: 24
                height: 24

                bottomPadding: 0
                topPadding: 0
                rightPadding: 0
                leftPadding: 0

                text: "-"

                background: Rectangle
                {
                    color: parent.pressed ? "#222222" : "#333333"
                    radius: 24
                }

                Image
                {
                    anchors.centerIn: parent
                    source: "qrc:/fit"
                }

                onClicked:
                {

                }
            }

        }
    }
}

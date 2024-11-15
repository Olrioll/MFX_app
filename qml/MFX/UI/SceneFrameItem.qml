import QtQuick 2.15
import QtQuick.Controls 2.15

import MFX.UI.Styles 1.0

Item
{
    id: sceneFrameItem

    property int minWidth: 10
    property int minHeight: 10

    onVisibleChanged:
    {
        if(visible)
            restorePreviousGeometry();
        //else
        //    sceneWidget.hideSceneFrame()
    }

    function restorePreviousGeometry()
    {
        x = project.property("sceneFrameX") * backgroundImage.width + backgroundImage.x
        y = project.property("sceneFrameY") * backgroundImage.height + backgroundImage.y
        width = project.property("sceneImageWidth") * backgroundImage.width
        height = project.property("sceneFrameHeight") / project.property("sceneFrameWidth") * width
        frameHeightText.text = project.property("sceneFrameHeight") + " m"
        frameWidthText.text = project.property("sceneFrameWidth") + " m"
        //console.log( sceneWidget.scaleFactor , sceneWidget.width,sceneWidget.height,backgroundImage.x,backgroundImage.height)
        /*if(sceneWidget.width > 0)
        {
            sceneWidget.scaleFactor = project.property("sceneScaleFactor") === undefined ? 1.0 : project.property("sceneScaleFactor")
            if(sceneWidget.width <= backgroundImage.width )
            {
                sceneWidget.scaleFactor = sceneWidget.width / backgroundImage.sourceSize.width;
            }

            if(sceneWidget.height <= backgroundImage.height )
            {
                sceneWidget.scaleFactor = sceneWidget.height / backgroundImage.sourceSize.height;
            }

            var currentSceneFrameX = (x - backgroundImage.x) / backgroundImage.width
            var currentSceneFrameY = (y - backgroundImage.y) / backgroundImage.height

            var prevWidth = backgroundImage.width;
            var prevHeight = backgroundImage.height;
            var newWidth = backgroundImage.sourceSize.width * sceneWidget.scaleFactor;
            var newHeight = backgroundImage.sourceSize.height * sceneWidget.scaleFactor;
            var currWidthChange = newWidth - prevWidth;
            var currHeightChange = newHeight - prevHeight;

            let newScaleFactror = sceneWidget.scaleFactor
            let scaleRatio = newScaleFactror / 1.0

            if(backgroundImage.width <= sceneWidget.width)
            {
                backgroundImage.x = (sceneWidget.width - backgroundImage.width) / 2
            }

            else
            {
                let dx = ((sceneWidget.width/2) - backgroundImage.x) / prevWidth * currWidthChange
                backgroundImage.x -= dx
            }

            if(backgroundImage.height <= sceneWidget.height)
            {
                backgroundImage.y = (sceneWidget.height - backgroundImage.height) / 2
            }

            else
            {
                let dy = ((sceneWidget.height/2) - backgroundImage.y) / prevHeight * currHeightChange
                backgroundImage.y -= dy
            }

            x = currentSceneFrameX * newWidth + backgroundImage.x
            y = currentSceneFrameY * newHeight + backgroundImage.y
            width = width * scaleRatio
            height = height * scaleRatio
        }*/
    }

    Rectangle
    {
        id: sceneFrame
        anchors.fill: parent
        color: "#20507FE6"
        border.width: 2
        border.color: "#507FE6"
        radius: 2

        property int minWidth: 100

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

            property int prevY

            onPressed:
            {
                prevY = mouseY
            }

            onMouseYChanged:
            {
                var dy = mouseY - prevY

                var newHeight = sceneFrameItem.height + dy
                var newWidth = sceneFrameItem.width * newHeight / sceneFrameItem.height

                if(!(sceneFrameItem.y + newHeight > backgroundImage.y + backgroundImage.height) &&
                        !(sceneFrameItem.x + newWidth > backgroundImage.x + backgroundImage.width) &&
                        newHeight >= sceneFrameItem.minHeight &&
                        newWidth >= sceneFrameItem.minWidth)
                {
                    sceneFrameItem.width = newWidth
                    sceneFrameItem.height = newHeight
                }
            }
        }

        MouseArea
        {
            id: topResizeArea
            height: 4
            anchors
            {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            cursorShape: Qt.SizeVerCursor

            property int prevY

            onPressed:
            {
                prevY = mouseY
            }

            onMouseYChanged:
            {
                var dy = mouseY - prevY

                var newHeight = sceneFrameItem.height - dy
                var newWidth = sceneFrameItem.width * newHeight / sceneFrameItem.height
                var dx = sceneFrameItem.width - newWidth

                if((sceneFrameItem.y + dy > backgroundImage.y) &&
                        (sceneFrameItem.x + dx > backgroundImage.x) &&
                        newHeight >= sceneFrameItem.minHeight &&
                        newWidth >= sceneFrameItem.minWidth)
                {
                    sceneFrameItem.width = newWidth
                    sceneFrameItem.height = newHeight
                    sceneFrameItem.x += dx
                    sceneFrameItem.y += dy
                }
            }
        }

        MouseArea
        {
            id: rightResizeArea
            width: 4
            anchors
            {
                bottom: parent.bottom
                right: parent.right
                top: parent.top
            }
            cursorShape: Qt.SizeHorCursor

            property int prevX

            onPressed:
            {
                prevX = mouseX
            }

            onMouseXChanged:
            {
                var dx = mouseX - prevX

                var newWidth = sceneFrameItem.width + dx
                var newHeight = sceneFrameItem.height * newWidth / sceneFrameItem.width

                if(!(sceneFrameItem.y + newHeight > backgroundImage.y + backgroundImage.height) &&
                        !(sceneFrameItem.x + newWidth > backgroundImage.x + backgroundImage.width) &&
                        newHeight >= sceneFrameItem.minHeight &&
                        newWidth >= sceneFrameItem.minWidth)
                {
                    sceneFrameItem.width = newWidth
                    sceneFrameItem.height = newHeight
                }
            }
        }

        MouseArea
        {
            id: leftResizeArea
            width: 4
            anchors
            {
                bottom: parent.bottom
                right: parent.left
                top: parent.top
            }
            cursorShape: Qt.SizeHorCursor

            property int prevX

            onPressed:
            {
                prevX = mouseX
            }

            onMouseXChanged:
            {
                var dx = mouseX - prevX

                var newWidth = sceneFrameItem.width - dx
                var newHeight = sceneFrameItem.height * newWidth / sceneFrameItem.width
                var dy = sceneFrameItem.height - newHeight

                if((sceneFrameItem.y + dy > backgroundImage.y) &&
                        (sceneFrameItem.x + dx > backgroundImage.x) &&
                        newHeight >= sceneFrameItem.minHeight &&
                        newWidth >= sceneFrameItem.minWidth)
                {
                    sceneFrameItem.width = newWidth
                    sceneFrameItem.height = newHeight
                    sceneFrameItem.x += dx
                    sceneFrameItem.y += dy
                }
            }
        }

        MouseArea
        {
            id: movingArea
            anchors.top: topResizeArea.bottom
            anchors.bottom: bottomResizeArea.top
            anchors.left: leftResizeArea.right
            anchors.right: rightResizeArea.left
            preventStealing: true

            drag.target: sceneFrameItem
            drag.axis: Drag.XandYAxis

            drag.minimumX: backgroundImage.x
            drag.maximumX: backgroundImage.width - sceneFrame.width + backgroundImage.x
            drag.minimumY: backgroundImage.y
            drag.maximumY: backgroundImage.height - sceneFrame.height + backgroundImage.y
        }
    }

    Rectangle
    {
        id: sceneTitle
        anchors.rightMargin: 8
        anchors.right: applyButton.left
        anchors.bottom: cancelButton.bottom
        width: 62
        height: 20
        color: "#507FE6"
        radius: 26

        Text
        {
            anchors.centerIn: parent
            text: translationsManager.translationTrigger + qsTr("SCENE")
            color: "#ffffff"
            font.family: Fonts.robotoRegular.name
            font.pixelSize: 12
        }

        MouseArea
        {
            id: movingArea2
            anchors.fill: parent
            preventStealing: true

            drag.target: sceneFrameItem
            drag.axis: Drag.XandYAxis

            drag.minimumX: backgroundImage.x
            drag.maximumX: backgroundImage.width - sceneFrame.width + backgroundImage.x
            drag.minimumY: backgroundImage.y
            drag.maximumY: backgroundImage.height - sceneFrame.height + backgroundImage.y
        }
    }

    Button
    {
        id: applyButton
        anchors.rightMargin: 4
        anchors.right: cancelButton.left
        anchors.bottom: cancelButton.bottom
        width: 18
        height: 18

        background: Rectangle
        {
            color: "#27AE60"
            radius: 9
        }

        Image
        {
            anchors.centerIn: parent
            source: "qrc:/apply"
        }

        onClicked:
        {
            project.setProperty("sceneFrameX", (sceneFrameItem.x - backgroundImage.x) / backgroundImage.width)
            project.setProperty("sceneFrameY", (sceneFrameItem.y - backgroundImage.y) / backgroundImage.height)
            project.setProperty("sceneImageWidth", sceneFrameItem.width / backgroundImage.width)
            sceneFrameItem.visible = false
            patchScreen.deviceLibWidget.setActive(true)
            patchScreen.deviceListWidget.setActive(true)
            patchScreen.groupListWidget.setActive(true)
        }
    }

    Button
    {
        id: cancelButton
        anchors.bottomMargin: 4
        anchors.right: sceneFrame.right
        anchors.bottom: sceneFrame.top
        width: 18
        height: 18

        background: Rectangle
        {
            color: "#EB5757"
            radius: 9
        }

        Image
        {
            anchors.centerIn: parent
            source: "qrc:/cancel"
        }

        onClicked:
        {
            sceneFrameItem.visible = false
            patchScreen.deviceLibWidget.setActive(true)
            patchScreen.deviceListWidget.setActive(true)
            patchScreen.groupListWidget.setActive(true)
        }
    }

    Text
    {
        id: frameHeightText
        anchors.rightMargin: 4
        anchors.right: sceneFrame.left
        anchors.verticalCenter: sceneFrame.verticalCenter
        text: project.property("sceneFrameHeight") + " m"
        color: "#507FE6"
        font.family: Fonts.robotoRegular.name
        font.pixelSize: 12
    }

    Text
    {
        id: frameWidthText
        anchors.topMargin: 4
        anchors.top: sceneFrame.bottom
        anchors.horizontalCenter: sceneFrame.horizontalCenter
        text: project.property("sceneFrameWidth") + " m"
        color: "#507FE6"
        font.family: Fonts.robotoRegular.name
        font.pixelSize: 12
    }

    Component.onCompleted:
    {
        restorePreviousGeometry()
    }
}
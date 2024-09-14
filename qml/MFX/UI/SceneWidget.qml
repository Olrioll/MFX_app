import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI.Styles 1.0 as MFXUIS
import MFX.Enums 1.0 as MFXE

import "qrc:/"

Item
{
    id: sceneWidget
    clip: true

    property alias backgroundImage: backgroundImage
    property alias sceneFrameItem: sceneFrameItem
    property var patchIcons: []
    property real scaleFactor: project.property("sceneScaleFactor") === undefined ? 1.0 : project.property("sceneScaleFactor")
    property real maxScaleFactor: 3.0
    property real minScaleFactor: 0.2
    property int prevWidth
    property int dWidth
    property bool blockEditions: false //Блокирует изменение позиций устройств
    //signal hideSceneFrame

    function loadPatches()
    {
        for(var i = 0; i < sceneWidget.patchIcons.length; i++)
        {
            sceneWidget.patchIcons[i].destroy()
        }

        sceneWidget.patchIcons = []

        for(i = 0; i < project.patchCount(); i++)
        {
            var deviceType = project.patchType( project.patchPropertyForIndex( i, "ID" ) )
            console.log("deviceType:", deviceType)
            var imageFile
            if (deviceType == MFXE.PatternType.Sequences)
                imageFile = "qrc:/device_sequences"
            else if (deviceType == MFXE.PatternType.Pyro)
                imageFile = "qrc:/device_pyro"
            else if (deviceType == MFXE.PatternType.Shot)
                imageFile = "qrc:/device_shot"
            else if (deviceType == MFXE.PatternType.Dimmer)
                imageFile = "qrc:/device_dimmer"

            patchIcons.push(Qt.createComponent("PatchIcon.qml").createObject(backgroundImage,
                                                                             {  imageFile: imageFile,
                                                                                 patchId: project.patchPropertyForIndex(i, "ID"),
                                                                                 checked: project.patchPropertyForIndex(i, "checked"),
                                                                                 posXRatio: project.patchPropertyForIndex(i, "posXRatio"),
                                                                                 posYRatio: project.patchPropertyForIndex(i, "posYRatio")}))
            if(deviceType === MFXE.PatternType.Sequences)
            {
                deviceManager.setSequenceDeviceProperty(project.patchPropertyForIndex(i, "ID"), project.patchPropertyForIndex(i, "checked"),
                    project.patchPropertyForIndex(i, "posXRatio"), project.patchPropertyForIndex(i, "posYRatio"));
            }
        }
    }

    function zoom(step)
    {
        let newScaleFactror = sceneWidget.scaleFactor + sceneWidget.scaleFactor * step
        if(newScaleFactror <= maxScaleFactor && newScaleFactror >= minScaleFactor)
        {
            sceneWidget.scaleFactor = newScaleFactror
            project.setSceneScaleFactor(sceneWidget.scaleFactor)
        }
    }

    function centerBackgroundImage()
    {
        backgroundImage.x = (applicationWindow.width - backgroundImage.width) / 2
        backgroundImage.y = (applicationWindow.height - backgroundImage.height) / 2
    }

    function adjustBackgroundImageOnX()
    {
        if(backgroundImage.width <= sceneWidget.width)
        {
            backgroundImage.x = (sceneWidget.width - backgroundImage.width) / 2
        }

        else
        {
            backgroundImage.x += dWidth / 2
        }
    }

    function showPatchIcons(groupName, state)
    {
        for(let i = 0; i < patchIcons.length; i++)
        {
            if(project.isGroupContainsPatch(groupName, patchIcons[i].patchId))
            {
                patchIcons[i].visible = state
            }
        }
    }

    function refreshPatchIconsVisibility()
    {
        for(var i = 0; i < patchIcons.length; i++)
        {
            patchIcons[i].visible = false
        }

        let groupNames = project.groupNames()

        for(i = 0; i < groupNames.length; i ++)
        {
            if(project.isGroupVisible(groupNames[i]))
            {
                showPatchIcons(groupNames[i], true)
            }
        }

        for(i = 0; i < patchIcons.length; i++)
        {
            if(!project.isPatchHasGroup(patchIcons[i].patchId) && showAllButton.isNeedToBeChecked())
                patchIcons[i].visible = true
        }
    }

    function showFrame()
    {
        sceneFrameItem.visible = true
    }

    Rectangle
    {
        id: defaultBackgroundRect
        x: backgroundImage.x
        y: backgroundImage.y
        width: backgroundImage.width
        height: backgroundImage.height
        color: "transparent"

        border.width: 2
        border.color: "lightblue"
    }

    Image
    {
        id: backgroundImage
        width: sourceSize.width * sceneWidget.scaleFactor
        height: sourceSize.height * sceneWidget.scaleFactor
        source: project.property("backgroundImageFile") === "" || project.property("backgroundImageFile") === undefined ?
                    "" :
                    "file:///" + settingsManager.workDirectory() + "/" + project.property("backgroundImageFile")
    }

    MouseAreaWithHidingCursor
    {
        id: mainMouseArea
        anchors.fill: parent
        propagateComposedEvents: true
        preventStealing: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        hoverEnabled: true

        drag.target: null
        drag.axis: Drag.XandYAxis

        property int pressedX
        property int pressedY
        property int currentBackgroundImageX
        property int currentBackgroundImageY
        property real currentSceneFrameX
        property real currentSceneFrameY
        property bool isDraggingBackgroungImage: false
        property bool isDraggingIcon: false
        property bool isSelectingIcons: false

        property var draggingIconsList: []
        property var draggingIconsX: []
        property var draggingIconsY: []
        property bool wasDragging: false

        Rectangle
        {
            id: selectRect
            color: "transparent"
            border.width: 2
            border.color: "#2F4C8A"

            Rectangle
            {
                id: fillRect
                anchors.margins: selectRect.border.width
                anchors.fill: parent
                color: "#2F4C8A"
                opacity: 0.5
            }
        }


        onClicked:
        {
            for(let i = patchIcons.length - 1; i >= 0 ; i--)
            {
                let currCoord = patchIcons[i].mapToItem(sceneWidget, 0, 0);
                let currWidth = patchIcons[i].width
                let currHeight = patchIcons[i].height
                //console.log( "mouseX=" + mouseX + " mouseY=" + mouseY )
                //console.log( "currCoord.x=" + currCoord.x + " currCoord.y=" + currCoord.y )
                //console.log( "currWidth=" + currWidth + " currHeight=" + currHeight )
                if(mouseX > currCoord.x && mouseX < currCoord.x + currWidth)
                {
                    if(mouseY > currCoord.y && mouseY < currCoord.y + currHeight)
                    {
                        if(!wasDragging)
                            project.setPatchProperty(patchIcons[i].patchId, "checked", !project.patchProperty(patchIcons[i].patchId, "checked"))

                        wasDragging = false
                        break;
                    }
                }
            }
        }

        onPressed:
        {
            pressedX = mouseX
            pressedY = mouseY
            currentBackgroundImageX = backgroundImage.x
            currentBackgroundImageY = backgroundImage.y
            currentSceneFrameX = (sceneFrameItem.x - backgroundImage.x) / backgroundImage.width
            currentSceneFrameY = (sceneFrameItem.y - backgroundImage.y) / backgroundImage.height

            if(mouse.button & Qt.MiddleButton)
            {
                isDraggingBackgroungImage = true
                cursorShape = Qt.OpenHandCursor

            }

            else
            {
                if(!sceneWidget.blockEditions) {
                    for(let i = patchIcons.length - 1; i >= 0 ; i--)
                    {
                        let currCoord = patchIcons[i].mapToItem(sceneWidget, 0, 0);
                        let currWidth = patchIcons[i].width
                        let currHeight = patchIcons[i].height
                        if(mouseX > currCoord.x - 10 && mouseX < currCoord.x + currWidth + 10)
                        {
                            if(mouseY > currCoord.y -10 && mouseY < currCoord.y + currHeight + 10)
                            {
                                isDraggingIcon = true

                                draggingIconsList = []
                                draggingIconsX = []
                                draggingIconsY = []

                                draggingIconsList.push(patchIcons[i])
                                draggingIconsX.push(patchIcons[i].x)
                                draggingIconsY.push(patchIcons[i].y)

                                //--- Обрабатываем другие выделенные иконки
                                for(i = 0; i < patchIcons.length; i++)
                                {
                                    if(patchIcons[i] !== drag.target && patchIcons[i].checked)
                                    {
                                        draggingIconsList.push(patchIcons[i])
                                        draggingIconsX.push(patchIcons[i].x)
                                        draggingIconsY.push(patchIcons[i].y)
                                    }
                                }

                                break;
                            }
                        }
                    }
                }

                if(isDraggingIcon)
                {

                }

                else
                {
                    isSelectingIcons = true
                    selectRect.x = mouseX
                    selectRect.y = mouseY
                }
            }
        }

        onReleased:
        {
            if(isDraggingIcon)
            {
                for(let idx = 0; idx < draggingIconsList.length; idx++)
                {
                    let currRelPosition = draggingIconsList[idx].mapToItem(backgroundImage, 0, 0)
                    draggingIconsList[idx].posXRatio = currRelPosition.x / backgroundImage.width
                    draggingIconsList[idx].posYRatio = currRelPosition.y / backgroundImage.height

                    project.setPatchProperty(draggingIconsList[idx].patchId, "posXRatio", draggingIconsList[idx].posXRatio)
                    project.setPatchProperty(draggingIconsList[idx].patchId, "posYRatio", draggingIconsList[idx].posYRatio)
                }

                loadPatches();
            }

            else if(isSelectingIcons)
            {
                for(let j = 0; j < patchIcons.length; j++)
                {
                    project.setPatchProperty(patchIcons[j].patchId, "checked", false)
                }

                for(let i = 0; i < patchIcons.length; i++)
                {
                    let currCoord = patchIcons[i].mapToItem(sceneWidget, 0, 0);
                    let currWidth = patchIcons[i].width
                    let currHeight = patchIcons[i].height
                    if(currCoord.x > selectRect.x && currCoord.x < selectRect.x + selectRect.width)
                    {
                        if(currCoord.y > selectRect.y && currCoord.y < selectRect.y + selectRect.height)
                        {
                            project.setPatchProperty(patchIcons[i].patchId, "checked", true)
                        }
                    }
                }

                selectRect.width = 0
                selectRect.height = 0
            }

            isDraggingBackgroungImage = false
            isDraggingIcon = false
            isSelectingIcons = false
            drag.target = null
            cursorShape = Qt.ArrowCursor
            refreshPatchIconsVisibility();
        }

        onPositionChanged:
        {
            let dx = mouseX - pressedX
            let dy = mouseY - pressedY

            if(isDraggingBackgroungImage)
            {

                if(backgroundImage.width <= sceneWidget.width)
                {
                    backgroundImage.x = (sceneWidget.width - backgroundImage.width) / 2
                    sceneFrameItem.x = currentSceneFrameX * backgroundImage.width + backgroundImage.x
                }
                else
                {
                    if(dx < 0)
                    {
                        if(!((backgroundImage.x + backgroundImage.width) <= sceneWidget.width))
                        {
                            backgroundImage.x = currentBackgroundImageX + dx
                            sceneFrameItem.x = currentSceneFrameX * backgroundImage.width + backgroundImage.x
                        }
                    }

                    else if(dx > 0)
                    {
                        if(!(backgroundImage.x > 0))
                        {
                            backgroundImage.x = currentBackgroundImageX + dx
                            sceneFrameItem.x = currentSceneFrameX * backgroundImage.width + backgroundImage.x
                        }
                    }
                }

                if(backgroundImage.height <= sceneWidget.height)
                {
                    backgroundImage.y = (sceneWidget.height - backgroundImage.height) / 2
                    sceneFrameItem.y = currentSceneFrameY * backgroundImage.height + backgroundImage.y
                }

                else
                {
                    if(dy < 0)
                    {
                        if(!((backgroundImage.y + backgroundImage.height) <= sceneWidget.height))
                        {
                            backgroundImage.y = currentBackgroundImageY + dy
                            sceneFrameItem.y = currentSceneFrameY * backgroundImage.height + backgroundImage.y
                        }
                    }

                    else if(dy > 0)
                    {
                        if(!(backgroundImage.y > 0))
                        {
                            backgroundImage.y = currentBackgroundImageY + dy
                            sceneFrameItem.y = currentSceneFrameY * backgroundImage.height + backgroundImage.y
                        }
                    }
                }
            }

            else if(isSelectingIcons)
            {
                selectRect.width = Math.abs(dx)
                selectRect.height = Math.abs(dy)

                if(dx < 0)
                    selectRect.x = pressedX - selectRect.width
                if(dy < 0)
                    selectRect.y = pressedY - selectRect.height
            }

            else if(isDraggingIcon)
            {
                wasDragging = true

                for(var i = 0; i < draggingIconsList.length; i++)
                {
                    draggingIconsList[i].x = draggingIconsX[i] + dx
                    draggingIconsList[i].y = draggingIconsY[i] + dy
                }

                if((sceneWidget.width - mouseX) < 10)
                {
                    if(!((backgroundImage.x + backgroundImage.width) <= sceneWidget.width))
                    {
                        backgroundImage.x -= 15 * sceneWidget.scaleFactor
                        for(let i = 0; i < draggingIconsList.length; i++)
                        {
                            draggingIconsX[i] += 15 * sceneWidget.scaleFactor
                            draggingIconsList[i].x = draggingIconsX[i] + dx
                        }
                    }
                }

                else if(mouseX < 10)
                {
                    if(!(backgroundImage.x > 0))
                    {
                        backgroundImage.x += 15 * sceneWidget.scaleFactor
                        for(let i = 0; i < draggingIconsList.length; i++)
                        {
                            draggingIconsX[i] -= 15 * sceneWidget.scaleFactor
                            draggingIconsList[i].x = draggingIconsX[i] + dx
                        }
                    }
                }

                if((sceneWidget.height - mouseY) < 10)
                {
                    if(!((backgroundImage.y + backgroundImage.height) <= sceneWidget.height))
                    {
                        backgroundImage.y -= 15 * sceneWidget.scaleFactor
                        for(let i = 0; i < draggingIconsList.length; i++)
                        {
                            draggingIconsY[i] += 15 * sceneWidget.scaleFactor
                            draggingIconsList[i].y = draggingIconsX[i] + dy
                        }
                    }
                }

                else if(mouseY < 10)
                {
                    if(!(backgroundImage.y > 0))
                    {
                        backgroundImage.y += 15 * sceneWidget.scaleFactor
                        for(let i = 0; i < draggingIconsList.length; i++)
                        {
                            draggingIconsY[i] -= 15 * sceneWidget.scaleFactor
                            draggingIconsList[i].y = draggingIconsX[i] + dy
                        }
                    }
                }
            }
        }

        onWheel:
        {
            currentBackgroundImageX = backgroundImage.x
            currentBackgroundImageY = backgroundImage.y
            currentSceneFrameX = (sceneFrameItem.x - backgroundImage.x) / backgroundImage.width
            currentSceneFrameY = (sceneFrameItem.y - backgroundImage.y) / backgroundImage.height

            var step = wheel.angleDelta.y > 0 ? 0.05 : -0.05
            var prevWidth = backgroundImage.width
            var prevHeight = backgroundImage.height
            var newWidth = backgroundImage.sourceSize.width * (sceneWidget.scaleFactor + sceneWidget.scaleFactor * step)
            var newHeight = backgroundImage.sourceSize.height * (sceneWidget.scaleFactor + sceneWidget.scaleFactor * step)
            var currWidthChange = newWidth - prevWidth
            var currHeightChange = newHeight - prevHeight

            let newScaleFactror = sceneWidget.scaleFactor + sceneWidget.scaleFactor * step
            let scaleRatio = newScaleFactror / sceneWidget.scaleFactor
            if(newScaleFactror <= maxScaleFactor && newScaleFactror >= minScaleFactor)
            {
                sceneWidget.scaleFactor = newScaleFactror
                project.setSceneScaleFactor(sceneWidget.scaleFactor)

                if(backgroundImage.width <= sceneWidget.width)
                {
//                    backgroundImage.x = 0
                    backgroundImage.x = (sceneWidget.width - backgroundImage.width) / 2
                }

                else
                {
                    let dx = (mouseX - backgroundImage.x) / prevWidth * currWidthChange
                    backgroundImage.x -= dx
                }

                if(backgroundImage.height <= sceneWidget.height)
                {
//                    backgroundImage.y = 0
                    backgroundImage.y = (sceneWidget.height - backgroundImage.height) / 2
                }

                else
                {
                    let dy = (mouseY - backgroundImage.y) / prevHeight * currHeightChange
                    backgroundImage.y -= dy
                }

                sceneFrameItem.x = currentSceneFrameX * newWidth + backgroundImage.x
                sceneFrameItem.y = currentSceneFrameY * newHeight + backgroundImage.y
                sceneFrameItem.width = sceneFrameItem.width * scaleRatio
                sceneFrameItem.height = sceneFrameItem.height * scaleRatio
            }
        }
    }

    Item
    {
        id: sceneFrameItem
        visible: false

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
                font.family: MFXUIS.Fonts.robotoRegular.name
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
            font.family: MFXUIS.Fonts.robotoRegular.name
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
            font.family: MFXUIS.Fonts.robotoRegular.name
            font.pixelSize: 12
        }

        Component.onCompleted:
        {
            restorePreviousGeometry()
        }
    }

    Button
    {
        id: sceneSettingsButton

        x: 8
        y: 8
        width: 112
        height: 24

        visible: sceneWidget.parent === patchScreen

        background: Rectangle
        {
            color: "#333333"
            radius: 2
        }

        Image
        {
            x: 6
            y: 6

            source: "qrc:/sceneSettings"
        }

        contentItem: Text
        {
            color: "#ffffff"
            text: "Scene settings"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            leftPadding: 16
            font.family: MFXUIS.Fonts.robotoRegular.name
            font.pixelSize: 12
        }

        onClicked:
        {
            applicationWindow.projectSettingsWidget.isNewProject = false
            applicationWindow.projectSettingsWidget.visible = true

            patchScreen.deviceLibWidget.setActive(false)
            patchScreen.deviceListWidget.setActive(false)
            patchScreen.groupListWidget.setActive(false)
        }
    }

    Item
    {
        id: zoomControls
        width: 24
        height: 60

        anchors.leftMargin: 10
        anchors.left: parent.left

        anchors.bottomMargin: 58
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
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 16
            }

            onClicked:
            {
                let oldWidth = backgroundImage.width
                let oldHeight = backgroundImage.height
                sceneWidget.zoom(0.05)
                backgroundImage.x -= (backgroundImage.width - oldWidth) / 2
                backgroundImage.y -= (backgroundImage.height - oldHeight) / 2
            }
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
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 20
            }

            onClicked:
            {
                let oldWidth = backgroundImage.width
                let oldHeight = backgroundImage.height
                sceneWidget.zoom(-0.05)
                backgroundImage.x -= (backgroundImage.width - oldWidth) / 2
                backgroundImage.y -= (backgroundImage.height - oldHeight) / 2
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
                let minX = 9999
                let minY = 9999
                let maxX = 0
                let maxY = 0

                let hasVisibleIcons = false

                for(let i = 0; i < patchIcons.length; i++)
                {
                    let currIcon = patchIcons[i]
                    let currIconCoord = patchIcons[i].mapToGlobal(0, 0)
                    if(currIcon.visible)
                    {
                        hasVisibleIcons = true
                        if(currIconCoord.x < minX)
                            minX = currIconCoord.x
                        if(currIconCoord.y < minY)
                            minY = currIconCoord.y
                        if(currIconCoord.x > maxX)
                            maxX = currIconCoord.x
                        if(currIconCoord.y > maxY)
                            maxY = currIconCoord.y
                    }
                }

                if(hasVisibleIcons)
                {
                    maxX += patchIcons[0].width
                    maxY += patchIcons[0].height

                    let areaWidth = maxX - minX
                    let areaHeight = maxY - minY
                    let areaCenterX = minX + areaWidth / 2
                    let areaCenterY = minY + areaHeight / 2
                    let sceneWidgetCenterX = sceneWidget.mapToGlobal(0, 0).x + sceneWidget.width / 2
                    let sceneWidgetCenterY = sceneWidget.mapToGlobal(0, 0).y + sceneWidget.height / 2

                    let dScaleX = areaWidth / sceneWidget.width
                    let dScaleY = areaHeight / sceneWidget.height

                    let dScale = dScaleX > dScaleY ? dScaleX : dScaleY
                    dScale = dScale + 0.2 * dScale

                    backgroundImage.x += sceneWidgetCenterX - areaCenterX
                    backgroundImage.y += sceneWidgetCenterY - areaCenterY

                    var prevWidth = backgroundImage.width
                    var prevHeight = backgroundImage.height

                    var newScaleFactor = sceneWidget.scaleFactor

                    if(sceneWidget.scaleFactor / dScale > maxScaleFactor)
                        newScaleFactor = maxScaleFactor
                    else if (sceneWidget.scaleFactor / dScale < minScaleFactor)
                        newScaleFactor = minScaleFactor
                    else
                        newScaleFactor = sceneWidget.scaleFactor / dScale

                    var newWidth = backgroundImage.sourceSize.width * newScaleFactor
                    var newHeight = backgroundImage.sourceSize.height * newScaleFactor
                    var currWidthChange = newWidth - prevWidth
                    var currHeightChange = newHeight - prevHeight

                    sceneWidget.scaleFactor = newScaleFactor
                    project.setSceneScaleFactor(sceneWidget.scaleFactor)

                    let dx = (areaCenterX - backgroundImage.x) / prevWidth * currWidthChange
                    backgroundImage.x -= dx

                    let dy = (areaCenterY - backgroundImage.y) / prevHeight * currHeightChange
                    backgroundImage.y -= dy
                }


                ///--- Пока дублируем вышестоящий код, чтоб отцентрировалось точнее

                minX = 9999
                minY = 9999
                maxX = 0
                maxY = 0

                hasVisibleIcons = false

                for(let j = 0; j < patchIcons.length; j++)
                {
                    let currIcon = patchIcons[j]
                    let currIconCoord = patchIcons[j].mapToGlobal(0, 0)
                    if(currIcon.visible)
                    {
                        hasVisibleIcons = true
                        if(currIconCoord.x < minX)
                            minX = currIconCoord.x
                        if(currIconCoord.y < minY)
                            minY = currIconCoord.y
                        if(currIconCoord.x > maxX)
                            maxX = currIconCoord.x
                        if(currIconCoord.y > maxY)
                            maxY = currIconCoord.y
                    }
                }

                if(hasVisibleIcons)
                {
                    maxX += patchIcons[0].width
                    maxY += patchIcons[0].height

                    let areaWidth = maxX - minX
                    let areaHeight = maxY - minY
                    let areaCenterX = minX + areaWidth / 2
                    let areaCenterY = minY + areaHeight / 2
                    let sceneWidgetCenterX = sceneWidget.mapToGlobal(0, 0).x + sceneWidget.width / 2
                    let sceneWidgetCenterY = sceneWidget.mapToGlobal(0, 0).y + sceneWidget.height / 2

                    let dScaleX = areaWidth / sceneWidget.width
                    let dScaleY = areaHeight / sceneWidget.height

                    let dScale = dScaleX > dScaleY ? dScaleX : dScaleY
                    dScale = dScale + 0.2 * dScale

                    backgroundImage.x += sceneWidgetCenterX - areaCenterX
                    backgroundImage.y += sceneWidgetCenterY - areaCenterY

                    prevWidth = backgroundImage.width
                    prevHeight = backgroundImage.height

                    newScaleFactor = sceneWidget.scaleFactor

                    if(sceneWidget.scaleFactor / dScale > maxScaleFactor)
                        newScaleFactor = maxScaleFactor
                    else if (sceneWidget.scaleFactor / dScale < minScaleFactor)
                        newScaleFactor = minScaleFactor
                    else
                        newScaleFactor = sceneWidget.scaleFactor / dScale

                    newWidth = backgroundImage.sourceSize.width * newScaleFactor
                    newHeight = backgroundImage.sourceSize.height * newScaleFactor
                    currWidthChange = newWidth - prevWidth
                    currHeightChange = newHeight - prevHeight

                    sceneWidget.scaleFactor = newScaleFactor
                    project.setSceneScaleFactor(sceneWidget.scaleFactor)
                    let dx = (areaCenterX - backgroundImage.x) / prevWidth * currWidthChange
                    backgroundImage.x -= dx

                    let dy = (areaCenterY - backgroundImage.y) / prevHeight * currHeightChange
                    backgroundImage.y -= dy
                }

                ///--- И еще раз дублируем

                minX = 9999
                minY = 9999
                maxX = 0
                maxY = 0

                hasVisibleIcons = false

                for(let z = 0; z < patchIcons.length; z++)
                {
                    let currIcon = patchIcons[z]
                    let currIconCoord = patchIcons[z].mapToGlobal(0, 0)
                    if(currIcon.visible)
                    {
                        hasVisibleIcons = true
                        if(currIconCoord.x < minX)
                            minX = currIconCoord.x
                        if(currIconCoord.y < minY)
                            minY = currIconCoord.y
                        if(currIconCoord.x > maxX)
                            maxX = currIconCoord.x
                        if(currIconCoord.y > maxY)
                            maxY = currIconCoord.y
                    }
                }

                if(hasVisibleIcons)
                {
                    maxX += patchIcons[0].width
                    maxY += patchIcons[0].height

                    let areaWidth = maxX - minX
                    let areaHeight = maxY - minY
                    let areaCenterX = minX + areaWidth / 2
                    let areaCenterY = minY + areaHeight / 2
                    let sceneWidgetCenterX = sceneWidget.mapToGlobal(0, 0).x + sceneWidget.width / 2
                    let sceneWidgetCenterY = sceneWidget.mapToGlobal(0, 0).y + sceneWidget.height / 2

                    let dScaleX = areaWidth / sceneWidget.width
                    let dScaleY = areaHeight / sceneWidget.height

                    let dScale = dScaleX > dScaleY ? dScaleX : dScaleY
                    dScale = dScale + 0.2 * dScale

                    backgroundImage.x += sceneWidgetCenterX - areaCenterX
                    backgroundImage.y += sceneWidgetCenterY - areaCenterY

                    prevWidth = backgroundImage.width
                    prevHeight = backgroundImage.height

                    newScaleFactor = sceneWidget.scaleFactor

                    if(sceneWidget.scaleFactor / dScale > maxScaleFactor)
                        newScaleFactor = maxScaleFactor
                    else if (sceneWidget.scaleFactor / dScale < minScaleFactor)
                        newScaleFactor = minScaleFactor
                    else
                        newScaleFactor = sceneWidget.scaleFactor / dScale

                    newWidth = backgroundImage.sourceSize.width * newScaleFactor
                    newHeight = backgroundImage.sourceSize.height * newScaleFactor
                    currWidthChange = newWidth - prevWidth
                    currHeightChange = newHeight - prevHeight

                    sceneWidget.scaleFactor = newScaleFactor
                    project.setSceneScaleFactor(sceneWidget.scaleFactor)
                    let dx = (areaCenterX - backgroundImage.x) / prevWidth * currWidthChange
                    backgroundImage.x -= dx

                    let dy = (areaCenterY - backgroundImage.y) / prevHeight * currHeightChange
                    backgroundImage.y -= dy
                }
            }
        }
    }

    MfxButton
    {
        id: showAllButton
        width: 48
//        checkable: true
        color: isNeedToBeChecked() ? "#444444" : "#222222"
        text: translationsManager.translationTrigger + qsTr("All")
        anchors.leftMargin: 12
        anchors.bottomMargin: 18
        anchors
        {
            left: zoomControls.right
            bottom: sceneWidget.bottom
        }

        function isNeedToBeChecked()
        {
            for(let i = 0; i < switchGroupsButtons.count; i++)
            {
                if(switchGroupsButtons.itemAtIndex(i) && !switchGroupsButtons.itemAtIndex(i).checked)
                    return false
            }
            return true
        }

        onClicked:
        {
            if(isNeedToBeChecked())
            {
                for(let i = 0; i < switchGroupsButtons.count; i++)
                {
                    switchGroupsButtons.itemAtIndex(i).checked = false
                }
            }

            else
            {
                for(let i = 0; i < switchGroupsButtons.count; i++)
                {
                    switchGroupsButtons.itemAtIndex(i).checked = true
                }
            }
        }
    }

    Rectangle
    {
        id: backgroundRect
        x: switchGroupsButtons.x
        y: switchGroupsButtons.y
        color: "#222222"
        height: 24
        width: switchGroupsButtons.contentItem.width
        radius: 2
        border.width: 2
        border.color: "#333333"
    }

    ListView
    {
        id: switchGroupsButtons
        orientation: ListView.Horizontal
        width: contentItem.width
        spacing: 2

        anchors.rightMargin: 4
        anchors.leftMargin: 2
        anchors.bottomMargin: 24
        anchors
        {
            left: showAllButton.right
            right: parent.right
            bottom: showAllButton.bottom
        }

        ScrollBar.horizontal: ScrollBar {}

        function refreshList()
        {
            buttonListModel.clear()
            let groupNames = project.groupNames()
            for (let i = 0; i < groupNames.length; i++)
            {
                buttonListModel.append({delegateChecked: project.isGroupVisible(groupNames[i]), delegateWidth: 70, delegateText: groupNames[i]})
            }
        }

        delegate: MfxButton
        {
            checkable: true
            checked: delegateChecked
            width: delegateWidth
            text: delegateText

            onCheckedChanged:
            {
                project.setGroupVisible(text, checked)
                sceneWidget.refreshPatchIconsVisibility()

                // Показываем иконки патчей не имеющие группы
                if(showAllButton.isNeedToBeChecked())
                {
                    for(var i = 0; i < patchIcons.length; i++)
                    {
                        if(!project.isPatchHasGroup(patchIcons[i].patchId))
                            patchIcons[i].visible = true
                    }
                }
            }
        }

        model: ListModel
        {
            id: buttonListModel
        }

        Component.onCompleted: refreshList()
    }

    Connections
    {
        target: project
        function onPatchListChanged()
        {
            sceneWidget.loadPatches()
        }
    }

    Connections
    {
        target: project
        function onGroupChanged()
        {
            sceneWidget.refreshPatchIconsVisibility()
        }
    }

    Connections
    {
        target: project
        function onGroupCountChanged()
        {
            switchGroupsButtons.refreshList()
        }
    }

    Connections
    {
        target: project
        function onBackgroundImageChanged()
        {
            if( project.property("backgroundImageFile") !== "" )
                backgroundImage.source = "file:///" + settingsManager.workDirectory() + "/" + project.property("backgroundImageFile")
            else
                backgroundImage.source = ""

            centerBackgroundImage()
        }
    }

    onWidthChanged:
    {
        dWidth = width - prevWidth
        prevWidth = width
    }

    Component.onCompleted:
    {
        loadPatches()

        if(backgroundImage.width <= sceneWidget.width)
        {
            backgroundImage.x = (sceneWidget.width - backgroundImage.width) / 2
        }

        if(backgroundImage.height <= sceneWidget.height)
        {
            backgroundImage.y = (sceneWidget.height - backgroundImage.height) / 2
        }

        prevWidth = width
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import WaveformWidget 1.0
import "qrc:/"

Item
{
    id: playerWidget
    clip: true

    property int minHeight: 200
    property int maxHeight: 600
    property int previousY

    Rectangle
    {
        id: mainBackground
        anchors.fill: parent
        color: "#444444"
        radius: 2
    }

    Rectangle
    {
        id: timeScaleBackground
        height: 8
        anchors.topMargin: waveformBackground.anchors.topMargin - height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#222222"
    }

    MouseAreaWithHidingCursor
    {
        id: playerResizeArea
        height: 4

        anchors.topMargin: -2
        anchors
        {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        cursorShape: Qt.SizeVerCursor

        onPressed:
        {
            playerWidget.previousY = mouseY
        }

        onMouseYChanged:
        {
            var dy= mouseY - playerWidget.previousY

            if((playerWidget.height - dy) < playerWidget.minHeight)
                playerWidget.height = playerWidget.minHeight

            else if ((playerWidget.height - dy) <= mainScreen.height - 100)
                playerWidget.height = playerWidget.height - dy
        }
    }

    Rectangle
    {
        id: waveformBackground
        anchors.topMargin: 24
        anchors.bottomMargin: 24
        anchors.fill: parent
        color: "#000000"
        radius: 2
    }

    WaveformWidget
    {
        id: waveformWidget
        anchors.topMargin: 24
        anchors.bottomMargin: 24
        anchors.fill: parent

        Connections
        {
            target: project
            function onAudioTrackFileChanged()
            {
                playButton.checked = false
                waveformWidget.setAudioTrackFile(settingsManager.workDirectory() + "/" + project.property("audioTrackFile"))
            }
        }

        Component.onCompleted:
        {
            if(project.property("audioTrackFile") !== "")
            {
                setAudioTrackFile(settingsManager.workDirectory() + "/" + project.property("audioTrackFile"))
            }
        }
    }

    Rectangle
    {
        id: leftShadingRect
        anchors.top: waveformWidget.top
        anchors.bottom: waveformWidget.bottom
        anchors.left: waveformWidget.left
        anchors.right: startPositionMarker.left
        color: "black"
        opacity: 0.5
    }

    Rectangle
    {
        id: rightShadingRect
        anchors.top: waveformWidget.top
        anchors.bottom: waveformWidget.bottom
        anchors.right: waveformWidget.right
        anchors.left: stopPositionMarker.right
        color: "black"
        opacity: 0.5
    }

    Flickable
    {
        id: cueViewFlickable
        anchors.fill: waveformWidget
        contentHeight: cueView.height
        clip: true


        ScrollBar.vertical: ScrollBar
        {
            id: cueViewScrollBar
            policy: cueView.height > waveformWidget.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff

            contentItem:
                Rectangle
                {
                    implicitWidth: 10
                    radius: 2
                    color: "#c4c4c4"
                    opacity: parent.pressed ? 0.25 : 0.5
                }
        }

        Item
        {
            id: cueView
            width: waveformWidget.width
            property var cues: []

            function msecToPixels(value)
            {
                return cueView.width * (value - waveformWidget.min()) / (waveformWidget.max() - waveformWidget.min())
            }

            function setActiveCue(name)
            {
                for(let i = 0; i < cues.length; i++)
                {
                    let currCue = cues[i]
                    if(currCue.name === name)
                        currCue.isExpanded = true
                    else
                        currCue.isExpanded = false
                }

                refresh()
            }

            function refresh()
            {
                // определяем кол-во строк
                let maxRow = -1
                for(var i = 0; i < cues.length; i++)
                {
                    if(cues[i].row > maxRow)
                        maxRow = cues[i].row
                }

                let prevRowsHeight = 0
                let currHeight = 10
                for(var j = 0; j < maxRow + 1; j++)
                {
                    for(i = 0; i < cues.length; i++)
                    {
                        let currCue = cues[i]
                        if(currCue.row === j)
                        {
                            if(currCue.isExpanded)
                            {
                                currHeight = currCue.expandedHeight
                            }

                            currCue.y = prevRowsHeight + 2
                            currCue.x = cueView.msecToPixels(currCue.position)
                            currCue.width = cueView.msecToPixels(currCue.position + currCue.duration) - currCue.x
                        }
                    }

                    prevRowsHeight += currHeight + 2
                    currHeight = 10
                }

                cueView.height = prevRowsHeight
            }

            MouseAreaWithHidingCursor
            {
                id: mouseArea
                anchors.fill: parent
                propagateComposedEvents: false

                property int pressedX
                property int pressedY
                property var pressedCuePlate: null
                property bool isDraggingCuePlate

                property var draggingPlatesList: []
                property var draggingPlatesX: []
                property var draggingPlatesY: []

                onPressed:
                {
                    cueViewFlickable.interactive = false
                    pressedX = mouseX
                    pressedY = mouseY
                    pressedCuePlate = null

                    for(var i = 0; i < cueView.cues.length; i++)
                    {
                        let currCoord = cueView.cues[i].mapToItem(cueView, 0, 0);
                        let currWidth = cueView.cues[i].width
                        let currHeight = cueView.cues[i].height

                        if(mouseX > currCoord.x && mouseX < currCoord.x + currWidth)
                        {
                            if(mouseY > currCoord.y && mouseY < currCoord.y + currHeight)
                            {
                                pressedCuePlate = cueView.cues[i]

                                draggingPlatesList = []
                                draggingPlatesX = []
                                draggingPlatesY = []
                                draggingPlatesList.push(cueView.cues[i])
                                draggingPlatesX.push(cueView.cues[i].x)
                                draggingPlatesY.push(cueView.cues[i].y)

                                for(let j = 0; j < cueView.cues.length; j++)
                                {
                                    if(cueView.cues[j].checked && cueView.cues[j] !== pressedCuePlate)
                                    {
                                        draggingPlatesList.push(cueView.cues[j])
                                        draggingPlatesX.push(cueView.cues[j].x)
                                        draggingPlatesY.push(cueView.cues[j].y)
                                    }
                                }

                                break
                            }
                        }
                    }

                    if(!pressedCuePlate)
                    {
                        cueView.setActiveCue("")
                        for(let i = 0; i < cueView.cues.length; i++)
                        {
                            cueView.cues[i].checked = false
                        }
                    }
                }

                onReleased:
                {
                    if(isDraggingCuePlate)
                    {

                    }

                    else
                    {
                        if(pressedCuePlate)
                            pressedCuePlate.checked = !pressedCuePlate.checked
                    }

                    pressedCuePlate = null
                    isDraggingCuePlate = false
                    draggingPlatesList = []
                    cueViewFlickable.interactive = true
                }

                onDoubleClicked:
                {
                    if(pressedCuePlate)
                        cueView.setActiveCue(pressedCuePlate.name)
                }

                onPositionChanged:
                {
                    let dx = mouseX - pressedX
                    let dy = mouseY - pressedY

                    if(pressedCuePlate)
                    {
                        isDraggingCuePlate = true

                        for(var i = 0; i < draggingPlatesList.length; i++)
                        {
                            draggingPlatesList[i].x = draggingPlatesX[i] + dx
                            draggingPlatesList[i].y = draggingPlatesY[i] + dy
                        }
                    }
                }
            }

            Component
            {
                id: cuePlate
                Item
                {
                    height: isExpanded ? expandedHeight : collapsedHeight

                    property string name: ""
                    property bool isExpanded: false
                    property bool checked: false
                    property int collapsedHeight: 10
                    property int expandedHeight: 36
                    property int row
                    property int position // в мсек
                    property int duration  // в мсек

                    Rectangle
                    {
                        id: frame
                        anchors.fill: parent

                        radius: 4
                        color: "#7F27AE60"
                        border.width: 2
                        border.color: parent.checked ? "#2F80ED" : "#27AE60"

                    }
                }
            }

            Component.onCompleted:
            {
                cues.push(cuePlate.createObject(cueView, {name: "cue1", row: 0, position: 1000, duration: 10000}))
                cues.push(cuePlate.createObject(cueView, {name: "cue2",  row: 1, position: 2000, duration: 10000}))
                cues.push(cuePlate.createObject(cueView, {name: "cue3", row: 8, position: 10000, duration: 8000}))
                cues.push(cuePlate.createObject(cueView, {name: "cue4", row: 15, position: 12000, duration: 18000}))
            }

            Connections
            {
                target: waveformWidget
                function onMaxChanged()
                {
                    cueView.refresh()
                }
            }

            Connections
            {
                target: waveformWidget
                function onMinChanged()
                {
                    cueView.refresh()
                }
            }

            Connections
            {
                target: cueView
                function onWidthChanged()
                {
                    cueView.refresh()
                }
            }

            Connections
            {
                target: cueView
                function onHeightChanged()
                {
                    cueView.refresh()
                }
            }
        }
    }

    Item
    {
        id: timeScale
        anchors.fill: timeScaleBackground

        property alias timeScaleMouseArea: timeScaleMouseArea
        property var textMarkers: []

        Component
        {
            id: textMarker
            Text
            {
                id: posTimeText
                color: "#eeeeee"
                padding: 0
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: "Roboto"
                font.pixelSize: 8
            }
        }

        Canvas
        {
            id: timeScaleCanvas
            anchors.fill: parent

            onPaint:
            {
                // Вычисляем кол-во миллисекунд на пиксель

                let max = waveformWidget.max()
                let min = waveformWidget.min()
                let msecPerPx = (max - min) / waveformWidget.width

                for (let txt of timeScale.textMarkers)
                {
                  txt.destroy()
                }
                timeScale.textMarkers = []
                var ctx = getContext("2d")
                ctx.reset()

                var stepMsec = 0 // шаг делений в мсек

 // малое деление будет равно 1 сек
                if(msecPerPx >= 50)
                {
                    stepMsec = 1000
                }

// малое деление будет равно 0.5 сек
                else if(msecPerPx >= 25)
                {
                    stepMsec = 500
                }

// малое деление будет равно 0.1 сек
                else if (msecPerPx >= 3)
                {
                    stepMsec = 100
                }

// малое деление будет равно 0.01 сек
                else
                {
                    stepMsec = 10
                }

                // стартовая позиция в мсек
                var startMsec = Math.ceil(min / stepMsec) * stepMsec

                // стартовая позиция в пикселях
                var start = (startMsec - min) / msecPerPx

                // шаг делений в пикселях
                var step = stepMsec / msecPerPx

                ctx.miterLimit = 0.1
                ctx.strokeStyle = "#888888"

                var currPos = start;
                var currPosMsec = startMsec
                while(currPos + step < width)
                {
                    let divisionHeight = 2

                    if(!(currPosMsec % (10 * stepMsec)))
                        divisionHeight = 6

                    else if(!(currPosMsec % (5 * stepMsec)))
                        divisionHeight = 4

                    ctx.moveTo(currPos, height)
                    ctx.lineTo(currPos, height - divisionHeight)
                    currPos += step
                    currPosMsec += stepMsec

                    if(divisionHeight === 6) // создаем текстовый маркер
                    {
                        let marker = textMarker.createObject(mainBackground)
                        timeScale.textMarkers.push(marker)

                        if(msecPerPx >= 3)
                        {
                            marker.text = waveformWidget.positionString(currPosMsec - stepMsec, "mm:ss")
                        }

                        else
                        {
                            let timeString = waveformWidget.positionString(currPosMsec - stepMsec, "mm:ss.zzz")
                            marker.text = timeString.slice(0, timeString.length - 2)
                        }
                        marker.y = 2
                        marker.x = currPos - step - marker.width / 2
                    }
                }

                ctx.stroke()
            }
        }


        Connections
        {
            target: waveformWidget
            function onMaxChanged()
            {
                timeScaleCanvas.requestPaint()
            }
        }

        Connections
        {
            target: waveformWidget
            function onMinChanged()
            {
                timeScaleCanvas.requestPaint()
            }
        }

        ZoomingMouseArea
        {
            id: timeScaleMouseArea
            height: 22
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            hoverEnabled: true
            image: cursorMovingArea.containsMouse || startPositionMarkerMovingArea.containsMouse || stopPositionMarkerMovingArea.containsMouse ?
                       "" : "qrc:/zoom"

            property alias resizingCenterMarker: resizingCenterMarker

            function zoom(delta)
            {
                let scaleFactor = 0.05
                if(Math.abs(delta) < 5)
                    scaleFactor = 0.08
                else if(Math.abs(delta) < 9)
                    scaleFactor = 0.1
                else if(Math.abs(delta) < 14)
                    scaleFactor = 0.15
                else
                    scaleFactor = 0.20

                let currInterval = waveformWidget.maxSample() - waveformWidget.minSample()
                let dWidth = currInterval * scaleFactor
                let zoomCenter = resizingCenterMarker.x / width
                let leftShift = zoomCenter * dWidth
                let rightShift = dWidth - leftShift

                if(delta > 0)
                {
                    if((waveformWidget.maxSample() - waveformWidget.minSample()) / waveformWidget.width > 4) // максимальный масштаб - 4 сэмпла на пиксель
                    {
                        waveformWidget.setMinSample(waveformWidget.minSample() + Math.round(leftShift))
                        waveformWidget.setMaxSample(waveformWidget.maxSample() - Math.round(rightShift))
                    }
                }

                else
                {
                    if((waveformWidget.minSample() - leftShift) >= 0 && (waveformWidget.maxSample() + rightShift) < waveformWidget.sampleCount())
                    {
                        waveformWidget.setMinSample(waveformWidget.minSample() - leftShift)
                        waveformWidget.setMaxSample(waveformWidget.maxSample() + rightShift)
                    }

                    else
                    {
                        let leftDist = waveformWidget.minSample()
                        let rightDist = waveformWidget.sampleCount() - 1 - waveformWidget.maxSample()

                        if(leftDist < rightDist)
                        {
                            dWidth -= waveformWidget.minSample()
                            waveformWidget.setMinSample(0)

                            if((waveformWidget.maxSample() + dWidth) < waveformWidget.sampleCount())
                            {
                                waveformWidget.setMaxSample(waveformWidget.maxSample() + dWidth)
                            }

                            else
                                waveformWidget.setMaxSample(waveformWidget.sampleCount() - 1)
                        }

                        else
                        {
                            dWidth -= waveformWidget.sampleCount() - 1 - waveformWidget.maxSample()
                            waveformWidget.setMaxSample(waveformWidget.sampleCount() - 1)

                            if((waveformWidget.minSample() - dWidth) >= 0)
                            {
                                waveformWidget.setMinSample(waveformWidget.minSample() - dWidth)
                            }

                            else
                                waveformWidget.setMinSample(0)
                        }
                    }
                }
            }

            Rectangle
            {
                id: resizingCenterMarker
                color: "#27AE60"
                width: 1
                anchors.top: parent.bottom
                height: waveformWidget.height
                visible: false
            }

            onPressed:
            {
                playerResizeArea.enabled = false
                playerResizeArea.cursorShape = Qt.BlankCursor
                mainScreen.sceneWidget.enabled = false
                timeScaleMouseArea.cursorImage.visible = false
                resizingCenterMarker.x = mouseX
                resizingCenterMarker.visible = true
            }

            onMoved:
            {
                if(Math.abs(dx) > Math.abs(dy)) // Скроллим
                {
                    let coeff = 1
                    if(Math.abs(dx) < 3)
                        coeff = 1
                    else if (Math.abs(dx) < 7)
                        coeff = 2
                    else if (Math.abs(dx) < 16)
                        coeff = 3
                    else
                        coeff = 4

                    let currInterval = waveformWidget.maxSample() - waveformWidget.minSample()
                    let dX = currInterval / width * Math.abs(dx) * coeff

                    if(dx < 0)
                    {
                        if(waveformWidget.maxSample() + dX < waveformWidget.sampleCount())
                        {
                            waveformWidget.setMaxSample(waveformWidget.maxSample() + dX)
                            waveformWidget.setMinSample(waveformWidget.minSample() + dX)

                            if(resizingCenterMarker.x - Math.abs(dx) * coeff > 0)
                            {
                                resizingCenterMarker.x -= Math.abs(dx) * coeff
                            }

                            else
                            {
                                resizingCenterMarker.x = 1
                            }
                        }
                    }

                    else
                    {
                        if(waveformWidget.minSample() - dX >= 0)
                        {
                            waveformWidget.setMaxSample(waveformWidget.maxSample() - dX)
                            waveformWidget.setMinSample(waveformWidget.minSample() - dX)

                            if(resizingCenterMarker.x + Math.abs(dx) * coeff < width - 9)
                            {
                                resizingCenterMarker.x += Math.abs(dx) * coeff
                            }

                            else
                            {
                                resizingCenterMarker.x = width - 12
                            }
                        }
                    }
                }

                else // Работаем с зумом
                {
                    zoom(dy)
                }
            }

            onWheel:
            {
                resizingCenterMarker.x = mouseX
                zoom(wheel.angleDelta.y > 0 ? 2 : -2)
            }

            onReleased:
            {
                playerResizeArea.enabled = true
                playerResizeArea.cursorShape = Qt.SizeVerCursor
                mainScreen.sceneWidget.enabled = true
                resizingCenterMarker.visible = false
                timeScaleMouseArea.cursorImage.visible = true
            }
        }
    }

    Rectangle
    {
        id: leftChannelMarker
        width: 10
        height: 10
        radius: 2
        color: "#444444"
        x: waveformBackground.x + 4
        y: waveformBackground.y + 4
        visible: stereoModeButton.checked

        Text
        {
            text: "L"
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            anchors.centerIn: parent
            font.family: "Roboto"
            font.pixelSize: 8
        }
    }

    Rectangle
    {
        id: rightChannelMarker
        width: 10
        height: 10
        radius: 2
        color: "#444444"
        x: waveformBackground.x + 4
        y: waveformBackground.y + waveformBackground.height / 2 + 4
        visible: stereoModeButton.checked

        Text
        {
            text: "R"
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            anchors.centerIn: parent
            font.family: "Roboto"
            font.pixelSize: 8
        }
    }

    Rectangle
    {
        id: cnannelsSeparetor
        width: waveformBackground.width
        height: 2
        y: waveformBackground.y + waveformBackground.height / 2
        color: "#444444"
        visible: stereoModeButton.checked
    }

    Item
    {
        id: startPositionMarker
        width: 2
        height: mainBackground.height + 12
        anchors.top: mainBackground.top

        property int position: 0

        function updatePosition()
        {
            startPositionMarker.x = waveformBackground.width * (position - waveformWidget.min()) / (waveformWidget.max() - waveformWidget.min())
        }

        Canvas
        {
            width: 12
            height: parent.height
            x: -1
            y: 12

            onPaint:
            {
                var ctx = getContext("2d")
                ctx.miterLimit = 0.1
                ctx.fillStyle = "#ffffff"
                ctx.lineTo(0, 12)
                ctx.lineTo(width / 2, 6)
                ctx.lineTo(0, 0)
                ctx.closePath()
                ctx.fill()
            }

            MouseAreaWithHidingCursor
            {
                id: startPositionMarkerMovingArea
                anchors.topMargin: -4
                anchors.top: parent.top
                anchors.leftMargin: -6
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12
                hoverEnabled: true
                cursor: Qt.SizeHorCursor

                drag.target: startPositionMarker
                drag.axis: Drag.XAxis

                drag.minimumX: 0
                drag.maximumX: stopPositionMarker.x - 12

                onMouseXChanged:
                {
                    let max = waveformWidget.max()
                    let min = waveformWidget.min()
                    let msecPerPx = (max - min) / waveformWidget.width
                    startPositionMarker.position = min + startPositionMarker.x * msecPerPx
                    project.setProperty("startPosition", startPositionMarker.position)
                }
            }
        }

        Rectangle
        {
            width: 1
            height: waveformBackground.height
            color: "#ffffff"
            x: -1
            y: 24
        }

        Connections
        {
            target: waveformWidget
            function onMaxChanged()
            {
                startPositionMarker.updatePosition()
            }
        }

        Connections
        {
            target: waveformWidget
            function onMinChanged()
            {
                startPositionMarker.updatePosition()
            }
        }
    }

    Item
    {
        id: stopPositionMarker
        width: 2
        height: mainBackground.height + 12
        anchors.top: mainBackground.top

        property int position: 0

        function updatePosition()
        {
            stopPositionMarker.x = waveformBackground.width * (position - waveformWidget.min()) / (waveformWidget.max() - waveformWidget.min())
        }

        Canvas
        {
            width: 12
            height: parent.height
            x: -6
            y: 12

            onPaint:
            {
                var ctx = getContext("2d")
                ctx.miterLimit = 0.1
                ctx.fillStyle = "#ffffff"
                ctx.moveTo(0, 6)
                ctx.lineTo(width / 2, 12)
                ctx.lineTo(width / 2, 0)
                ctx.lineTo(0, 6)
                ctx.closePath()
                ctx.fill()
            }

            MouseAreaWithHidingCursor
            {
                id: stopPositionMarkerMovingArea
                anchors.topMargin: -4
                anchors.top: parent.top
                anchors.leftMargin: -4
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12
                hoverEnabled: true
                cursor: Qt.SizeHorCursor

                drag.target: stopPositionMarker
                drag.axis: Drag.XAxis

                drag.minimumX: startPositionMarker.x + 12
                drag.maximumX: mainBackground.width - stopPositionMarker.width

                onMouseXChanged:
                {
                    let max = waveformWidget.max()
                    let min = waveformWidget.min()
                    let msecPerPx = (max - min) / waveformWidget.width
                    stopPositionMarker.position = min + stopPositionMarker.x * msecPerPx
                    project.setProperty("stopPosition", stopPositionMarker.position)
                }
            }
        }

        Rectangle
        {
            width: 1
            height: waveformBackground.height
            color: "#ffffff"
            x: -1
            y: 24
        }

        Connections
        {
            target: waveformWidget
            function onMaxChanged()
            {
                stopPositionMarker.updatePosition()
            }
        }

        Connections
        {
            target: waveformWidget
            function onMinChanged()
            {
                stopPositionMarker.updatePosition()
            }
        }
    }

    Item
    {
        id: startLoopMarker
        width: 2
        height: mainBackground.height + 12
        anchors.top: mainBackground.top

        property real position: 0

        function updatePosition()
        {
            startLoopMarker.x = waveformBackground.width * (position - waveformWidget.min()) / (waveformWidget.max() - waveformWidget.min())
        }

        Canvas
        {
            id: startLoopMarkerCanvas
            width: 12
            height: parent.height
            x: -1

            onPaint:
            {
                var ctx = getContext("2d")
                ctx.miterLimit = 0.1
                ctx.strokeStyle = repeatButton.checked ? "#F2994A" : "#999999"
                ctx.lineWidth = 2
                ctx.moveTo(1, 1)
                ctx.lineTo(6, 1)
                ctx.moveTo(1, 1)
                ctx.lineTo(1, 12)
                ctx.lineTo(6, 12)
                ctx.stroke()
            }

            Connections
            {
                target: repeatButton
                function onCheckedChanged()
                {
                    startLoopMarkerCanvas.requestPaint()
                }
            }

            MouseAreaWithHidingCursor
            {
                id: startLoopMarkerMovingArea
                anchors.topMargin: -4
                anchors.top: parent.top
                anchors.leftMargin: -4
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12
                hoverEnabled: true
                cursor: Qt.SizeHorCursor

                drag.target: startLoopMarker
                drag.axis: Drag.XAxis

                drag.minimumX: startPositionMarker.x
                drag.maximumX: stopLoopMarker.x - 12

                onEntered:
                {
                    cursorShape = Qt.SizeHorCursor
                }

                onExited:
                {
                    cursorShape = Qt.ArrowCursor
                }

                onMouseXChanged:
                {
                    let max = waveformWidget.max()
                    let min = waveformWidget.min()
                    let msecPerPx = (max - min) / waveformWidget.width
                    startLoopMarker.position = min + startLoopMarker.x * msecPerPx
                    project.setProperty("startLoop", startLoopMarker.position)
                }
            }
        }

        Rectangle
        {
            width: 1
            height: waveformBackground.height + 12
            color: "#F2994A"
            visible: repeatButton.checked
            x: -1
            y: 12
        }

        Connections
        {
            target: waveformWidget
            function onMaxChanged()
            {
                startLoopMarker.updatePosition()
            }
        }

        Connections
        {
            target: waveformWidget
            function onMinChanged()
            {
                startLoopMarker.updatePosition()
            }
        }
    }

    Item
    {
        id: stopLoopMarker
        width: 2
        height: mainBackground.height + 12
        anchors.top: mainBackground.top

        property real position: 0

        function updatePosition()
        {
            stopLoopMarker.x = waveformBackground.width * (position - waveformWidget.min()) / (waveformWidget.max() - waveformWidget.min())
        }

        Canvas
        {
            id: stopLoopMarkerCanvas
            width: 12
            height: parent.height
            x: -7
            y: 0

            onPaint:
            {
                var ctx = getContext("2d")
                ctx.miterLimit = 0.1
                ctx.strokeStyle = repeatButton.checked ? "#F2994A" : "#999999"
                ctx.lineWidth = 2
                ctx.moveTo(1, 1)
                ctx.lineTo(6, 1)
                ctx.lineTo(6, 12)
                ctx.lineTo(1, 12)
                ctx.stroke()
            }

            Connections
            {
                target: repeatButton
                function onCheckedChanged()
                {
                    stopLoopMarkerCanvas.requestPaint()
                }
            }

            MouseAreaWithHidingCursor
            {
                id: stopLoopMarkerMovingArea
                anchors.topMargin: -4
                anchors.top: parent.top
                anchors.leftMargin: -4
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12
                hoverEnabled: true
                cursor: Qt.SizeHorCursor

                drag.target: stopLoopMarker
                drag.axis: Drag.XAxis

                drag.minimumX: startLoopMarker.x + 12
                drag.maximumX: stopPositionMarker.x

                onMouseXChanged:
                {
                    let max = waveformWidget.max()
                    let min = waveformWidget.min()
                    let msecPerPx = (max - min) / waveformWidget.width
                    stopLoopMarker.position = min + stopLoopMarker.x * msecPerPx
                    project.setProperty("stopLoop", stopLoopMarker.position)
                }
            }
        }

        Rectangle
        {
            width: 1
            height: waveformBackground.height + 12
            color: "#F2994A"
            visible: repeatButton.checked
            x: -1
            y: 12
        }

        Connections
        {
            target: waveformWidget
            function onMaxChanged()
            {
                stopLoopMarker.updatePosition()
            }
        }

        Connections
        {
            target: waveformWidget
            function onMinChanged()
            {
                stopLoopMarker.updatePosition()
            }
        }
    }

    Item
    {
        id: positionCursor
        width: 2
        height: mainBackground.height + 12
        anchors.top: mainBackground.top

        function updatePosition(pos)
        {
            if(pos >= waveformWidget.min() && pos <= waveformWidget.max())
            {
                positionCursor.visible = true
                positionCursor.x = waveformBackground.width * (pos - waveformWidget.min()) / (waveformWidget.max() - waveformWidget.min())
            }

            else
            {
                positionCursor.visible = false
            }
        }

        Canvas
        {
            width: 12
            height: parent.height
            x: - width / 2
            y: 12

            onPaint:
            {
                var ctx = getContext("2d")
                ctx.miterLimit = 0.1
                ctx.strokeStyle = "#99006DFF"
                ctx.lineWidth = 2
                ctx.fillStyle = "#6BAAFF"
                ctx.lineTo(width, 0)
                ctx.lineTo(width / 2, width)
                ctx.lineTo(0, 0)
                ctx.closePath()
                ctx.stroke()
                ctx.fill()
            }

            MouseAreaWithHidingCursor
            {
                id: cursorMovingArea
                anchors.topMargin: -4
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12
                hoverEnabled: true
                cursor: Qt.SizeHorCursor

                drag.target: positionCursor
                drag.axis: Drag.XAxis

                drag.minimumX: 0
                drag.maximumX: mainBackground.width - positionCursor.width

                onMouseXChanged:
                {
                    if(mouse.buttons === Qt.LeftButton)
                    {
                        let max = waveformWidget.max()
                        let min = waveformWidget.min()
                        let msecPerPx = (max - min) / waveformWidget.width
                        waveformWidget.setPlayerPosition(min + positionCursor.x * msecPerPx)
                    }
                }
            }
        }

        Rectangle
        {
            width: 2
            height: waveformBackground.height
            color: "#99006DFF"
            x: -1
            y: 24
        }

        Connections
        {
            target: waveformWidget
            function onMaxChanged()
            {
                positionCursor.updatePosition(waveformWidget.playerPosition())
            }
        }

        Connections
        {
            target: waveformWidget
            function onMinChanged()
            {
                positionCursor.updatePosition(waveformWidget.playerPosition())
            }
        }
    }

    MfxButton
    {
        id: stopButton
        width: 16
        height: 16
        color:  "#222222"
        pressedColor:  "#111111"

        anchors.leftMargin: 4
        anchors.bottomMargin: 4
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        Image
        {
            source: "qrc:/stopButton"
            anchors.centerIn: parent
        }

        onClicked:
        {
            waveformWidget.pause()
            waveformWidget.setPlayerPosition(startPositionMarker.position)
            positionCursor.updatePosition(startPositionMarker.position)
            timer.text = waveformWidget.positionString(startPositionMarker.position, "hh:mm:ss.zzz")
            playButton.checked = false
        }
    }

    MfxButton
    {
        id: playButton
        width: 16
        height: 16
        color:  "#222222"
        pressedColor:  "#111111"
        checkable: true

        anchors.leftMargin: 2
        anchors.bottomMargin: 4
        anchors.left: stopButton.right
        anchors.bottom: parent.bottom

        Image
        {
            source: playButton.checked ? "qrc:/pauseButton" : "qrc:/playButton"
            anchors.centerIn: parent
        }

        onCheckedChanged:
        {
            checked ? waveformWidget.play() : waveformWidget.pause()
        }
    }

    MfxButton
    {
        id: recordButton
        width: 16
        height: 16
        color:  "#222222"
        pressedColor:  "#111111"

        anchors.leftMargin: 2
        anchors.bottomMargin: 4
        anchors.left: playButton.right
        anchors.bottom: parent.bottom

        Image
        {
            source: "qrc:/recordButton"
            anchors.centerIn: parent
        }
    }

    Rectangle
    {
        id: timerArea
        width: 76
        height: 16
        color:  "#222222"
        radius: 2

        anchors.leftMargin: 2
        anchors.bottomMargin: 4
        anchors.left: recordButton.right
        anchors.bottom: parent.bottom

        Text
        {
            id: timer
            text: "00:00:00.000"
            color: "#eeeeee"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            anchors.centerIn: parent
            font.family: "Roboto"
            font.pixelSize: 12
        }

        Connections
        {
            target: waveformWidget
            function onTimerValueChanged(value)
            {
                timer.text = value
            }
        }
    }

    MfxButton
    {
        id: settingsButton
        width: 16
        height: 16
        color:  "#222222"
        pressedColor:  "#111111"

        anchors.leftMargin: 8
        anchors.bottomMargin: 4
        anchors.left: timerArea.right
        anchors.bottom: parent.bottom

        Image
        {
            source: "qrc:/settingsButton"
            anchors.centerIn: parent
        }
    }

    MfxButton
    {
        id: resetButton
        width: 40
        height: 16
        color:  "#222222"
        pressedColor:  "#111111"

        anchors.leftMargin: 8
        anchors.bottomMargin: 4
        anchors.left: settingsButton.right
        anchors.bottom: parent.bottom

        text: qsTr("reset")
        textSize: 10
    }

    MfxButton
    {
        id: repeatButton
        width: 28
        height: 16
        color:  "#222222"
        checkable: true

        anchors.leftMargin: 8
        anchors.bottomMargin: 4
        anchors.left: resetButton.right
        anchors.bottom: parent.bottom

        Image
        {
            source: repeatButton.checked ? "qrc:/repeatButtonChecked" : "qrc:/repeatButton"
            anchors.centerIn: parent
        }
    }

    Item
    {
        id: volumeRegulator
        width: 104
        height: 8

        anchors.rightMargin: 20
        anchors.right: monoModeButton.left
        anchors.bottomMargin: 2
        anchors.bottom: scrollArea.bottom

        Text
        {
            id: volumeCaption
            text: qsTr("Volume")

            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 8
            anchors.right: parent.left

            color: "#eeeeee"
            padding: 0
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.family: "Roboto"
            font.pixelSize: 12
        }

        Canvas
        {
            anchors.fill: parent

            onPaint:
            {
                var ctx = getContext("2d")
                ctx.miterLimit = 0.1
                ctx.fillStyle = "#222222"
                ctx.lineTo(width, height)
                ctx.lineTo(width, 0)
                ctx.lineTo(0, height)
                ctx.fill()
            }
        }

        Rectangle
        {
            id: volumeLevelBar
            width: 4
            height: 12
            radius: 2
            color: "#ffffff"
            anchors.verticalCenter: volumeRegulator.verticalCenter
            x: 100

            onXChanged:
            {
                waveformWidget.setVolume(x);
            }
        }

        MouseAreaWithHidingCursor
        {
            id: barMovingArea
            anchors.topMargin: -10
            anchors.bottomMargin: -10
            anchors.fill: parent

            drag.target: volumeLevelBar
            drag.axis: Drag.XAxis

            drag.minimumX: 0
            drag.maximumX: volumeRegulator.width - volumeLevelBar.width

            onClicked:
            {
                volumeLevelBar.x = mouseX
            }

            onWheel:
            {
                if(wheel.angleDelta.y > 0)
                {
                    if(volumeLevelBar.x + 5 <= 100)
                        volumeLevelBar.x += 5
                    else
                        volumeLevelBar.x = 100
                }

                else
                {
                    if(volumeLevelBar.x - 5 >= 0)
                        volumeLevelBar.x -= 5
                    else
                        volumeLevelBar.x = 0
                }
            }
        }
    }

    ButtonGroup
    {
        id: modeButtons
        checkedButton: monoModeButton

        onClicked: button == stereoModeButton ? waveformWidget.setStereoMode(true) : waveformWidget.setStereoMode(false)
    }

    MfxButton
    {
        id: stereoModeButton
        width: 54
        height: 16

        anchors.rightMargin: 8
        anchors.bottomMargin: 4
        anchors.right: scrollArea.left
        anchors.bottom: parent.bottom

        checkable: true
        color: "#27AE60"
        text: qsTr("Stereo")

        ButtonGroup.group: modeButtons
    }

    MfxButton
    {
        id: monoModeButton
        width: 54
        height: 16

        anchors.rightMargin: 2
        anchors.bottomMargin: 4
        anchors.right: stereoModeButton.left
        anchors.bottom: parent.bottom

        checkable: true
        color: "#27AE60"
        text: qsTr("Mono")

        ButtonGroup.group: modeButtons
    }

    Rectangle
    {
        id: scrollArea
        width: 164
        height: 16
        anchors.rightMargin: 2
        anchors.bottomMargin: 4
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        radius: 2
        color: "#222222"

        Text
        {
            id: visibleAreaRatio
            text: "0"
            anchors.leftMargin: 4
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color: "#eeeeee"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.family: "Roboto"
            font.pixelSize: 10

            Connections
            {
                target: waveformWidget
                function onMaxChanged()
                {
                    if(waveformWidget.duration())
                    {
                        visibleAreaRatio.text = Math.round((waveformWidget.max() - waveformWidget.min()) / waveformWidget.duration() * 100) + "%"
                    }
                }
            }

            Connections
            {
                target: waveformWidget
                function onMinChanged()
                {
                    visibleAreaRatio.text = Math.round((waveformWidget.max() - waveformWidget.min()) / waveformWidget.duration() * 100) + "%"
                }
            }
        }

        Rectangle
        {
            id: separator
            width: 2
            height: 16
            color: "#444444"
            anchors.right: scrollBackgroundWaveform.left
        }

        WaveformWidget
        {
            id: scrollBackgroundWaveform
            width: 130
            height: 16

            anchors.right: parent.right
            anchors.bottom: parent.bottom

            Rectangle
            {
                id: scrollBar
                height: parent.height
                width: scrollBackgroundWaveform.width
                color: "#20507FE6"
                border.width: 2
                border.color: "#507FE6"
                radius: 2

                function refresh()
                {
                    x = waveformWidget.min() / waveformWidget.duration() * scrollBackgroundWaveform.width
                    width = (waveformWidget.max() - waveformWidget.min()) / waveformWidget.duration() * scrollBackgroundWaveform.width
                    if(width < 5)
                        width = 5
                }

                Connections
                {
                    target: waveformWidget
                    function onMinChanged()
                    {
                        scrollBar.refresh()
                    }
                }

                Connections
                {
                    target: waveformWidget
                    function onMaxChanged()
                    {
                        scrollBar.refresh()
                    }
                }
            }

            ZoomingMouseArea
            {
                image: ""
                anchors.fill: parent

                onMoved:
                {

                    if(Math.abs(dx) > Math.abs(dy)) // Скроллим
                    {
                        let coeff = 1
                        if(Math.abs(dx) < 3)
                            coeff = 1
                        else if (Math.abs(dx) < 7)
                            coeff = 2
                        else if (Math.abs(dx) < 16)
                            coeff = 3
                        else
                            coeff = 4

                        let currInterval = waveformWidget.maxSample() - waveformWidget.minSample()
                        let dX = currInterval / width * Math.abs(dx) * coeff

                        if(dx > 0)
                        {
                            if(waveformWidget.maxSample() + dX < waveformWidget.sampleCount())
                            {
                                waveformWidget.setMaxSample(waveformWidget.maxSample() + dX)
                                waveformWidget.setMinSample(waveformWidget.minSample() + dX)
                                resizingCenterMarker.x -= Math.abs(dx) * coeff
                            }
                        }

                        else
                        {
                            if(waveformWidget.minSample() - dX >= 0)
                            {
                                waveformWidget.setMaxSample(waveformWidget.maxSample() - dX)
                                waveformWidget.setMinSample(waveformWidget.minSample() - dX)
                                resizingCenterMarker.x += Math.abs(dx) * coeff
                            }
                        }
                    }

                    else // Работаем с зумом
                    {

                    }
                }

                onWheel:
                {
                    timeScaleMouseArea.resizingCenterMarker.x = timeScaleMouseArea.width / 2
                    timeScaleMouseArea.zoom(wheel.angleDelta.y > 0 ? 2 : -2)
                }
            }

            Component.onCompleted:
            {
                if(project.property("audioTrackFile") !== "")
                {
                    setAudioTrackFile(settingsManager.workDirectory() + "/" + project.property("audioTrackFile"))
                }
            }
        }
    }

    Connections
    {
        target: waveformWidget
        function onTrackDownloaded()
        {
            if(project.property("startPosition") === -1) // Загрузили трек для нового проекта
            {
                project.setProperty("startPosition", 0)
                project.setProperty("stopPosition", waveformWidget.duration() - 1)
                project.setProperty("startLoop", 1)
                project.setProperty("stopLoop", waveformWidget.duration() - 2)
            }

            waveformWidget.showAll();
            startPositionMarker.position = project.property("startPosition")
            stopPositionMarker.position = project.property("stopPosition")
            startLoopMarker.position = project.property("startLoop")
            stopLoopMarker.position = project.property("stopLoop")

            startPositionMarker.updatePosition()
            waveformWidget.setPlayerPosition(startPositionMarker.position)
            positionCursor.updatePosition(startPositionMarker.position)
            timer.text = waveformWidget.positionString(startPositionMarker.position, "hh:mm:ss.zzz")
            stopPositionMarker.updatePosition()
            startLoopMarker.updatePosition()
            stopLoopMarker.updatePosition()
        }
    }

    Connections
    {
        target: scrollBackgroundWaveform
        function onTrackDownloaded()
        {
            scrollBackgroundWaveform.showAll()
        }
    }

    Connections
    {
        target: waveformWidget
        function onPositionChanged(pos)
        {
            if(repeatButton.checked && pos >= stopLoopMarker.position)
            {
                waveformWidget.setPlayerPosition(startLoopMarker.position)
            }

            if(pos < stopPositionMarker.position)
            {
                positionCursor.updatePosition(pos)
            }

            else
            {
                waveformWidget.pause()
                playButton.checked = false
                waveformWidget.setPlayerPosition(stopPositionMarker.position)
                positionCursor.updatePosition(stopPositionMarker.position)
                timer.text = waveformWidget.positionString(stopPositionMarker.position, "hh:mm:ss.zzz")
            }
        }
    }
}

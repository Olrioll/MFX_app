import QtQuick 2.12
import QtQuick.Controls 2.12

import WaveformWidget 1.0
import "qrc:/"

Item
{
    id: playerWidget
    clip: true

    property int minHeight: 200
    property int maxHeight: 600
    property int min
    property int max

    property alias waitingText: waitingText

    function projectDuration()
    {
        return project.property("prePlayInterval") + waveformWidget.duration() + project.property("postPlayInterval")
    }

    function msecToPixels(value)
    {
        return playerWidget.width * (value - playerWidget.min) / (playerWidget.max - playerWidget.min)
    }

    function pixelsToMsec(pixels)
    {
        return Math.round(pixels * (playerWidget.max - playerWidget.min) / playerWidget.width + playerWidget.min)
    }

    function hidePlayerElements()
    {
//        timeScale.visible = false
//        waveformWidget.visible = false
//        startPositionMarker.visible = false
//        startLoopMarker.visible = false
//        stopPositionMarker.visible = false
//        stopLoopMarker.visible = false
//        positionCursor.visible = false
//        cueViewFlickable.visible = false

//        waitingText.visible = true

//        for (let txt of timeScale.textMarkers)
//        {
//          txt.destroy()
//        }
//        timeScale.textMarkers = []

//        timer.text = "00:00:00.00"
    }

    function showPlayerElements()
    {
//        timeScale.visible = true
//        waveformWidget.visible = true
//        startPositionMarker.visible = true
//        startLoopMarker.visible = true
//        stopPositionMarker.visible = true
//        stopLoopMarker.visible = true
//        positionCursor.visible = true
//        cueViewFlickable.visible = true
    }

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

    Rectangle
    {
        id: waveformBackground
        anchors.topMargin: 24
        anchors.bottomMargin: 24
        anchors.fill: parent
        color: "#000000"
    }

    MfxMouseArea
    {
        id: playerResizeArea
        height: 4

        property int previousY

        anchors.topMargin: -2
        anchors
        {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        cursor: Qt.SizeVerCursor

        onPressed:
        {
            previousY = mouseY
        }

        onMouseYChanged:
        {
            var dy = mouseY - previousY

            if((playerWidget.height - dy) < playerWidget.minHeight)
                playerWidget.height = playerWidget.minHeight

            else if ((playerWidget.height - dy) <= mainScreen.height - 100)
                playerWidget.height = playerWidget.height - dy
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

                let max = playerWidget.max
                let min = playerWidget.min
                let msecPerPx = (max - min) / playerWidget.width

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
            target: playerWidget
            function onMaxChanged()
            {
                timeScaleCanvas.requestPaint()
            }
        }

        Connections
        {
            target: playerWidget
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
            image: ""

            property alias resizingCenterMarker: resizingCenterMarker

            property int pressedX
            property int pressedY

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

            onEntered:
            {
                if(!isPressed)
                    cursorImageForTimeScale.visible = true

                cursorImageForTimeScale.x = mouseX
                cursorImageForTimeScale.y = mouseY
            }

            onExited:
            {
                cursorImageForTimeScale.visible = false
            }

            onPressed:
            {
                cursorManager.saveLastPos()
                pressedX = mouseX
                pressedY = mouseY
                playerResizeArea.enabled = false
                playerResizeArea.cursorShape = Qt.BlankCursor
                mainScreen.sceneWidget.enabled = false
//                timeScaleMouseArea.cursorImage.visible = false
                cursorImageForTimeScale.visible = false
                resizingCenterMarker.x = mouseX
                resizingCenterMarker.visible = true
            }

            onPositionChanged:
            {
                cursorImageForTimeScale.x = mouseX
                cursorImageForTimeScale.y = mouseY
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
                cursorImageForTimeScale.visible = true

                cursorManager.moveToLastPos()
                cursorManager.moveCursor(resizingCenterMarker.x - pressedX, 0)
            }
        }
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
//                playButton.checked = false
                waveformWidget.setAudioTrackFile(settingsManager.workDirectory() + "/" + project.property("audioTrackFile"))
            }
        }
    }

    Image
    {
        id: cursorImageForTimeScale
        source: "qrc:/zoom"
        visible: false
    }

    Text
    {
        id: waitingText
        color: "#eeeeee"
        padding: 0
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.family: "Roboto"
        font.pixelSize: 14
        text: qsTr("Not available")

        anchors.centerIn: waveformBackground
    }

    Connections
    {
        target: waveformWidget
        function onTrackDownloaded()
        {
            waitingText.visible = false
//            showPlayerElements()

            if(project.property("startPosition") === -1) // Загрузили трек для нового проекта
            {
                project.setProperty("startPosition", 0)
                project.setProperty("stopPosition", waveformWidget.duration() - 1)
                project.setProperty("startLoop", 1)
                project.setProperty("stopLoop", waveformWidget.duration() - 2)

                project.setProperty("prePlayInterval", 10000)
                project.setProperty("postPlayInterval", 10000)
            }

            playerWidget.min = 0
            playerWidget.max = playerWidget.projectDuration()

            waveformWidget.anchors.leftMargin = msecToPixels(project.property("prePlayInterval"))
            waveformWidget.anchors.rightMargin = msecToPixels(project.property("postPlayInterval"))

            waveformWidget.showAll();
//            startPositionMarker.position = project.property("startPosition")
//            stopPositionMarker.position = project.property("stopPosition")
//            startLoopMarker.position = project.property("startLoop")
//            stopLoopMarker.position = project.property("stopLoop")

//            startPositionMarker.updatePosition()
//            waveformWidget.setPlayerPosition(startPositionMarker.position)
//            positionCursor.updatePosition(startPositionMarker.position)
//            timer.text = waveformWidget.positionString(startPositionMarker.position, "hh:mm:ss.zzz").substring(0, 11)
//            stopPositionMarker.updatePosition()
//            startLoopMarker.updatePosition()
//            stopLoopMarker.updatePosition()

//            cueView.loadCues()
//            cueView.refresh()
        }
    }

}

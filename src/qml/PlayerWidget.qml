import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import WaveformWidget 1.0
import "qrc:/"

Item
{
    id: playerWidget
    clip: true

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

    Item
    {
        id: timeScale
//        anchors.topMargin: -6
        anchors.fill: timeScaleBackground

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

 // малое деление будет равно 1 сек
                if(msecPerPx >= 50)
                {
                    // шаг делений в мсек
                    let stepMsec = 1000
                    // стартовая позиция в мсек
                    let startMsec = Math.ceil(min / stepMsec) * stepMsec

                    // стартовая позиция в пикселях
                    let start = (startMsec - min) / msecPerPx

                    // шаг делений в пикселях
                    let step = stepMsec / msecPerPx

                    ctx.miterLimit = 0.1
                    ctx.strokeStyle = "#888888"

                    let currPos = start;
                    let currPosMsec = startMsec
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

                            marker.text = waveformWidget.positionString(currPosMsec - stepMsec, "mm:ss")
                            marker.y = 2
                            marker.x = currPos - step - marker.width / 2
                        }
                    }

                    ctx.stroke()
                }

// малое деление будет равно 0.5 сек
                else if(msecPerPx >= 25)
                {
                    // шаг делений в мсек
                    let stepMsec = 500
                    // стартовая позиция в мсек
                    let startMsec = Math.ceil(min / stepMsec) * stepMsec

                    // стартовая позиция в пикселях
                    let start = (startMsec - min) / msecPerPx

                    // шаг делений в пикселях
                    let step = stepMsec / msecPerPx

                    ctx.miterLimit = 0.1
                    ctx.strokeStyle = "#888888"

                    let currPos = start;
                    let currPosMsec = startMsec
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

                            marker.text = waveformWidget.positionString(currPosMsec - stepMsec, "mm:ss")
                            marker.y = 2
                            marker.x = currPos - step - marker.width / 2
                        }
                    }

                    ctx.stroke()
                }

// малое деление будет равно 0.1 сек
                else
                {
                    // шаг делений в мсек
                    let stepMsec = 100
                    // стартовая позиция в мсек
                    let startMsec = Math.ceil(min / stepMsec) * stepMsec

                    // стартовая позиция в пикселях
                    let start = (startMsec - min) / msecPerPx

                    // шаг делений в пикселях
                    let step = stepMsec / msecPerPx

                    ctx.miterLimit = 0.1
                    ctx.strokeStyle = "#888888"

                    let currPos = start;
                    let currPosMsec = startMsec
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

                            marker.text = waveformWidget.positionString(currPosMsec - stepMsec, "mm:ss")
                            marker.y = 2
                            marker.x = currPos - step - marker.width / 2
                        }
                    }

                    ctx.stroke()
                }
            }
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

        MouseArea
        {
            id: mainMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onWheel:
            {
                (wheel.angleDelta.y > 0) ? scrollBar.zoomIn(mouseX / mainMouseArea.width)
                                              : scrollBar.zoomOut(mouseX / mainMouseArea.width)
                timeScaleCanvas.requestPaint()
            }
        }

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

    Item
    {
        id: positionCursor
        width: 2
        height: mainBackground.height + 12
        anchors.top: mainBackground.top

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
            function onPositionChanged(pos)
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
        }
    }

//    Text
//    {
//        id: minValue
//        text: waveformWidget.minString()
//        anchors.left: parent.left
//        anchors.top:parent.top
//        color: "#eeeeee"
//        horizontalAlignment: Text.AlignHCenter
//        verticalAlignment: Text.AlignVCenter
//        elide: Text.ElideRight
//        font.family: "Roboto"
//        font.pixelSize: 8

//        Connections
//        {
//            target: waveformWidget
//            function onMinChanged()
//            {
//                minValue.text = waveformWidget.minString()
//            }
//        }
//    }

//    Text
//    {
//        id: maxValue
//        text: waveformWidget.maxString()
//        anchors.right: parent.right
//        anchors.top:parent.top
//        color: "#eeeeee"
//        horizontalAlignment: Text.AlignHCenter
//        verticalAlignment: Text.AlignVCenter
//        elide: Text.ElideRight
//        font.family: "Roboto"
//        font.pixelSize: 8

//        Connections
//        {
//            target: waveformWidget
//            function onMaxChanged()
//            {
//                maxValue.text = waveformWidget.maxString()
//            }
//        }
//    }

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
            waveformWidget.stop()
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

        onClicked:
        {
            let trackFileName = project.selectAudioTrackDialog()
            if(trackFileName)
            {
                project.setAudioTrack(trackFileName)
                waveformWidget.setAudioTrackFile(trackFileName)
                scrollBackgroundWaveform.setAudioTrackFile(trackFileName)
            }
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
                    visibleAreaRatio.text = Math.round((waveformWidget.max() - waveformWidget.min()) / waveformWidget.duration() * 100) + "%"
//                    scrollBar.width = scrollBackgroundWaveform.width * (waveformWidget.max() - waveformWidget.min()) / waveformWidget.duration()
//                    scrollBar.x = waveformWidget.min() / waveformWidget.duration() * scrollBackgroundWaveform.width
                }
            }

            Connections
            {
                target: waveformWidget
                function onMinChanged()
                {
                    visibleAreaRatio.text = Math.round((waveformWidget.max() - waveformWidget.min()) / waveformWidget.duration() * 100) + "%"
//                    scrollBar.width = scrollBackgroundWaveform.width * (waveformWidget.max() - waveformWidget.min()) / waveformWidget.duration()
//                    scrollBar.x = waveformWidget.min() / waveformWidget.duration() * scrollBackgroundWaveform.width
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

                function zoomOut(zoomCenter)
                {
                    let newWidth = width + width * 0.05
                    let dWidth = newWidth - width
                    let leftShift = zoomCenter * dWidth
                    let rightShift = (1 - zoomCenter) * dWidth

                    if((x - leftShift) >= 0 && (x + width + rightShift) <= scrollBackgroundWaveform.width)
                    {
                        x -= leftShift
                        width = newWidth
                        return
                    }

                    let leftDist = x
                    let rightDist = scrollBackgroundWaveform.width - x - width

                    if(leftDist < rightDist)
                    {
                        dWidth -= x
                        x = 0

                        if((x + width + dWidth / 2) <= scrollBackgroundWaveform.width)
                        {
                            width = newWidth
                        }

                        else
                            width = scrollBackgroundWaveform.width
                    }

                    else
                    {
                        if(newWidth < scrollBackgroundWaveform.width)
                        {
                            width = newWidth
                            x = scrollBackgroundWaveform.width - width
                        }

                        else
                        {
                            x = 0
                            width = scrollBackgroundWaveform.width
                        }
                    }
                }

                function zoomIn(zoomCenter)
                {
                    let newWidth = width - width * 0.05
                    let dWidth = width - newWidth
                    let leftShift = zoomCenter * dWidth
                    let rightShift = (1 - zoomCenter) * dWidth
                    if(newWidth >= 10)
                    {
                        x += leftShift
                        width = newWidth
                    }
                }

                onXChanged:
                {
                    let minPos = waveformWidget.duration() / scrollBackgroundWaveform.width * x
                    let maxPos = waveformWidget.duration() / scrollBackgroundWaveform.width * (x + scrollBar.width)
                    waveformWidget.setMin(minPos)
                    waveformWidget.setMax(maxPos)
                }

                onWidthChanged:
                {
                    let minPos = waveformWidget.duration() / scrollBackgroundWaveform.width * x
                    let maxPos = waveformWidget.duration() / scrollBackgroundWaveform.width * (x + scrollBar.width)
                    waveformWidget.setMin(minPos)
                    waveformWidget.setMax(maxPos)
                }

                MouseArea
                {
                    id: movingArea
                    anchors.fill: parent

                    drag.target: scrollBar
                    drag.axis: Drag.XAxis

                    drag.minimumX: 0
                    drag.maximumX: scrollBackgroundWaveform.width - scrollBar.width
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
}

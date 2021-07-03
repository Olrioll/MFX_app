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
    property alias waitingText: waitingText

    function hidePlayerElements()
    {
        timeScale.visible = false
        waveformWidget.visible = false
        startPositionMarker.visible = false
        startLoopMarker.visible = false
        stopPositionMarker.visible = false
        stopLoopMarker.visible = false
        positionCursor.visible = false
        cueViewFlickable.visible = false

        waitingText.visible = true

        for (let txt of timeScale.textMarkers)
        {
          txt.destroy()
        }
        timeScale.textMarkers = []

        timer.text = "00:00:00.00"
    }

    function showPlayerElements()
    {
        timeScale.visible = true
        waveformWidget.visible = true
        startPositionMarker.visible = true
        startLoopMarker.visible = true
        stopPositionMarker.visible = true
        stopLoopMarker.visible = true
        positionCursor.visible = true
        cueViewFlickable.visible = true
    }

    function msecToPixels(value)
    {
        return waveformWidget.width * (value - waveformWidget.min()) / (waveformWidget.max() - waveformWidget.min())
    }

    function pixelsToMsec(pixels)
    {
        return Math.round(pixels * (waveformWidget.max() - waveformWidget.min()) / waveformWidget.width + waveformWidget.min())
    }

    function isCuePlatesIntersect(plate1, plate2)
    {
//        let aLeftOfB = plate1.mapToItem(cueView, plate1.x, plate1.y).x + plate1.width < plate2.mapToItem(cueView, plate2.x, plate2.y).x;
//        let aRightOfB = plate1.mapToItem(cueView, plate1.x, plate1.y).x > plate2.mapToItem(cueView, plate2.x, plate2.y).x + plate2.width;
//        let aAboveB = plate1.mapToItem(cueView, plate1.x, plate1.y).y > plate2.mapToItem(cueView, plate2.x, plate2.y).y + plate2.height;
//        let aBelowB = plate1.mapToItem(cueView, plate1.x, plate1.y).y + plate1.height < plate2.mapToItem(cueView, plate2.x, plate2.y).y;

        let aLeftOfB = plate1.mapToGlobal(plate1.x, plate1.y).x + plate1.width < plate2.mapToGlobal(plate2.x, plate2.y).x;
        let aRightOfB = plate1.mapToGlobal(plate1.x, plate1.y).x > plate2.mapToGlobal( plate2.x, plate2.y).x + plate2.width;
        let aAboveB = plate1.mapToGlobal(plate1.x, plate1.y).y > plate2.mapToGlobal(plate2.x, plate2.y).y + plate2.height;
        let aBelowB = plate1.mapToGlobal(plate1.x, plate1.y).y + plate1.height < plate2.mapToGlobal(plate2.x, plate2.y).y;

        return !( aLeftOfB || aRightOfB || aAboveB || aBelowB );
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

    MfxMouseArea
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

        cursor: Qt.SizeVerCursor

        onPressed:
        {
            playerWidget.previousY = mouseY
        }

        onMouseYChanged:
        {
            var dy = mouseY - playerWidget.previousY

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
//                setAudioTrackFile(settingsManager.workDirectory() + "/" + project.property("audioTrackFile"))
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
        anchors.left: repeatButton.checked ? stopLoopMarker.right : stopPositionMarker.right
        color: "black"
        opacity: 0.5
    }

    Flickable
    {
        id: cueViewFlickable
        anchors.fill: waveformWidget
        contentHeight: cueView.height
        clip: true

        Item
        {
            id: cueView
            width: waveformWidget.width

            property int rowMargin: 2
            property int collapsedPlateHeight: 10
            property int expandedPlateHeight: 36

            property var rows: []

            function clearRows()
            {
                for(var i = 0; i < rows.length; i++)
                {
                    rows[i].clear()
                    rows[i].destroy()
                }

                rows = []
            }

            function insertRow(position)
            {
                rows.splice(position, 0, [])
                rowsY.splice(position, 0, 0)
                rowsHeights.splice(position, 0, 0)

                getCueList().forEach(function(item)
                {
                    if(item.row >= position)
                    {
                        item.row++
                        project.setCueProperty(item.name, "row", item.row)
                    }
                })
            }

            function loadCues()
            {
                clearRows()

                for(var i = 0; i < project.maxCueRow() + 1; i++)
                {
                    rows.push(cueViewRow.createObject(cueView, {index: i }))
                }

                let cuesList = project.getCues();

                for(i = 0; i < cuesList.length; i++)
                {
                    let currCueProperties = cuesList[i];
                    rows[currCueProperties["row"]].cuePlates.push(
                                                        cuePlate.createObject(rows[currCueProperties["row"]],
                                                          {
                                                              name: currCueProperties["name"],
                                                              row: currCueProperties["row"],
                                                              position: currCueProperties["position"],
                                                              duration: currCueProperties["duration"]
                                                          }))
                    }
            }

            function getCueList()
            {
                let cueList = []
                rows.forEach(function(row)
                {
                    row.cuePlates.forEach(function(cuePlate){cueList.push(cuePlate)})
                })

                return cueList
            }

            function setActiveCue(name)
            {
                let cueList = getCueList()
                cueList.forEach(function(cuePlate)
                {
                    if(cuePlate.name === name)
                    {
                        cuePlate.isExpanded = true
                        rows[cuePlate.row].isExpanded = true
                    }
                    else
                    {
                        cuePlate.isExpanded = false
                        rows[cuePlate.row].isExpanded = false
                    }
                })
                refresh()
            }

            function refresh()
            {
                let prevRowsHeight = 0
                let currHeight = cueView.collapsedPlateHeight
                for(var j = 0; j < rows.length; j++)
                {
                    let currRow = rows[j]

                    if(currRow.isExpanded)
                        currHeight = cueView.expandedPlateHeight

                    currRow.y = prevRowsHeight + rowMargin
                    currRow.refreshCuePlates()

                    prevRowsHeight += currHeight + rowMargin
                    currHeight = cueView.collapsedPlateHeight
                }

                cueView.height = prevRowsHeight
            }

            MfxMouseArea
            {
                id: mouseArea
                anchors.fill: parent
                propagateComposedEvents: false

                property int pressedX
                property int pressedY
                property var pressedRow
                property int prevMouseX
                property int prevMouseY
                property int dxAcc
                property var pressedCuePlate: null
                property bool isDraggingCuePlate
                property var currRow: null

                property var draggingPlatesList: []
                property bool hasIntersection

                onPressed:
                {
                    cueViewFlickable.interactive = false
                    pressedX = mouseX
                    pressedY = mouseY
                    prevMouseX = pressedX
                    prevMouseY = prevMouseY
                    draggingPlatesList = []
                    pressedCuePlate = null
                    dxAcc = 0

                    cueView.rows.forEach(function(row)
                    {
                        if(row.contains(mouseArea.mapToItem(row, 0, mouseY)))
                        {
                            pressedRow = row
                            return
                        }
                    })

                    let cueList = cueView.getCueList()
                    cueList.forEach(function(cuePlate)
                    {
                        if(cuePlate.contains(mouseArea.mapToItem(cuePlate, mouseX, mouseY)))
                        {
                            pressedCuePlate = cuePlate
                            pressedCuePlate.tempRow = pressedCuePlate.row
                            pressedCuePlate.tempPosition = pressedCuePlate.position
                            draggingPlatesList.push(cuePlate)
                            return
                        }
                    })

                    if(pressedCuePlate)
                    {
                        cueList.forEach(function(cuePlate)
                        {
                            if(cuePlate.checked && cuePlate !== pressedCuePlate)
                            {
                                cuePlate.tempRow = cuePlate.row
                                cuePlate.tempPosition = cuePlate.position
                                draggingPlatesList.push(cuePlate)
                            }
                        })
                    }

                    else
                    {
                        cueView.setActiveCue("")

                        cueList.forEach(function(cuePlate)
                        {
                            cuePlate.checked = false
                        })
                    }
                }

                onReleased:
                {
                    if(isDraggingCuePlate)
                    {
                        if(!hasIntersection) // Не накладываемся на другие плашки
                        {
                            draggingPlatesList.forEach(function(cuePlate)
                            {
                                if(cuePlate.tempRow !== cuePlate.row)
                                {
                                    // Удаляем плашку из старой строки

                                    cueView.rows[cuePlate.row].cuePlates.splice(cueView.rows[cuePlate.row].cuePlates.indexOf(cuePlate), 1)

                                    // Добавляем плашку в новую строку
                                    cueView.rows[cuePlate.tempRow].cuePlates.push(cuePlate)
                                    cuePlate.row = cuePlate.tempRow
                                }

                                cuePlate.parent = cueView.rows[cuePlate.tempRow]
                                cuePlate.y = 0
                                cuePlate.position = cuePlate.tempPosition

                                project.setCueProperty(cuePlate.name, "row", cuePlate.row)
                                project.setCueProperty(cuePlate.name, "position", cuePlate.position)
                            })
                        }

                        else
                        {
                            draggingPlatesList.forEach(function(cuePlate)
                            {
                                cuePlate.parent = cueView.rows[cuePlate.row]
                                cuePlate.y = 0
                                cuePlate.state = ""
                            })
                        }

//                        // перетаскивали одну плашку
//                        if(draggingPlatesList.length === 1)
//                        {
//                            cueView.rows.forEach(function(item, index, array)
//                            {
//                                if(mouseY >= cueView.rowsY[index] && mouseY <= cueView.rowsY[index] + cueView.rowsHeights[index])
//                                {
//                                    let oldRow = cueView.rows[draggingPlatesList[0].row]

//                                    if(item.length === 0) // Строка пустая
//                                    {
//                                        // удалем иконку кьюшки из старой строки
//                                        oldRow.splice(oldRow.indexOf(draggingPlatesList[0]), 1)

//                                        draggingPlatesList[0].row = index
//                                        draggingPlatesList[0].position = Math.round(pixelsToMsec(draggingPlatesList[0].x) / 10) * 10
//                                        item.push(draggingPlatesList[0])
//                                        project.setCueProperty(draggingPlatesList[0].name, "row", index)
//                                        project.setCueProperty(draggingPlatesList[0].name, "position", draggingPlatesList[0].position)
//                                    }

//                                    else // проверяем пересечение с другими плашками
//                                    {
//                                        let currRow = cueView.rows[index]

//                                        // удалем иконку кьюшки из старой строки
//                                        oldRow.splice(oldRow.indexOf(draggingPlatesList[0]), 1)

//                                        let hasIntersection = false
//                                        currRow.forEach(function(item)
//                                        {
//                                            if(isCuePlatesIntersect(item, draggingPlatesList[0]))
//                                                hasIntersection = true
//                                        })

//                                        if(hasIntersection)
//                                        {
//                                            cueView.insertRow(index + 1)
//                                            cueView.rows[index + 1].push(draggingPlatesList[0])
//                                            draggingPlatesList[0].row = index + 1
//                                            draggingPlatesList[0].position = Math.round(pixelsToMsec(draggingPlatesList[0].x) / 10) * 10
//                                            project.setCueProperty(draggingPlatesList[0].name, "row", draggingPlatesList[0].row)
//                                            project.setCueProperty(draggingPlatesList[0].name, "position", draggingPlatesList[0].position)
//                                        }

//                                        else
//                                        {
//                                            draggingPlatesList[0].row = index
//                                            draggingPlatesList[0].position = Math.round(pixelsToMsec(draggingPlatesList[0].x) / 10) * 10
//                                            item.push(draggingPlatesList[0])
//                                            project.setCueProperty(draggingPlatesList[0].name, "row", index)
//                                            project.setCueProperty(draggingPlatesList[0].name, "position", draggingPlatesList[0].position)
//                                        }
//                                    }
//                                }
//                            })
//                        }

//                        cueView.refresh();
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
                    cueView.refresh()
                }

                onDoubleClicked:
                {
                    if(pressedCuePlate)
                        cueView.setActiveCue(pressedCuePlate.name)
                }

                onPositionChanged:
                {
                    cueView.rows.forEach(function(row)
                    {
                        if(row.contains(mouseArea.mapToItem(row, 0, mouseY)))
                        {
                            currRow = row
                            return
                        }
                    })

                    let dx = mouseX - prevMouseX
                    let dy = mouseY - prevMouseY

                    prevMouseX = mouseX
                    prevMouseY = mouseY

                    dxAcc += dx

                    let leftScrollInterval = 0
                    let rightScrollInterval = 0

                    // скроллим видимую область вверх
                    if(mouseArea.mapToItem(cueViewFlickable, mouseX, mouseY).y < 0)
                    {
                        cueViewScrollBar.decrease()
                    }

                    // скроллим видимую область вниз
                    else if(mouseArea.mapToItem(cueViewFlickable, mouseX, mouseY).y > cueViewFlickable.height)
                    {
                        cueViewScrollBar.increase()
                    }

                    if(pressedCuePlate)
                    {
                        if(!isDraggingCuePlate)
                        {
                            draggingPlatesList.forEach(function(cuePlate)
                            {
                                let currY = cuePlate.mapToItem(cueView, 0, 0).y
                                cuePlate.parent = cueView
                                cuePlate.y = currY
                            })
                            isDraggingCuePlate = true
                        }

                        else
                        {
                            let canBeMovedVertically = true
                            let shouldBeMovedHorizontally = true

                            draggingPlatesList.forEach(function(cuePlate)
                            {
                                if(currRow)
                                {
                                    let newIndex = currRow.index + (cuePlate.row - pressedRow.index)
                                    cuePlate.tempRow = newIndex
                                    if(newIndex < 0 || newIndex >= cueView.rows.length)
                                    {
                                        canBeMovedVertically = false
                                        return
                                    }
                                }

                                else
                                {
                                    canBeMovedVertically = false
                                    return
                                }
                            })

                            if(Math.abs(Math.round(pixelsToMsec(draggingPlatesList[0].x + dxAcc) / 10) * 10 - Math.round(pixelsToMsec(draggingPlatesList[0].x) / 10) * 10) >= 10)
                            {

                                draggingPlatesList.forEach(function(cuePlate)
                                {
                                    let newPos = Math.round(pixelsToMsec(cuePlate.x + dxAcc) / 10) * 10

                                    // если вылезем за края трека
                                    if(!(newPos >=0 && (newPos + cuePlate.duration <= waveformWidget.duration())))
                                    {
                                        shouldBeMovedHorizontally = false
                                        return
                                    }

                                    // если нужно проскроллить влево
                                    if(newPos < waveformWidget.min())
                                    {
                                        if((waveformWidget.min() - newPos) > leftScrollInterval)
                                        {
                                            leftScrollInterval = waveformWidget.min() - newPos
                                        }
                                    }

                                    // если нужно проскроллить вправо
                                    else if((newPos + cuePlate.duration) > waveformWidget.max())
                                    {
                                        if((newPos + cuePlate.duration) - waveformWidget.max() > rightScrollInterval)
                                        {
                                            rightScrollInterval = (newPos + cuePlate.duration) - waveformWidget.max()
                                        }
                                    }


                                })

                                if(leftScrollInterval)
                                {
                                    waveformWidget.setMin(waveformWidget.min() - leftScrollInterval)
                                    waveformWidget.setMax(waveformWidget.max() - leftScrollInterval)
                                }

                                else if(rightScrollInterval)
                                {
                                    waveformWidget.setMin(waveformWidget.min() + rightScrollInterval)
                                    waveformWidget.setMax(waveformWidget.max() + rightScrollInterval)
                                }

                            }

                            hasIntersection = false

                            draggingPlatesList.forEach(function(cuePlate)
                            {  
                                if(shouldBeMovedHorizontally && !leftScrollInterval && !rightScrollInterval)
                                {
                                    let newPos = Math.round(pixelsToMsec(cuePlate.x + dxAcc) / 10) * 10

                                    if(Math.abs(newPos - Math.round(pixelsToMsec(cuePlate.x) / 10) * 10) >= 10)
                                    {
                                        cuePlate.tempPosition = newPos
                                        cuePlate.x  = msecToPixels(newPos)
                                    }
                                }

                                if(canBeMovedVertically)
                                    cuePlate.y = cueView.rows[cuePlate.tempRow].y


                                // проверяем пересечение с другими плашками

                                if(!hasIntersection)
                                {
                                    let cueList = cueView.getCueList()
                                    cueList.forEach(function(otherCuePlate)
                                    {
                                        if(otherCuePlate.parent !== cueView && otherCuePlate.row === cuePlate.tempRow)
                                        {
                                            if( ! ((cuePlate.tempPosition + cuePlate.duration < otherCuePlate.position) ||
                                                 (cuePlate.tempPosition > otherCuePlate.position + otherCuePlate.duration)))
                                            {
                                                hasIntersection = true
                                                return
                                            }
                                        }
                                    })
                                }
                            })

                            draggingPlatesList.forEach(function(cuePlate)
                            {
                                cuePlate.state = hasIntersection ? "intersected" : ""
                            })

                            if(shouldBeMovedHorizontally)
                            {
                                dxAcc = 0
                            }
                        }
                    }
                }
            }

            Component
            {
                id: cueViewRow
                Item
                {
                    height: isExpanded ? expandedHeight : collapsedHeight

                    property int index
                    property bool isExpanded: false
                    property bool checked: false
                    property int collapsedHeight: cueView.collapsedPlateHeight
                    property int expandedHeight: cueView.expandedPlateHeight

                    property var cuePlates: []

                    function clear()
                    {
                        for(var i = 0; i < cuePlates.length; i++)
                        {
                            cuePlates[i].destroy()
                        }

                        cuePlates = []
                    }

                    function refreshCuePlates()
                    {
                        for(var i = 0; i < cuePlates.length; i++)
                        {
                            if(!(cuePlates[i].parent === cueView))
                            {
                                cuePlates[i].x = msecToPixels(cuePlates[i].position)
                                cuePlates[i].width = msecToPixels(cuePlates[i].position + cuePlates[i].duration) - cuePlates[i].x
                            }
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
                    property int collapsedHeight: cueView.collapsedPlateHeight
                    property int expandedHeight: cueView.expandedPlateHeight
                    property int row
                    property int position // в мсек
                    property int duration  // в мсек
                    property int tempRow
                    property int tempPosition

                    states:
                        [
                        State
                        {
                            name: "intersected"
                            PropertyChanges
                            {
                                target: frame
                                color: "#3FEB5757"
                            }

                            PropertyChanges
                            {
                                target: frame.border
                                color: "#EB5757"
                            }
                        }
                    ]

                    Rectangle
                    {
                        id: frame
                        anchors.fill: parent

                        radius: 4
                        color: "#7F27AE60"
                        border.width: 2
                        border.color: parent.checked ? "#2F80ED" : "#27AE60"

                    }

                    Text
                    {
                        id: caption
                        color: "#ffffff"
                        text: parent.name
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideMiddle
                        anchors.centerIn: parent
                        font.family: "Roboto"
                        font.pixelSize: 8
                        visible: parent.width > 0
                    }
                }
            }

            Component.onCompleted:
            {
//                loadCues();

//                project.addCue(
//                            [
//                                {propName: "name", propValue: "cue1"},
//                                {propName: "row", propValue: 0},
//                                {propName: "position", propValue: 1000},
//                                {propName: "duration", propValue: 10000}
//                            ])

//                project.addCue(
//                            [
//                                {propName: "name", propValue: "cue2"},
//                                {propName: "row", propValue: 1},
//                                {propName: "position", propValue: 2000},
//                                {propName: "duration", propValue: 10000}
//                            ])

//                project.addCue(
//                            [
//                                {propName: "name", propValue: "cue3"},
//                                {propName: "row", propValue: 2},
//                                {propName: "position", propValue: 10000},
//                                {propName: "duration", propValue: 8000}
//                            ])

//                project.addCue(
//                            [
//                                {propName: "name", propValue: "cue5"},
//                                {propName: "row", propValue: 14},
//                                {propName: "position", propValue: 25000},
//                                {propName: "duration", propValue: 18000}
//                            ])

//                project.addCue(
//                            [
//                                {propName: "name", propValue: "cue6"},
//                                {propName: "row", propValue: 15},
//                                {propName: "position", propValue: 7000},
//                                {propName: "duration", propValue: 12000}
//                            ])
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
            image: ""

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
//                timeScaleMouseArea.cursorImage.visible = true
                cursorImageForTimeScale.visible = true
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
            startPositionMarker.x = msecToPixels(position)
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

            MfxMouseArea
            {
                id: startPositionMarkerMovingArea
                anchors.topMargin: -4
                anchors.top: parent.top
                anchors.leftMargin: -6
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12
                hoverEnabled: true

                dragOnX: true
                draggedItem: startPositionMarker
                draggedItemMinX: 0
                draggedItemMaxX: stopLoopMarker.x

                cursorShape: Qt.SizeHorCursor
                onPressed: timeScaleMouseArea.visible = false
                onReleased: timeScaleMouseArea.visible = true

                onMouseXChanged:
                {
                    if(wasPressedAndMoved)
                    {
                        startPositionMarker.position = pixelsToMsec(startPositionMarker.x)
                        project.setProperty("startPosition", startPositionMarker.position)

                        if(startLoopMarker.position < startPositionMarker.position)
                        {
                            startLoopMarker.x = startPositionMarker.x
                            startLoopMarker.position = startPositionMarker.position
                            project.setProperty("startLoop", startLoopMarker.position)
                        }

                        if(waveformWidget.playerPosition() < startPositionMarker.position)
                        {
                            positionCursor.x = startPositionMarker.x
                            waveformWidget.setPlayerPosition(startPositionMarker.position)
                            timer.text = waveformWidget.positionString(pixelsToMsec(positionCursor.x), "hh:mm:ss.zzz").substring(0, 11)
                        }
                    }

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
            stopPositionMarker.x = msecToPixels(position)
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

            MfxMouseArea
            {
                id: stopPositionMarkerMovingArea
                anchors.topMargin: -4
                anchors.top: parent.top
                anchors.leftMargin: -4
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12
                hoverEnabled: true

                dragOnX: true
                draggedItem: stopPositionMarker
                draggedItemMinX: startLoopMarker.x
                draggedItemMaxX: waveformWidget.width

                cursorShape: Qt.SizeHorCursor
                onPressed: timeScaleMouseArea.visible = false
                onReleased: timeScaleMouseArea.visible = true

                onMouseXChanged:
                {
                    if(wasPressedAndMoved)
                    {
                        stopPositionMarker.position = pixelsToMsec(stopPositionMarker.x)
                        project.setProperty("stopPosition", stopPositionMarker.position)

                        if(stopLoopMarker.position > stopPositionMarker.position)
                        {
                            stopLoopMarker.x = stopPositionMarker.x
                            stopLoopMarker.position = stopPositionMarker.position
                            project.setProperty("stopLoop", stopLoopMarker.position)
                        }

                        if(waveformWidget.playerPosition() > stopPositionMarker.position)
                        {
                            positionCursor.x = stopPositionMarker.x - 2
                            waveformWidget.setPlayerPosition(stopPositionMarker.position)
                            timer.text = waveformWidget.positionString(pixelsToMsec(positionCursor.x), "hh:mm:ss.zzz").substring(0, 11)
                        }
                    }
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
            startLoopMarker.x = msecToPixels(position)
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
                ctx.strokeStyle = "#F2994A"
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

            MfxMouseArea
            {
                id: startLoopMarkerMovingArea
                anchors.topMargin: -4
                anchors.top: parent.top
                anchors.leftMargin: -4
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12
                hoverEnabled: true

                dragOnX: true
                draggedItem: startLoopMarker
                draggedItemMinX: 0
                draggedItemMaxX: stopLoopMarker.x

                cursorShape: Qt.SizeHorCursor
                onPressed: timeScaleMouseArea.visible = false
                onReleased: timeScaleMouseArea.visible = true

                onMouseXChanged:
                {
                    if(wasPressedAndMoved)
                    {
                        startLoopMarker.position = pixelsToMsec(startLoopMarker.x)
                        project.setProperty("startLoop", startLoopMarker.position)

                        if(startLoopMarker.position < startPositionMarker.position)
                        {
                            startPositionMarker.x = startLoopMarker.x
                            startPositionMarker.position = startLoopMarker.position
                            project.setProperty("startPosition", startPositionMarker.position)
                        }
                    }
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
            stopLoopMarker.x = msecToPixels(position)
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
                ctx.strokeStyle = "#F2994A"
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

            MfxMouseArea
            {
                id: stopLoopMarkerMovingArea
                anchors.topMargin: -4
                anchors.top: parent.top
                anchors.leftMargin: -4
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12
                hoverEnabled: true

                dragOnX: true
                draggedItem: stopLoopMarker
                draggedItemMinX: startLoopMarker.x
                draggedItemMaxX: waveformWidget.width

                cursorShape: Qt.SizeHorCursor
                onPressed: timeScaleMouseArea.visible = false
                onReleased: timeScaleMouseArea.visible = true

                onMouseXChanged:
                {
                    if(wasPressedAndMoved)
                    {
                        stopLoopMarker.position = pixelsToMsec(stopLoopMarker.x)
                        project.setProperty("stopLoop", stopLoopMarker.position)

                        if(stopLoopMarker.position > stopPositionMarker.position)
                        {
                            stopPositionMarker.x = stopLoopMarker.x
                            stopPositionMarker.position = stopLoopMarker.position
                            project.setProperty("stopPosition", stopPositionMarker.position)
                        }
                    }
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
            x: - width / 2 + 1
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

            MfxMouseArea
            {
                id: cursorMovingArea
                anchors.topMargin: -4
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12
                hoverEnabled: true

                dragOnX: true
                draggedItem: positionCursor
                draggedItemMinX: startPositionMarker.x
                draggedItemMaxX: stopPositionMarker.x

                cursorShape: Qt.SizeHorCursor
                onPressed: timeScaleMouseArea.visible = false
                onReleased: timeScaleMouseArea.visible = true

                onMouseXChanged:
                {
                    if(mouse.buttons === Qt.LeftButton)
                    {
                        waveformWidget.setPlayerPosition(pixelsToMsec(positionCursor.x))
                        timer.text = waveformWidget.positionString(pixelsToMsec(positionCursor.x), "hh:mm:ss.zzz").substring(0, 11)
                        positionMarker.x = pixelsToMsec(positionCursor.x) / waveformWidget.duration() * scrollBackgroundWaveform.width
                    }

                    if(positionCursor.x + positionCursor.width + 1 === Math.round(stopPositionMarker.x))
                    {
                        waveformWidget.setPlayerPosition(stopPositionMarker.position)
                        timer.text = waveformWidget.positionString(stopPositionMarker.position, "hh:mm:ss.zzz").substring(0, 11)
                        positionCursor.updatePosition(waveformWidget.playerPosition())
                    }

                    else if(positionCursor.x === Math.round(startPositionMarker.x))
                    {
                        waveformWidget.setPlayerPosition(startPositionMarker.position)
                        timer.text = waveformWidget.positionString(startPositionMarker.position, "hh:mm:ss.zzz").substring(0, 11)
                        positionCursor.updatePosition(waveformWidget.playerPosition())
                    }
                }
            }
        }

        Rectangle
        {
            width: 2
            height: waveformBackground.height
            color: "#99006DFF"
            x: 0
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

    Image
    {
        id: cursorImageForTimeScale
        source: "qrc:/zoom"
        visible: false
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
            text: "00:00:00.00"
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

        onClicked:
        {
            project.setProperty("startPosition", 0)
            project.setProperty("stopPosition", waveformWidget.duration() - 1)
            project.setProperty("startLoop", 1)
            project.setProperty("stopLoop", waveformWidget.duration() - 2)

            waveformWidget.showAll();
            startPositionMarker.position = project.property("startPosition")
            stopPositionMarker.position = project.property("stopPosition")
            startLoopMarker.position = project.property("startLoop")
            stopLoopMarker.position = project.property("stopLoop")

            startPositionMarker.updatePosition()
            waveformWidget.setPlayerPosition(startPositionMarker.position)
            positionCursor.updatePosition(startPositionMarker.position)
            timer.text = waveformWidget.positionString(startPositionMarker.position, "hh:mm:ss.zzz").substring(0, 11)
            stopPositionMarker.updatePosition()
            startLoopMarker.updatePosition()
            stopLoopMarker.updatePosition()

//            cueView.loadCues()
            cueView.refresh()
        }
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

        MouseArea
        {
            id: barMovingArea
            anchors.topMargin: -10
            anchors.bottomMargin: -10
            anchors.fill: parent

            onClicked:
            {
                volumeLevelBar.x = mouseX
            }

            onPositionChanged:
            {
                if(mouse.buttons)
                {
                    if(mouseX < 0)
                        volumeLevelBar.x = 0

                    else if(mouseX > volumeRegulator.width)
                        volumeLevelBar.x = 100

                    else
                        volumeLevelBar.x = mouseX
                }
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

                Connections
                {
                    target: project
                    function onAudioTrackFileChanged()
                    {
                        scrollBackgroundWaveform.setAudioTrackFile(settingsManager.workDirectory() + "/" + project.property("audioTrackFile"))
                    }
                }
            }

            Rectangle
            {
                id: positionMarker
                width: 2
                height: parent.height - 4
                y: 2
                color: "red"

                Connections
                {
                    target: waveformWidget
                    function onPositionChanged(pos)
                    {
                        positionMarker.x = pos / waveformWidget.duration() * scrollBackgroundWaveform.width
                    }
                }
            }

            ZoomingMouseArea
            {
                id: bottomScrollArea
                image: "qrc:/resize"
                anchors.fill: parent
                hoverEnabled: true

                onPressed:
                {
                    bottomScrollArea.cursorImage.visible = false
                }

                onReleased:
                {
                    bottomScrollArea.cursorImage.visible = true
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
        }
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
            showPlayerElements()

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
            timer.text = waveformWidget.positionString(startPositionMarker.position, "hh:mm:ss.zzz").substring(0, 11)
            stopPositionMarker.updatePosition()
            startLoopMarker.updatePosition()
            stopLoopMarker.updatePosition()

            cueView.loadCues()
            cueView.refresh()
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
//                timer.text = waveformWidget.positionString(stopPositionMarker.position, "hh:mm:ss.zz")
            }
        }
    }

    Component.onCompleted: hidePlayerElements()
}

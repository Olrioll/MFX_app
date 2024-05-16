import QtQuick 2.15

import MFX.UI.Components.Basic 1.0 as MFXUICB
import MFX.UI.Styles 1.0 as MFXUIS

Component
{
    Item
    {
        id: cuePlate
        x: msecToPixels(position - playerWidget.min)
        y: isAfterExpanded ? yPosition + cueView.expandedHeight - cueView.collapsedHeight : yPosition
        width: msecToPixels(duration)
        height: isExpanded ? cueView.expandedHeight : cueView.collapsedHeight

        clip: width > 30 ? true : false

        property string name: ""
        property bool isExpanded: false
        property bool checked: false //Влияет только на цвет рамки выделения
        onCheckedChanged: if(cueCopy.isCopy)checked =true
        property bool isAfterExpanded: false
        property int yPosition
        property double position // в мсек
        property double duration  // в мсек
        property int startMovingY
        property double startMovingPosition
        property int frameBorderWidth: 2

        property var actionList: []
        property var prefiresList: []
        property var firstAction: null
        property alias caption: caption

        function updatePosition()
        { console.log('updatePosition')
            let actions = project.cueActions(cuePlate.name)
            let endPosition = 0
            if(actionList.length)
            {
                firstAction = actionList[0]
                position = actionList[0].position

                endPosition = actionList[0].position + project.cueActionDuration(cuePlate.name, actions[0].actionName)
            }
            else
                return

            actionList.forEach(function(currActionMarker)
            {
                if(currActionMarker.prefirePosition() < position)
                {
                    firstAction = currActionMarker
                    position = currActionMarker.prefirePosition()
                }

                let currPosition = currActionMarker.position
                let currDuration = project.cueActionDuration(cuePlate.name, currActionMarker.name)

                if(currPosition + currDuration > endPosition)
                {
                    endPosition = currPosition + currDuration
                }

            })

            duration = endPosition - position
        }

        function loadActions()
        {
            for(var i = 0; i < actionList.length; i++)
                actionList[i].destroy()

            for(var i = 0; i < prefiresList.length; i++)
                prefiresList[i].destroy()

            actionList = []
            prefiresList = []

            let actions = []
            actions = project.cueActions(name)

            actions.forEach(function(currAction)
            {
                let prefireDuration = patternManager.patternByName(currAction.actionName).prefireDuration

                let newActionMarker = actionMarkerComponent.createObject(cuePlate, {name: currAction.actionName,
                                                                                displayedName: currAction.actionName + " - P" + currAction.patchId,
                                                                                patchId: currAction.patchId,
                                                                                position: currAction.position,
                                                                                prefire: prefireDuration,
                                                                                positionCoeff: currAction.positionCoeff
                                                                            })
                actionList.push(newActionMarker)

                let newPrefireSpaceComponent = prefireSpaceComponent.createObject(cuePlate,
                {
                    position: currAction.position,
                    prefire: prefireDuration
                })

                prefiresList.push(newPrefireSpaceComponent)
            })

            updatePosition()
        }

        function moveActions(dt)
        {
            actionList.forEach(function(currAction)
            {
                currAction.position += dt
                let p = Math.round(Math.round(currAction.position*10)/10);
                let l = p % 10;
                if(l > 5)
                    p += 10 - l;
                else 
                    p -= l;
                currAction.position = p
            })
        }

        ActionMarkerComponent
        {
            id: actionMarkerComponent
        }

        PrefireSpaceComponent
        {
            id: prefireSpaceComponent
        }

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
            border.width: frameBorderWidth
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
            font.family: MFXUIS.Fonts.robotoRegular.name
            font.pixelSize: 8
            visible: parent.width > 0
        }

        DropArea
        {
            id: cuePlateDropArea
            anchors.fill: cuePlate

            onDropped:
            {
                let checkedIDs = drag.source.checkedIDs

                let hasAction = false
                checkedIDs.forEach(function(currId)
                {
                    if(project.patchProperty(currId, "act"))
                    {
                        hasAction = true
                        return
                    }
                })

                if(hasAction)
                {
                    checkedIDs.forEach(function(currId)
                    {
                        if(project.patchProperty(currId, "act"))
                        {
                            project.addActionToCue(cuePlate.name, project.patchProperty(currId, "act"), currId, cuePlate.position)
                        }
                    })

                    cuePlate.loadActions()
                }
            }
        }

        MFXUICB.MfxMouseArea
        {
            id: cuePlateMouseArea
            anchors.top: cuePlate.top
            anchors.bottom: cuePlate.bottom
            anchors.left: cuePlate.left
            width: cuePlate.width - 4
            property bool isRightClick: false
            property bool isMovedStop: false
            property  var lastMousePos;
            property var curPos;
            property real curposY;

            drag.threshold: 0
            drag.smoothed: false


            onPressed:
            {
                curPos = mapToItem(cuePlateMouseArea, mouseX, mouseY)
                cueViewFlickable.interactive = false

                cueView.movedPlates = cueView.checkedPlates()

                if(cueView.movedPlates.indexOf(cuePlate) === -1)
                    cueView.movedPlates.push(cuePlate)

                cueView.leftMovedPlate = cueView.movedPlates[0]
                cueView.rightMovedPlate = cueView.movedPlates[0]
                cueView.topMovedPlate = cueView.movedPlates[0]
                cueView.bottomMovedPlate = cueView.movedPlates[0]

                cueView.movedPlates.forEach(function(currCuePlate)
                {
                    currCuePlate.startMovingPosition = currCuePlate.position
                    currCuePlate.startMovingY = currCuePlate.yPosition

                    if(currCuePlate.x < cueView.leftMovedPlate.x)
                        cueView.leftMovedPlate =  currCuePlate

                    if(currCuePlate.x + currCuePlate.width > cueView.rightMovedPlate.x + cueView.rightMovedPlate.width)
                        cueView.rightMovedPlate =  currCuePlate

                    if(currCuePlate.y < cueView.topMovedPlate.y)
                        cueView.topMovedPlate =  currCuePlate

                    if(currCuePlate.y + currCuePlate.height > cueView.rightMovedPlate.y + cueView.rightMovedPlate.heght)
                        cueView.bottomMovedPlate =  currCuePlate
                })
            }

            onClicked:
            {

                if(cueCopy.isCopy){
                    cueView.deleteSelected();
                    cueCopy.isCopy = false;
                }

                isMovedStop = false

                if(mouse.button === Qt.RightButton)
                {
                    cueCopy.popup();
                    cueCopy.x = cuePlate.x
                    parent.checked = true;
                    isRightClick = true
                }

                curPos = mapToItem(cuePlateMouseArea, mouseX, mouseY)
            }

            onDoubleClicked:
            {
                isMovedStop = false
                if(cuePlate.isExpanded)
                    cueView.collapseAll()
                else
                    cueView.expandCuePlate(cuePlate.name)

                cuePlate.checked = true
                curPos = mapToItem(this, mouseX, mouseY)
            }

            onPositionChanged:
            {
                // Перемещение по горизонтали
                let delta = /*pixelsToMsecRounded(xAcc)//*/pixelsToMsec(xAcc)

                if(Math.abs(delta) > 0)
                {
                    xAcc = 0
                    cueCopy.isCopy=false;
                    isMovedStop = true
                    let isFitsLimits = true
                    if((position + delta) <=1){
                        position = 1;
                        //                                if(!isMovedStop){
                        ////                                    cursorManager.saveLastPos();
                        //                                    lastMousePos = cursorManager.cursorPos()
                        //                                    console.log(lastMousePos)
                        //                                    isMovedStop =true;
                        ////                                    cursorManager.saveLastPos()
                        //                                }
                        return;

                    }
                    else if((position + delta + cuePlate.duration) >= playerWidget.projectDuration())
                    {
                        position = Math.round(Math.round((playerWidget.projectDuration()-cuePlate.duration)*10) / 10);
                        //                                if(!isMovedStop){
                        ////                                    cursorManager.saveLastPos();
                        //                                    lastMousePos = cursorManager.cursorPos().x
                        //                                    console.log(lastMousePos)
                        //                                    isMovedStop =true;
                        ////                                    cursorManager.saveLastPos()
                        //                                }
                        return;

                    };

                    //                            if(isMovedStop)
                    //                            {
                    //                                isMovedStop = false;
                    //                                     cursorManager.setCursorPosX(lastMousePos);
                    //                                cursorManager.saveLastPos();
                    //                                return;
                    ////                                cursorManager.moveToLastPos();
                    //                            }



                    cueView.movedPlates.forEach(function(currCuePlate)
                    {
                        if( ! ((currCuePlate.startMovingPosition + delta >= 0) && (currCuePlate.startMovingPosition + delta < playerWidget.projectDuration())))
                        {
                            isFitsLimits = false

                            return
                        }

                        if(((currCuePlate.position + delta) <= 1) || ((currCuePlate.position + delta + currCuePlate.duration) >= playerWidget.projectDuration()))
                        {
                            isFitsLimits = false
                            //                                    console.log(currCuePlate.name)
                            return;
                        }
                    })

                    if(isFitsLimits)
                    {
                        cueView.movedPlates.forEach(function(currCuePlate)
                        {
                            currCuePlate.position += delta

                            currCuePlate.prefiresList.forEach(function(currPrefire)
                            {
                                currPrefire.position += delta
                            })

                            cueView.checkPlatesIntersection()
                        })
                    }
                }

                // Перемещение по вертикали
                let step = cueView.collapsedHeight + cueView.rowMargin
                let stepCount = Math.round(Math.abs(yAcc) / step)

                if(stepCount > 0)
                {
                    step = yAcc > 0 ? step : -step

                    yAcc -= step * stepCount

                    cueView.movePlatesOnY(step * stepCount)
                    cueView.checkPlatesIntersection()
                }

                // Прокрутка по горизонтали

                if(mapToItem(cueViewFlickable, mouseX, mouseY).x < 4)
                {
                    scrollLeftTimer.start()
                }

                else if(mapToItem(cueViewFlickable, mouseX, mouseY).x > cueViewFlickable.width - 4)
                {
                    scrollLeftTimer.stop()
                    scrollRightTimer.start()
                }

                else
                {
                    scrollLeftTimer.stop()
                    scrollRightTimer.stop()
                }

                // Прокрутка по вертикали

                if(cueViewFlickable.height - mapToItem(cueViewFlickable, mouseX, mouseY).y <= step)
                {
                    scrollDownTimer.start()
                }

                else if(mapToItem(cueViewFlickable, mouseX, mouseY).y <= step)
                {
                    scrollDownTimer.stop()
                    scrollUpTimer.start()
                }

                else
                {
                    scrollDownTimer.stop()
                    scrollUpTimer.stop()
                }
            }

            onReleased:
            {
                let p = Math.round(Math.round(position*10)/10);
                let l = p % 10;
                if(l > 5)
                    p += 10 - l;
                else p -= l;
                position = p;
                if(isMovedStop){
                    let pXY = mapToGlobal(cuePlateMouseArea.x+curPos.x,cuePlateMouseArea.y+curPos.y);
                    //                            console.log(pXY);
                    cursorManager.setCursorPosXY(pXY.x,pXY.y)
                    isMovedStop = false;
                }

                //                        cursorManager.setCursorPosX(lastMousePos)
                //                        if(isMovedStop)
                //                        {
                //                            isMovedStop = false;
                //                            console.log(lastMousePos)
                //                                 cursorManager.setCursorPosX(lastMousePos)
                ////                                cursorManager.moveToLastPos();
                //                        }

                if(isRightClick){
                    isRightClick = false;
                    return;
                }

                cueViewFlickable.interactive = true
                scrollDownTimer.stop()
                scrollUpTimer.stop()
                scrollLeftTimer.stop()
                scrollRightTimer.stop()

                if(!wasPressedAndMoved)
                {
                    cuePlate.checked = !cuePlate.checked
                }

                //                        if(cueView.movedPlates.length > 1) // Перетаскиваем несколько плашек
                {
                    if(cueView.movedPlates[0].state === "intersected")
                    {
                        cueView.movedPlates.forEach(function(currCuePlate)
                        {
                            currCuePlate.position = currCuePlate.startMovingPosition
                            currCuePlate.yPosition = currCuePlate.startMovingY
                            currCuePlate.state = ""
                        })
                    }

                    else
                    {
                        cueView.updateHeight()
                        cueView.updatePositions()
                        cueView.movedPlates.forEach(function(currCuePlate)
                        {
                            currCuePlate.moveActions(currCuePlate.position - currCuePlate.startMovingPosition)
                        })
                    }
                }

//                        else // Перетаскиваем одну плашку
//                        {
//                            cueView.updatePositions()
//                        }

                cueView.movedPlates = []
                cueView.updateHeight()
            }

            onWasPressedAndMovedChanged:
            {
                if(wasPressedAndMoved)
                    cueView.collapseAll()
            }
        }

        MFXUICB.MfxMouseArea
        {
            id: cuePlateResizeMouseArea
            width: 4
            anchors.top: cuePlate.top
            anchors.bottom: cuePlate.bottom
            anchors.left: cuePlateMouseArea.right
            allwaysHide: false
            property bool colapsed: false
            property bool isChanged: false

            cursor: Qt.SizeHorCursor

            onPressed: {
                cueViewFlickable.interactive = false

            }

            onMouseXChanged:
            {
                let delta = pixelsToMsec(dx)
                if(cuePlate.duration + delta > 0)
                {
//                            let prevDuration = cuePlate.firstAction.position;
                    cuePlate.actionList.forEach(function(currAction, i)
                    {
                        if(currAction.name === cuePlate.firstAction.name && currAction.patchId === cuePlate.firstAction.patchId)
                        {
                            return // this is first action in cue
                        }
                        let newPosition = currAction.position + delta * currAction.positionCoeff

                        if(newPosition <= cuePlate.firstAction.position) {
                            newPosition = cuePlate.firstAction.position

                            var positionCoeff = cuePlate.actionList.length<1?0:(1/(cuePlate.actionList.length)) * i;
                            project.onSetActionProperty(cuePlate.name, currAction.name, currAction.patchId, "positionCoeff", positionCoeff)
                        }

                        project.onSetActionProperty(cuePlate.name, currAction.name, currAction.patchId, "position", newPosition)
                        cueManager.onSetActionProperty(cuePlate.name, currAction.name, currAction.patchId, newPosition)
                        cuePlate.loadActions();

                    })
                }
            }

            onReleased:
            {
                cuePlate.actionList.forEach(function(currAction, i)
                {
                    if(currAction.name === cuePlate.firstAction.name && currAction.patchId === cuePlate.firstAction.patchId)
                    {
                        return // this is first action in cue
                    }

                    let newPosition = currAction.position;

                    let p = Math.round(Math.round(newPosition*10)/10);
                    let l = p % 10;
                    if(l > 5)
                        p += 10 - l;
                    else
                        p -= l;

                    newPosition = p;

                    project.onSetActionProperty(cuePlate.name, currAction.name, currAction.patchId, "position", newPosition)
                    cueManager.onSetActionProperty(cuePlate.name, currAction.name, currAction.patchId, newPosition)
                    cuePlate.loadActions();
                });

                cueViewFlickable.interactive = true
                project.setCueProperty(cuePlate.name, "duration", cuePlate.duration)
            }
        }
    }
}
import QtQuick 2.15

import MFX.UI.Components.Basic 1.0 as MFXUICB
import MFX.UI.Styles 1.0 as MFXUIS

Component
{
    Item
    {
        id: actionMarker
        height: cueView.expandedHeight
        visible: cuePlate.isExpanded

        x: msecToPixels(position - cuePlate.position)

        property string name: ""
        property string displayedName: ""
        property int patchId
        property double position: 0 // в мсек
        property double prefire: 0 // в мсек
        property double duration: 0  // в мсек
        property double positionCoeff: 0
        function updateCoeff()
        {
            positionCoeff = (position - cuePlate.firstAction.position) / cuePlate.duration
            project.onSetActionProperty(cuePlate.name, name, patchId, "positionCoeff", positionCoeff)
        }

        onPositionChanged:
        {
            project.onSetActionProperty(cuePlate.name, name, patchId, "position", position)
            cueManager.onSetActionProperty(cuePlate.name, name, patchId, position)
        }

        function prefirePosition()
        {
            return position - prefire
        }

        Item
        {
            id: actionStartMarker
            height: 9
            width: 9
            y: cueView.expandedHeight - height

            Image
            {
                width: parent.width
                height: parent.height
                anchors.top: parent.top
                anchors.leftMargin: - parent.width / 2
                anchors.left: parent.left
                source: "qrc:/actionStartMarker"
            }
            
            Rectangle
            {
                color: "white"
                width: 1
                height: cueView.expandedHeight - parent.height - frameBorderWidth
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height
            }
        }

        MFXUICB.MfxMouseArea
        {
            id: actionMarkerMouseArea
            anchors.margins: -4
            anchors.fill: actionStartMarker
            property bool isMoved: false
            onPressed:
            {
                cueViewFlickable.interactive = false
                cuePlate.caption.visible = false
            }

            onMouseXChanged:
            {
                let delta = pixelsToMsecRounded(xAcc)
                if(Math.abs(delta) > 0)
                {
                    isMoved = true;
                    xAcc = 0
                    if((actionMarker.position + delta) >= cuePlate.position && (actionMarker.position + delta) <= (cuePlate.position + cuePlate.duration))
                    {
                        actionMarker.position += delta
                        cuePlate.updatePosition()
                        return
                    }


                }

            }

            onReleased:
            {
                let p = Math.round(Math.round(actionMarker.position*10)/10);
                let l = p % 10;
                if(l > 5)
                    p += 10 - l;
                else p -= l;

                actionMarker.position = p;
                cuePlate.updatePosition()
                if(isMoved)
                {
                    let pXY = mapToGlobal(this.x +actionStartMarker.width, actionStartMarker.childrenRect.y +actionStartMarker.childrenRect.height);
                    cursorManager.setCursorPosXY(pXY.x,pXY.y);
                    isMoved = false;
                }
                cueViewFlickable.interactive = true
                cuePlate.caption.visible = true
                cuePlate.loadActions();
                cuePlate.actionList.forEach(function(currAction, i){
                    currAction.updateCoeff();

                });
            }
        }

        Item
        {
            id: actionPrefireMarker
            height: 9
            width: 9
            x: actionStartMarker.x - msecToPixels(actionMarker.prefire)

            Image
            {
                width: parent.width
                height: parent.height
                anchors.top: parent.top
                anchors.leftMargin: - parent.width / 2
                anchors.left: parent.left
                source: "qrc:/actionPrefireMarker"
            }
        }

        Text
        {
            id: caption
            color: "#ffffff"
            text: actionMarker.displayedName
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideMiddle
            anchors.centerIn: parent
            font.family: MFXUIS.Fonts.robotoRegular.name
            font.pixelSize: 8
            visible: actionMarkerMouseArea.pressed
        }
    }
}
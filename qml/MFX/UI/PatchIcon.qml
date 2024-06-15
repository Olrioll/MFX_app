import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: patchIcon
    width: Math.max(rectId.width, realSizeWidth * backgroundImage.width / project.property("sceneImageWidth"))
    height: Math.max(rectId.height, realSizeHeight * backgroundImage.width / project.property("sceneImageWidth"))
    x: posXRatio * backgroundImage.width
    y: posYRatio * backgroundImage.height

    property int patchId
    property bool checked: false
    property double realSizeWidth: 0.35
    property double realSizeHeight: 0.35
    property string imageFile
    property real posXRatio: project.patchProperty(patchId, "posXRatio")
    property real posYRatio: project.patchProperty(patchId, "posYRatio")
    property double emiterScale: project.property("sceneScaleFactor")

    signal drawOperation(var duration, var angle, var velocity, var active)
    signal changeEmiterScale()

    onDrawOperation:
    {
        particleEmiter.stopAngleBehavior()
        patchIcon.changeEmiterScale()

        var angleChangeFinished = false
        var calcDuration = 0

        if(velocity != 0)
        {
            var min_velocity = 10
            var calcVelocity = velocity < min_velocity ? min_velocity : velocity
            var koef = 2.54 * calcVelocity + 8.55

            calcDuration = Math.abs(angle - particleEmiter.angle) / koef * 1000
            calcDuration = Math.round(calcDuration / 10) * 10

            if(angle == particleEmiter.angle)
                angleChangeFinished = true
        }

        //console.log(duration, calcDuration, angle, particleEmiter.angle, velocity, active)

        particleEmiter.duration = velocity == 0 ? duration : calcDuration
        particleEmiter.angle = angle
        particleEmiter.active = active
        particleEmiter.notifyFinishChangeAngle = velocity != 0

        particleEmiter.startAngleBehavior()

        if( angleChangeFinished )
            deviceManager.finishChangeAngle( patchId, angle )
    }

    onChangeEmiterScale:
    {
        emiterScale = project.property("sceneScaleFactor")
    }

    ParticleEmiter
    {
        id: particleEmiter
        anchors.fill: parent
        transform: Scale { xScale: emiterScale; yScale: emiterScale }
    }

    Rectangle
    {
        anchors.fill: parent
        radius: 4
        color: "#333333"

        border.width: 4
        border.color: patchIcon.checked ? "#27AE60" : "#333333"
    }

    Image
    {
        anchors.margins: 4
        anchors.fill: parent
        source: patchIcon.imageFile
    }

// Плашка с ID
    Rectangle
    {
        id: rectId
        width: 20
        height: 20
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        color: patchIcon.checked ? "#27AE60" : "#828282"
        radius: 4

        Rectangle
        {
            width: 4
            height: 4
            anchors.left: rectId.left
            anchors.top: rectId.top
            color: patchIcon.checked ? "#27AE60" : "#828282"
        }

        Text
        {
            id: patchIdText
            anchors.centerIn: parent
            color: "#ffffff"
            text:  patchIcon.patchId
            font.family: MFXUIS.Fonts.robotoRegular.name
            font.pixelSize: 12
        }
    }

    Rectangle
    {
        width: 4
        height: 4
        anchors.right: rectId.right
        anchors.bottom: rectId.bottom
        color: patchIcon.checked ? "#27AE60" : "#828282"
    }

    Rectangle
    {
        width: 4
        height: 4
        anchors.left: rectId.left
        anchors.bottom: rectId.bottom
        color: patchIcon.checked ? "#27AE60" : "#828282"
        radius: 2
    }

    Connections
    {
        target: project

        function onPatchCheckedChanged(checkedId, checked)
        {
            if(checkedId === patchIcon.patchId)
                patchIcon.checked = checked
        }

        function onChangeEmiterScale()
        {
            patchIcon.changeEmiterScale()
        }
    }

    Connections
    {
        target: deviceManager
        function onDrawOperationInGui(deviceId, duration, angle, velocity, active)
        {
            if(deviceId === patchId)
                patchIcon.drawOperation(duration, angle, velocity, active)
        }
    }
}

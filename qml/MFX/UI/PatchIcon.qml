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
    signal drawOperation(var duration, var angle, var velocity, var active)

    onDrawOperation:
    {
        particleEmiter.stopAngleBehavior()

        var angleChangeFinished = velocity != 0 && angle == particleEmiter.angle
        var calcDuration = velocity == 0 ? 0 : Math.abs(angle - particleEmiter.angle) / (velocity / 19 * 56.8) * 1000

        //console.log(duration, calcDuration, angle, particleEmiter.angle, velocity, active)

        particleEmiter.duration = velocity == 0 ? duration : calcDuration
        particleEmiter.angle = angle
        particleEmiter.active = active
        particleEmiter.notifyFinishChangeAngle = velocity != 0

        particleEmiter.startAngleBehavior()

        if( angleChangeFinished )
            deviceManager.finishChangeAngle( patchId, angle )
    }

    ParticleEmiter
    {
        id: particleEmiter
        anchors.fill: parent
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

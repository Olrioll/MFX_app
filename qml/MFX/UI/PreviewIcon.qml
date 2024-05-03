import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: previewIcon
    width: 30
    height: 30

    property int patchId: -1 // PREVIEW_DEVICE_ID
    property string imageFile: "qrc:/device_sequences"
    signal drawOperation(var duration, var angle, var velocity, var active)

    onDrawOperation:
    {
        //console.log(duration, angle, velocity, active)

        if( velocity != 0 )
        {
            particleEmiter.duration = -1
            particleEmiter.velocity = velocity
        }
        else
        {
            particleEmiter.duration = duration
            particleEmiter.velocity = -1
        }

        var angleChangeFinished = velocity != 0 && angle == particleEmiter.angle

        particleEmiter.angle = angle
        particleEmiter.active = active

        if( angleChangeFinished )
            deviceManager.finishChangeAngle( -1, angle )
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
        border.color: "#333333"
    }

    Image
    {
        anchors.margins: 4
        anchors.fill: parent
        source: imageFile
    }

    Connections
    {
        target: deviceManager
        function onDrawPreviewInGui(duration, angle, velocity, active)
        {
            previewIcon.drawOperation(duration, angle, velocity, active)
        }
    }
}

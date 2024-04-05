import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import QtQuick.Particles 2.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: previewIcon
    width: 30
    height: 30

    property string imageFile: "qrc:/device_sequences"
    signal drawOperation(var duration, var angle, var velocity, var active)
    signal endOfPattern()

    onDrawOperation: {
        //console.log(duration, angle, velocity, active)

        particleEmiter.duration = duration
        particleEmiter.angle = angle
        particleEmiter.active = active
    }

    Item {
        id: particleEmiter

        anchors.fill: parent

        property int duration: 0
        property int angle: 0
        property int velocity: 0
        property bool active: false

        Behavior on angle { SmoothedAnimation { duration: particleEmiter.duration } }

        ParticleSystem {
              id: particleSystem
          }

        ImageParticle {
            source: "qrc:///particleresources/glowdot.png"
            system: particleSystem
            color: '#FFD700'
            colorVariation: 0.2
            rotation: 0
            rotationVariation: 45
            rotationVelocity: 15
            rotationVelocityVariation: 15
            entryEffect: ImageParticle.Fade
        }

        Emitter {
            id: emitter
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: 1;
            height: 1

            system: particleSystem

            enabled: particleEmiter.active

            lifeSpan: 800
            lifeSpanVariation: 200
            emitRate: 800
            size: 16
            sizeVariation: 16

            velocity: AngleDirection {
                angle: -90 + particleEmiter.angle
                angleVariation: 2
                magnitude: 300
                magnitudeVariation: 100
            }
        }
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

    /*Connections
    {
        target: project
        function onPatchCheckedChanged(checkedId, checked)
        {
            if(checkedId === patchIcon.patchId)
                patchIcon.checked = checked
        }
    }*/
    Connections
    {
        target: deviceManager
        function onDrawPreviewInGui(duration, angle, velocity, active)
        {
            //console.log("onDrawPreviewInGui")
            previewIcon.drawOperation(duration, angle, velocity, active)
        }
    }
    /*Connections
    {
        target: deviceManager
        function onEndOfPattern(deviceId) {
            if(deviceId === patchId) {
                patchIcon.endOfPattern()
            }
        }
    }*/
    onEndOfPattern: {
        //console.log("end of pattern")
    }
}

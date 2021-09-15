import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import QtQuick.Particles 2.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: patchIcon
    width: realSizeWidth * backgroundImage.width / project.property("sceneImageWidth")
    height: realSizeHeight * backgroundImage.width / project.property("sceneImageWidth")
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
    signal endOfPattern()

    onDrawOperation: {
        console.log(patchId, duration, angle, velocity, active)

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
            source: "qrc:/images/fire_particle.png"
            system: particleSystem
            color: '#FFD700'
            colorVariation: 0.2
            rotation: 0
            rotationVariation: 45
            rotationVelocity: 15
            rotationVelocityVariation: 15
            entryEffect: ImageParticle.Scale
        }

        Emitter {
            id: emitter
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: 1;
            height: 1

            system: particleSystem

            lifeSpan: 1200
            lifeSpanVariation: 75
            emitRate: 200
            size: 16

            velocity: AngleDirection {
                angle: -90 + particleEmiter.angle
                angleVariation: 10
                magnitude: 50
                magnitudeVariation: 50
            }
        }
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
        id: rect1
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
            anchors.left: rect1.left
            anchors.top: rect1.top
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
        anchors.right: rect1.right
        anchors.bottom: rect1.bottom
        color: patchIcon.checked ? "#27AE60" : "#828282"
    }

    Rectangle
    {
        width: 4
        height: 4
        anchors.left: rect1.left
        anchors.bottom: rect1.bottom
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
        function onDrawOperationInGui(deviceId, duration, angle, velocity, active) {
            if(deviceId === patchId) {
                patchIcon.drawOperation(duration, angle, velocity, active)
            }
        }
    }
    Connections
    {
        target: deviceManager
        function onEndOfPattern(deviceId) {
            if(deviceId === patchId) {
                patchIcon.endOfPattern()
            }
        }
    }
    onEndOfPattern: {
        console.log("end of pattern:", patchId)
    }
}

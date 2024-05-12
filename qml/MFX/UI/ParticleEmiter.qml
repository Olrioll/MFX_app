import QtQuick 2.12
import QtQuick.Particles 2.15

Item
{
    property int duration: 0
    property int angle: -90
    property bool active: false
    property bool notifyFinishChangeAngle: false

    function startAngleBehavior()
    {
        angleBehavior.start()
    }

    function stopAngleBehavior()
    {
        angleBehavior.stop()
    }

    NumberAnimation
    {
        id: angleBehavior
        to: -90 + angle
        target: angleDir
        properties: "angle"
        duration: particleEmiter.duration

        onRunningChanged:
        {
            //console.log('onRunningChanged', running)

            if( !running )
            {
                if( particleEmiter.notifyFinishChangeAngle )
                    deviceManager.finishChangeAngle( patchId, particleEmiter.angle )
            }
        }
    }

    ParticleSystem
    {
        id: particleSystem
    }

    ImageParticle
    {
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

    Emitter
    {
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

        velocity: AngleDirection
        {
            id: angleDir
            angle: -90
            angleVariation: 2
            magnitude: 300
            magnitudeVariation: 100
        }
    }
}
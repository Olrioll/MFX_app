import QtQuick 2.12
import QtQuick.Particles 2.15

Item
{
    property int duration: -1
    property int angle: -90
    property int velocity: -1
    property bool active: false

    Behavior on angle
    {
        SmoothedAnimation
        {
            duration: particleEmiter.duration
            velocity: particleEmiter.velocity == -1 ? -1 : particleEmiter.velocity / 19 * 62.2

            onRunningChanged:
            {
                if( !running && particleEmiter.velocity != -1 )
                    deviceManager.finishChangeAngle( patchId, angle )
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
            angle: -90 + particleEmiter.angle
            angleVariation: 2
            magnitude: 300
            magnitudeVariation: 100
        }
    }
}
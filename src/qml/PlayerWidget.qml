import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import WaveformWidget 1.0
import "qrc:/"

Item
{
    id: playerWidget

    Rectangle
    {
        id: mainBackground
        anchors.fill: parent
        color: "#444444"
        radius: 2
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

        MouseArea
        {
            anchors.fill: parent
            onWheel: (wheel.angleDelta.y > 0) ? waveformWidget.zoomOut()
                                              : waveformWidget.zoomIn()
        }
    }

    MfxButton
    {
        id: stopButton
        width: 16
        height: 16
        color:  "#222222"

        anchors.leftMargin: 4
        anchors.bottomMargin: 4
        anchors.left: parent.left
        anchors.bottom: parent.bottom
    }

}

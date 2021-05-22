import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import WaveformWidget 1.0
import "qrc:/"

Item
{
    id: mainScreen

    property var sceneWidget: null

    function setupSceneWidget(widget)
    {
        sceneWidget = widget

        if(!sceneWidget)
            return

        sceneWidget.parent = this
        sceneWidget.anchors.margins = 2
        sceneWidget.anchors.left = mainScreen.left
        sceneWidget.anchors.right = mainScreen.right
        sceneWidget.anchors.top = mainScreen.top
        sceneWidget.anchors.bottom = waveformWidget.top
    }

    WaveformWidget
    {
        id: waveformWidget
        height: 200
        anchors.margins: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        MouseArea
        {
            anchors.fill: parent
            onWheel: (wheel.angleDelta.y > 0) ? waveformWidget.zoomOut()
                                              : waveformWidget.zoomIn()
        }

        Slider
        {
            id: slider
            anchors.bottom: parent.bottom
        }
    }
}

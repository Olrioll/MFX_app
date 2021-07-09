import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
    id: mainScreen

    property var sceneWidget: null
    property alias playerWidget: playerWidget

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
        sceneWidget.anchors.bottom = playerWidget.top
    }

    Player
    {
        id: playerWidget
        height: minHeight
        anchors.margins: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}

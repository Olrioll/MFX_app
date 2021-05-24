import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

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
        sceneWidget.anchors.bottom = playerWidget.top
    }

    PlayerWidget
    {
        id: playerWidget
        height: 200
        anchors.margins: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        property int minHeight: 200
        property int previousY

        MouseArea
        {
            id: playerResizeArea
            height: 4

            anchors.topMargin: -2
            anchors
            {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            cursorShape: Qt.SizeVerCursor

            onPressed:
            {
                playerWidget.previousY = mouseY
            }

            onMouseYChanged:
            {
                var dy= mouseY - playerWidget.previousY

                if((playerWidget.height - dy) < playerWidget.minHeight)
                    playerWidget.height = playerWidget.minHeight
                else
                    playerWidget.height = playerWidget.height - dy
            }
        }
    }
}

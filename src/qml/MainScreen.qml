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

        sceneWidget.parent = leftPanel
        sceneWidget.anchors.fill = leftPanel
//        sceneWidget.anchors.margins = 2
//        sceneWidget.anchors.left = mainScreen.left
//        sceneWidget.anchors.right = mainScreen.right
//        sceneWidget.anchors.top = mainScreen.top
//        sceneWidget.anchors.bottom = playerWidget.top
    }

    Item
    {
        id: leftPanel
        width: parent.width * 0.67
        anchors.margins: 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: playerWidget.top

        MfxButton
        {
            id: cueContentButton
            checkable: true
            width: 100
            z: 1
            text: qsTr("Cue Content")

            anchors.topMargin: 6
            anchors.rightMargin: 2
            anchors.top: parent.top
            anchors.right: deviceListButton.left
        }

        MfxButton
        {
            id: deviceListButton
            checkable: true
            width: 100
            z: 1
            text: qsTr("Device List")

            anchors.topMargin: 6
            anchors.rightMargin: 6
            anchors.top: parent.top
            anchors.right: parent.right
        }
    }

    MfxMouseArea
    {
        id: panelsResizeArea
        width: 4
        anchors.top: parent.top
        anchors.bottom: playerWidget.top
        anchors.left: leftPanel.right

        property int previousX

        cursor: Qt.SizeHorCursor

        onPressed:
        {
            previousX = mouseX
        }

        onMouseXChanged:
        {
            var dx = mouseX - previousX

            leftPanel.width += dx
        }
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

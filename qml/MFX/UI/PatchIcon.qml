import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

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
    property string patternName
    signal fire()

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
        function onDrawPatternInGui(deviceId, patternName)
        {
            if(deviceId === patchId) {
                patchIcon.patternName = patternName
                patchIcon.fire()
            }
        }
    }
    Rectangle {
        id: fireImage
        anchors {
            fill: parent
            margins: -30
        }
        visible: false
        color: "transparent"
        border {
            width: 3
            color: "red"
        }
        Text {
            anchors {
                top: parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            text: patchIcon.patternName
            color: "white"
            font.pointSize: 10
        }
        Timer {
           id: timer
           interval: 300
           repeat: false
           onTriggered: {
               visible = false
           }
        }
        onVisibleChanged: {
            if(visible) {
                timer.start()
            }
        }
    }
    onFire: {
        fireImage.visible = true
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: patchIcon
    width: realSizeWidth * sceneFrame.width / project.property("sceneWidth")
    height: realSizeHeight * sceneFrame.width / project.property("sceneWidth")
    x: sceneFrame.x + posXRatio * sceneFrame.width
    y: sceneFrame.y + posYRatio * sceneFrame.height

    property int patchId
    property bool checked: false
    property double realSizeWidth: 0.35
    property double realSizeHeight: 0.35
    property string imageFile
    property real posXRatio: project.patchProperty(patchId, "posXRatio")
    property real posYRatio: project.patchProperty(patchId, "posYRatio")

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
            font.family: "Roboto"
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

//-------------------------

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent

        drag.target: patchIcon
        drag.axis: Drag.XandYAxis

        drag.minimumX: sceneWidget.mapToItem(sceneImage, 0, 0).x
        drag.maximumX: sceneImage.contentWidth - patchIcon.width
        drag.minimumY: sceneWidget.mapToItem(sceneImage, 0, 0).y + 10
        drag.maximumY: sceneImage.contentHeight - patchIcon.height

        onClicked:
        {
            patchIcon.checked = !patchIcon.checked
        }

        onReleased:
        {
            patchIcon.posXRatio = (patchIcon.x - sceneFrame.x) / sceneFrame.width
            patchIcon.posYRatio = (patchIcon.y - sceneFrame.y) / sceneFrame.height

            project.setPatchProperty(patchId, "posXRatio", patchIcon.posXRatio)
            project.setPatchProperty(patchId, "posYRatio", patchIcon.posYRatio)
        }
    }
}

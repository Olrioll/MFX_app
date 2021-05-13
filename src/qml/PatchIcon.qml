import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: patchIcon
    width: realSizeWidth * backgroundImage.width / project.property("sceneImageWidth")
    height: realSizeHeight * backgroundImage.width / project.property("sceneImageWidth")
    x: backgroundImage.x + posXRatio * backgroundImage.width
    y: backgroundImage.y + posYRatio * backgroundImage.height

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

        drag.minimumX: sceneWidget.mapToItem(sceneWidget, 0, 0).x
        drag.maximumX: sceneWidget.width - patchIcon.width
        drag.minimumY: sceneWidget.mapToItem(sceneWidget, 0, 0).y
        drag.maximumY: sceneWidget.height - patchIcon.height

        onClicked:
        {
            project.setPatchProperty(patchId, "checked", !project.patchProperty(patchId, "checked"))
        }

        onReleased:
        {
            patchIcon.posXRatio = (patchIcon.x - backgroundImage.x) / backgroundImage.width
            patchIcon.posYRatio = (patchIcon.y - backgroundImage.y) / backgroundImage.height

            project.setPatchProperty(patchId, "posXRatio", patchIcon.posXRatio)
            project.setPatchProperty(patchId, "posYRatio", patchIcon.posYRatio)
        }
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
}

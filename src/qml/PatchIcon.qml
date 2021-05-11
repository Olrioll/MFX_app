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
    }

    Image
    {
        anchors.fill: parent
        source: patchIcon.imageFile
    }

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

        onReleased:
        {
            patchIcon.posXRatio = (patchIcon.x - sceneFrame.x) / sceneFrame.width
            patchIcon.posYRatio = (patchIcon.y - sceneFrame.y) / sceneFrame.height

            project.setPatchProperty(patchId, "posXRatio", patchIcon.posXRatio)
            project.setPatchProperty(patchId, "posYRatio", patchIcon.posYRatio)
        }
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: utilityWindow
    width: 220
    height: 300

    property string caption

    function setMoveArea(x, width, y, height)
    {
        mouseArea.drag.minimumX = x
        mouseArea.drag.minimumY = y
        mouseArea.drag.maximumX = width - utilityWindow.width
        mouseArea.drag.maximumY = height - utilityWindow.height
    }

    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        radius: 2
        color: "#444444"

        MouseArea
        {
            id: mouseArea
            height: 28
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            drag.target: utilityWindow
            drag.axis: Drag.XandYAxis
//            drag.minimumX: 0
//            drag.maximumX: appWindowMoveArea.width - utilityWindow.width
//            drag.minimumY: 0
//            drag.maximumY: appWindowMoveArea.height - utilityWindow.height
        }

        Text
        {
            color: "#ffffff"
            text: utilityWindow.caption
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: "Roboto"
            topPadding: 4
        }

        Button
        {
            id: closeButton
            width: 25
            height: 25
            anchors.right: parent.right

            bottomPadding: 0
            topPadding: 0
            rightPadding: 0
            leftPadding: 0

            background: Rectangle {
                    color: "#444444"
                    opacity: 0
                }

            Image
            {
                source: "qrc:/utilityCloseButton"
            }

            onClicked: utilityWindow.visible = false
        }
    }
}

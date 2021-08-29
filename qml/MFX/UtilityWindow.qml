import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: utilityWindow
    width: 220
    height: 300

    property string caption
    property var contentItem

    function addContentItem(itemFilename)
    {
        contentItem = Qt.createComponent(itemFilename).createObject(workArea)
        contentItem.onCanBeDestroyed.connect(function(){utilityWindow.destroy()})
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

            drag.minimumX: applicationWindow.childWidgetsArea().x
            drag.maximumX: applicationWindow.childWidgetsArea().width - utilityWindow.width
            drag.minimumY: applicationWindow.childWidgetsArea().y
            drag.maximumY: applicationWindow.childWidgetsArea().height - utilityWindow.height
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
            topPadding: 8
        }

        Button
        {
            id: closeButton
            width: 25
            height: 25
            anchors.top: parent.top
            anchors.topMargin: 3
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

            onClicked: utilityWindow.destroy()
        }

        Rectangle
        {
            id: workArea
            anchors.topMargin: 28
            anchors.bottomMargin: 2
            anchors.leftMargin: 2
            anchors.rightMargin: 2
            anchors.fill: parent

            color: "#222222"
        }
    }
}

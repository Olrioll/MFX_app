import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: dialog
    width: 220
    height: 200

    property string caption
    property string dialogText
    property string acceptButtonText: qsTr("Confirm")
    property string cancelButtonText: qsTr("cancel")
    property string acceptButtonColor: "#4f4f4f"
    property string cancelButtonColor: "#4f4f4f"

    signal accepted
    signal declined

    Rectangle
    {
        id: blockingMouseInput
        color: "black"
        opacity: 0.5
        x: -dialog.x
        y: -dialog.y
        width: applicationWindow.width
        height: applicationWindow.height

        MouseArea
        {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        }
    }

    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        radius: 2
        color: "#444444"

        Text
        {
            color: "#ffffff"
            text: dialog.caption
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: "Roboto"
            topPadding: 8
        }

        MouseArea
        {
            id: mouseArea
            height: 28
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            drag.target: dialog
            drag.axis: Drag.XandYAxis

            drag.minimumX: applicationWindow.childWidgetsArea().x
            drag.maximumX: applicationWindow.childWidgetsArea().width - dialog.width
            drag.minimumY: applicationWindow.childWidgetsArea().y
            drag.maximumY: applicationWindow.childWidgetsArea().height - dialog.height
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

            onClicked: dialog.destroy()
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

            Text
            {
                color: "#ffffff"
                text: dialog.dialogText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideMiddle
                anchors.left: parent.left
                anchors.right: parent.right
                font.family: "Roboto"
                font.pixelSize: 12
                topPadding: 20
            }

            MfxButton
            {
                id: acceptButton
                text: dialog.acceptButtonText
                color: acceptButtonColor
                width: (workArea.width - 3 * anchors.margins) / 2
                anchors.margins: 2
                anchors.left: parent.left
                anchors.bottom: parent.bottom

                onClicked:
                {
                    accepted()
                    dialog.destroy()
                }
            }

            MfxButton
            {
                id: cancelButton
                text: dialog.cancelButtonText
                color: cancelButtonColor
                anchors.margins: 2
                anchors.left: acceptButton.right
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                onClicked:
                {
                    declined()
                    dialog.destroy()
                }
            }
        }
    }
}


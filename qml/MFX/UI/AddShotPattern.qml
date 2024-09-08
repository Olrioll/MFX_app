import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: addShotPatternWidget
    width: 324
    height: 304

    property string acceptButtonText: qsTr("Confirm")
    property string cancelButtonText: qsTr("Cancel")
    property string acceptButtonColor: "#4f4f4f"
    property string cancelButtonColor: "#4f4f4f"

    signal accepted
    signal declined

    Rectangle
    {
        id: blockingMouseInput
        color: "black"
        opacity: 0.5
        x: -addShotPatternWidget.x
        y: -addShotPatternWidget.y
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
            text: "Add shot pattern"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: MFXUIS.Fonts.robotoRegular.name
            topPadding: 8
        }

        MouseArea
        {
            id: mouseArea
            height: 28
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            drag.target: addShotPatternWidget
            drag.axis: Drag.XandYAxis

            drag.minimumX: applicationWindow.childWidgetsArea().x
            drag.maximumX: applicationWindow.childWidgetsArea().width - addShotPatternWidget.width
            drag.minimumY: applicationWindow.childWidgetsArea().y
            drag.maximumY: applicationWindow.childWidgetsArea().height - addShotPatternWidget.height
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

            onClicked:
            {
                applicationWindow.contentItem.focus = true
                addShotPatternWidget.destroy()
            }
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

            //Text
            //{
            //    anchors.left: parent.left
            //    anchors.right: parent.right
            //    anchors.margins: 8
            //    anchors.top: parent.top
            //    anchors.bottom: acceptButton.top
            //    color: "#ffffff"
            //    text: translationsManager.translationTrigger + addShotPatternWidget.dialogText
            //    horizontalAlignment: Text.AlignHCenter
            //    verticalAlignment: Text.AlignVCenter
            //    elide: Text.ElideNone
            //    wrapMode: Text.WordWrap
            //    font.family: MFXUIS.Fonts.robotoRegular.name
            //    font.pixelSize: 12
            //    topPadding: 20
            //}

            MfxButton
            {
                id: acceptButton
                text: translationsManager.translationTrigger + addShotPatternWidget.acceptButtonText
                color: acceptButtonColor
                width: (workArea.width - 3 * anchors.margins) / 2
                anchors.margins: 2
                anchors.left: parent.left
                anchors.bottom: parent.bottom

                onClicked:
                {
                    applicationWindow.contentItem.focus = true
                    accepted()
                    addShotPatternWidget.destroy()
                }
            }

            MfxButton
            {
                id: cancelButton
                text: addShotPatternWidget.cancelButtonText
                color: cancelButtonColor
                anchors.margins: 2
                anchors.left: acceptButton.right
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                onClicked:
                {
                    applicationWindow.contentItem.focus = true
                    declined()
                    addShotPatternWidget.destroy()
                }
            }
        }
    }
}
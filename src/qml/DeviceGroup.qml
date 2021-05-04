import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: deviceGroup
    height: collapseButton.checked ? collapseButton.height + deviceList.contentItem.height + 20 : collapseButton.height
    property string name
    property bool checked
    signal groupNameClicked

    Button
    {
        id: collapseButton
        width: 15
        height: 15
        checkable: true

        bottomPadding: 0
        topPadding: 0
        rightPadding: 0
        leftPadding: 0

        background: Rectangle {
            color: "#444444"
            radius: 2
        }

        contentItem: Text {
            color: "#ffffff"
            text: parent.checked ? "-" : "+"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.family: "Roboto"
            font.pixelSize: 14
        }
    }

    Rectangle
    {
        color: parent.checked ? "#444444" : "#000000"
        radius: 2
        anchors.leftMargin: 10
        anchors.left: collapseButton.right
        height: collapseButton.height
        width: groupNameText.width + 4

        Text
        {
            id: groupNameText
            color: "#ffffff"
            text: deviceGroup.name
            anchors.leftMargin: 2
            anchors.left: parent.left
            horizontalAlignment: Text.AlignHLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.family: "Roboto"
            font.pixelSize: 12


        }

        MouseArea
        {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked:
            {
                if (mouse.button === Qt.LeftButton)
                {
                    project.setCurrentGroup(deviceGroup.name)
                }

                else if (mouse.button === Qt.RightButton)
                    contextMenu.popup()
            }

            Menu
            {
                id: contextMenu
                MenuItem { text: "Cut" }
                MenuItem { text: "Copy" }
                MenuItem { text: "Paste" }
            }
        }
    }



    Item
    {
        id: listArea
        visible: collapseButton.checked
        x: 18
        y: 30
        width: 360
        height: deviceList.contentItem.height + 10

        DeviceListWidget
        {
            id: deviceList
            anchors.fill: parent
        }
    }    
}

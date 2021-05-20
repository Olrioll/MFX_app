import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: typeGroup
    height: collapseButton.checked ? collapseButton.height + deviceList.contentItem.height + 20 : collapseButton.height
    property string name
    property alias deviceList: deviceList
    property bool isExpanded: collapseButton.checked

    signal viewChanged

    Button
    {
        id: collapseButton
        width: 16
        height: 16
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

        onCheckedChanged:
        {
            isExpanded = checked
            viewChanged()
        }
    }

    Rectangle
    {
        color: "#000000"
        radius: 2
        anchors.leftMargin: 10
        anchors.left: collapseButton.right
        height: collapseButton.height
        width: groupNameText.width + 4

        Text
        {
            id: groupNameText
            color: "#ffffff"
            text: typeGroup.name
            anchors.leftMargin: 2
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.family: "Roboto"
            font.pixelSize: 12

            DropArea
            {
                anchors.fill: parent

                onDropped:
                {
                    collapseButton.checked = true

                    if (drag.source.name === "Sequences")
                    {
                        var addSequWindow = Qt.createComponent("AddSequencesWidget.qml").createObject(applicationWindow, {groupName: typeGroup.name});
                        addSequWindow.x = applicationWindow.width / 2 - addSequWindow.width / 2
                        addSequWindow.y = applicationWindow.height / 2 - addSequWindow.height / 2
                    }

                    else if (drag.source.name === "Dimmer")
                    {
                        var addDimmerWindow = Qt.createComponent("AddDimmerWidget.qml").createObject(applicationWindow, {groupName: typeGroup.name});
                        addDimmerWindow.x = applicationWindow.width / 2 - addDimmerWindow.width / 2
                        addDimmerWindow.y = applicationWindow.height / 2 - addDimmerWindow.height / 2
                    }

                    else if (drag.source.name === "Shot")
                    {
                        var addShotWindow = Qt.createComponent("AddShotWidget.qml").createObject(applicationWindow, {groupName: typeGroup.name});
                        addShotWindow.x = applicationWindow.width / 2 - addShotWindow.width / 2
                        addShotWindow.y = applicationWindow.height / 2 - addShotWindow.height / 2
                    }

                    else if (drag.source.name === "Pyro")
                    {
                        var addPyroWindow = Qt.createComponent("AddPyroWidget.qml").createObject(applicationWindow, {groupName: typeGroup.name});
                        addPyroWindow.x = applicationWindow.width / 2 - addPyroWindow.width / 2
                        addPyroWindow.y = applicationWindow.height / 2 - addPyroWindow.height / 2
                    }
                }
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

        SortedDeviceListWidget
        {
            id: deviceList
            groupName: typeGroup.name
        }
    }
}


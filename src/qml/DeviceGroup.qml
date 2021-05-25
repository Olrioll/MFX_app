import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: deviceGroup
    height: collapseButton.checked ? collapseButton.height + deviceList.contentItem.height + 20 : collapseButton.height

    property string name
    property bool checked: name === project.currentGroup() ? true : false
    property alias deviceList: deviceList
    property bool isExpanded: collapseButton.checked

    signal groupNameClicked
    signal viewChanged

    Rectangle
    {
        id: groupBackground
//        x: parent.x
//        y: parent.y
        anchors.left: parent.left
        anchors.topMargin: -2
        anchors.top: parent.top
        height: parent.height + 2
        width: parent.parent.width
        color: deviceGroup.checked ? "#42FF55" : "transparent"
        opacity:  0.1
        radius: 2

    }

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

        onClicked: project.setCurrentGroup(deviceGroup.name)

        onCheckedChanged:
        {
            isExpanded = checked
            viewChanged()
        }
    }

    Rectangle
    {
        color: "transparent"
        radius: 2
        anchors.leftMargin: 10
        anchors.left: collapseButton.right
        height: collapseButton.height
        width: parent.parent.width

        Text
        {
            id: groupNameText
            color: "#ffffff"
            text: deviceGroup.name
            anchors.leftMargin: 2
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.family: "Roboto"
            font.pixelSize: 12
            font.bold: deviceGroup.checked
        }

        DropArea
        {
            anchors.fill: parent

            onEntered: groupNameText.color = "#EB5757"
            onExited: groupNameText.color = "#ffffff"

            onDropped:
            {
                groupNameText.color = "#ffffff"
                project.setCurrentGroup(deviceGroup.name)
                collapseButton.checked = true

                if (drag.source.name === "Sequences")
                {
                    var addSequWindow = Qt.createComponent("AddSequencesWidget.qml").createObject(applicationWindow, {groupName: deviceGroup.name});
                    addSequWindow.x = applicationWindow.width / 2 - addSequWindow.width / 2
                    addSequWindow.y = applicationWindow.height / 2 - addSequWindow.height / 2
                }

                else if (drag.source.name === "Dimmer")
                {
                    var addDimmerWindow = Qt.createComponent("AddDimmerWidget.qml").createObject(applicationWindow, {groupName: deviceGroup.name});
                    addDimmerWindow.x = applicationWindow.width / 2 - addDimmerWindow.width / 2
                    addDimmerWindow.y = applicationWindow.height / 2 - addDimmerWindow.height / 2
                }

                else if (drag.source.name === "Shot")
                {
                    var addShotWindow = Qt.createComponent("AddShotWidget.qml").createObject(applicationWindow, {groupName: deviceGroup.name});
                    addShotWindow.x = applicationWindow.width / 2 - addShotWindow.width / 2
                    addShotWindow.y = applicationWindow.height / 2 - addShotWindow.height / 2
                }

                else if (drag.source.name === "Pyro")
                {
                    var addPyroWindow = Qt.createComponent("AddPyroWidget.qml").createObject(applicationWindow, {groupName: deviceGroup.name});
                    addPyroWindow.x = applicationWindow.width / 2 - addPyroWindow.width / 2
                    addPyroWindow.y = applicationWindow.height / 2 - addPyroWindow.height / 2
                }

                else if(drag.source.name === "Patch Plate")
                {
                    project.addPatchesToGroup(deviceGroup.name, drag.source.checkedIDs)
                }
            }
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
                {
                    project.setCurrentGroup(deviceGroup.name)
                    contextMenu.popup()
                }
            }

            Menu
            {
                id: contextMenu
                Action
                {
                    text: qsTr("Rename group")
                    onTriggered:
                    {
                        var renameGroupWindow = Qt.createComponent("UtilityWindow.qml").createObject(applicationWindow);
                        renameGroupWindow.addContentItem("RenameGroupWindow.qml");
                        renameGroupWindow.x = applicationWindow.width / 2 - renameGroupWindow.width / 2
                        renameGroupWindow.y = applicationWindow.height / 2 - renameGroupWindow.height / 2
                        renameGroupWindow.caption = qsTr("Rename group")
                    }

                }
                Action
                {
                    text: qsTr("Delete group")
                    onTriggered: project.removeGroup(deviceGroup.name)
                }

                delegate: MenuItem
                {
                    id: menuItem
                    width: 150
                    height: 30

                    contentItem: Text {
                                 text: menuItem.text
                                 font: menuItem.font
                                 color: "#ffffff"
                                 horizontalAlignment: Text.AlignLeft
                                 verticalAlignment: Text.AlignVCenter
                                 elide: Text.ElideRight
                             }

                    background: Rectangle {
                                 implicitWidth: 150
                                 implicitHeight: 30
                                 color: menuItem.highlighted ? "#333333" : "transparent"
                             }
                }

                background: Rectangle {
                             implicitWidth: 150
                             implicitHeight: 30
                             radius: 2
                             color: "#222222"
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

        DeviceListWidget
        {
            id: deviceList
            groupName: deviceGroup.name
        }
    }
}

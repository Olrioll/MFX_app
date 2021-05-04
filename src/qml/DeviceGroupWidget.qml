import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
    anchors.margins: 2
    anchors.fill: parent
    ListView
    {
        id: groupListView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: 10
        anchors.bottom: addGroupButton.top
        clip: true
        spacing: 10
        ScrollBar.vertical: ScrollBar {}

        delegate: DeviceGroup
        {
            name: groupName
        }

        function addGroup(name)
        {
            if(project.addGroup(name))
                groupListModel.append({groupName: name})
        }

        function loadGroups()
        {
            groupListModel.clear()
            project.groupNames().forEach(function(item, i, arr)
            {
                groupListModel.append({groupName: item})
            })
        }

        model: ListModel
        {
            id: groupListModel
        }

        Component.onCompleted:
        {
            loadGroups();
        }

        //    DropArea
        //    {
        //        id: groupListWidgetDropArea
        //        anchors.fill: parent

        //        onDropped:
        //        {
        //            var dropToIndex = deviceListView.indexAt(drag.x, drag.y)

        //            if(drag.source.name === "Patch Plate")
        //            {
        //                if(dropToIndex !== -1)
        //                {
        //                    deviceListModel.move(drag.source.no - 1, dropToIndex, 1)
        //                    refreshPlatesNo()
        //                }
        //            }

        //            else if (drag.source.name === "Sequences")
        //            {
        //                addSequencesPlate(dropToIndex)
        //                refreshPlatesNo()
        //            }

        //            else if (drag.source.name === "Dimmer")
        //            {
        //                addDimmerPlate(dropToIndex)
        //                refreshPlatesNo()
        //            }

        //            else if (drag.source.name === "Shot")
        //            {
        //                addShotPlate(dropToIndex)
        //                refreshPlatesNo()
        //            }

        //            else if (drag.source.name === "Pyro")
        //            {
        //                addPyroPlate(dropToIndex)
        //                refreshPlatesNo()
        //            }
        //        }
        //    }
    }

    Button
    {
        id: addGroupButton
        text: qsTr("Add Group")
        height: 24
        width: (parent.width - anchors.margins * 4) / 3

        anchors.margins: 2
        anchors.left: parent.left
        anchors.bottom: parent.bottom


        bottomPadding: 2
        topPadding: 2
        rightPadding: 2
        leftPadding: 2

        background: Rectangle
        {
            color:
            {
                if(parent.enabled)
                    parent.pressed ? "#222222" : "#27AE60"
                else
                    "#444444"
            }
            radius: 2
        }

        contentItem: Text
        {
            color: parent.enabled ? "#ffffff" : "#777777"
            text: parent.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.family: "Roboto"
        }

        onClicked:
        {
            var addGroupWindow = Qt.createComponent("UtilityWindow.qml").createObject(applicationWindow);
            addGroupWindow.x = applicationWindow.width / 2 - addGroupWindow.width / 2
            addGroupWindow.y = applicationWindow.height / 2 - addGroupWindow.height / 2
            addGroupWindow.caption = qsTr("New group")
        }
    }

    Button
    {
        id: editButton
        text: qsTr("Edit")
        height: 24
        width: (parent.width - anchors.margins * 4) / 3

        anchors.margins: 2
        anchors.left: addGroupButton.right
        anchors.bottom: parent.bottom


        bottomPadding: 2
        topPadding: 2
        rightPadding: 2
        leftPadding: 2

        background: Rectangle
        {
            color: parent.pressed ? "#222222" : "#2F80ED"
            radius: 2
        }

        contentItem: Text
        {
            color: "#ffffff"
            text: parent.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.family: "Roboto"
        }
    }

    Button
    {
        id: deleteButton
        text: qsTr("Delete selected")
        height: 24
        width: (parent.width - anchors.margins * 4) / 3

        anchors.margins: 2
        anchors.left: editButton.right
        anchors.bottom: parent.bottom


        bottomPadding: 2
        topPadding: 2
        rightPadding: 2
        leftPadding: 2

        background: Rectangle
        {
            color: parent.pressed ? "#222222" : "#EB5757"
            radius: 2
        }

        contentItem: Text
        {
            color: "#ffffff"
            text: parent.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.family: "Roboto"
        }
    }

    Connections
    {
        target: project
        function onCurrentGroupIndexChanged(index)
        {
            groupListView.itemAtIndex(groupListView.currentIndex).checked = false
            groupListView.currentIndex = index
            groupListView.itemAtIndex(groupListView.currentIndex).checked = true
        }
    }

    Connections
    {
        target: project
        function onGroupChanged(index)
        {
            groupListView.loadGroups();
        }
    }
}

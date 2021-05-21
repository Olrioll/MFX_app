import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
//    anchors.margins: 2
//    anchors.fill: parent
    width: groupListView.width + 10

    ListView
    {
        id: groupListView
        width: widthNeeded()
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottomMargin: 10
        anchors.bottom: addGroupButton.top
//        clip: true
        spacing: 10

        ScrollBar.vertical: ScrollBar
        {
            anchors
            {
                right: groupListView.right
                top: groupListView.top
                bottom: groupListView.bottom
                rightMargin: -3
            }
        }

        function widthNeeded()
        {

            for(let i = 0; i < groupListView.count; i++)
            {
                if(groupListView.itemAtIndex(i).isExpanded)
                    return 420
            }

            return 200
        }

        delegate: DeviceGroup
        {
            id: deviceGroup
            name: groupName
            Connections
            {
                target: deviceGroup
                function onViewChanged()
                {
                    groupListView.width = groupListView.widthNeeded()
                }
            }
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
    }

    Rectangle
    {
        id: buttonsBackground
        height: 34
        width: parent.width
        anchors.left: parent.left
        anchors.bottomMargin: -2
        anchors.bottom: parent.bottom
        color: "#000000"
    }

    Button
    {
        id: addGroupButton
        text: qsTr("Add Group")
        height: 24
        width: (parent.width) / 3 - 4

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
            addGroupWindow.addContentItem("AddGroupWindow.qml");
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
        width: addGroupButton.width

        anchors.leftMargin: 2
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

        onClicked:
        {
            for(let i = 0; i < groupListView.count; i++)
            {
                if(groupListView.itemAtIndex(i).name === project.currentGroup())
                {
                    groupListView.itemAtIndex(i).deviceList.openEditWindow()
                    break;
                }
            }
        }
    }

    Button
    {
        id: deleteButton
        text: qsTr("Delete selected")
        height: 24
        width: editButton.width

        anchors.leftMargin: 2
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

        onClicked:
        {
            groupListView.itemAtIndex(groupListView.currentIndex).deviceList.deleteSelected()
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
        function onGroupCountChanged()
        {
            groupListView.loadGroups();
        }
    }
}

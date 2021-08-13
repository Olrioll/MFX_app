import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import "qrc:/"

Item
{
    id: deviceGroupWidget
    width: groupListView.width + 10

    property bool patchScreenMode: true
    property bool dropAreaAvaliable: true

    ListView
    {
        id: groupListView
        width: widthNeeded()
        anchors.topMargin: 2
        anchors.leftMargin: 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottomMargin: 10
        anchors.bottom: patchScreenMode ? addGroupButton.top : parent.bottom
        spacing: 10

        property bool dropAreaAvaliable: deviceGroupWidget.dropAreaAvaliable

        ScrollBar.vertical: ScrollBar
        {
            policy: ScrollBar.AsNeeded
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
            dropAreaAvaliable: dropAreaAval

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
                groupListModel.append({groupName: name, dropAreaAval: groupListView.dropAreaAvaliable})
        }

        function loadGroups()
        {
            groupListModel.clear()
            project.groupNames().forEach(function(item, i, arr)
            {
                groupListModel.append({groupName: item, dropAreaAval: groupListView.dropAreaAvaliable})
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

    Item
    {
        id: buttonsBackground
        height: 40
        width: parent.width
        anchors.left: parent.left
        anchors.bottomMargin: parent.patchScreenMode ? -2 : -16
        anchors.bottom: parent.bottom

        LinearGradient
        {
            anchors.fill: parent
            start: Qt.point(0, parent.height / 3)
            end: Qt.point(0, 0)
            gradient: Gradient
            {
                GradientStop { position: 1.0; color: "#00000000" }
                GradientStop { position: 0.0; color: "#FF000000" }
            }
        }
    }

    MfxHilightedButton
    {
        id: addGroupButton
        text: width > 70 ? qsTr("Add Group") : qsTr("Add")
        width: (parent.width) / 3 - 4
        color: "#27AE60"
        visible: parent.patchScreenMode

        anchors.left: parent.left
        anchors.bottom: parent.bottom

        onClicked:
        {
            var addGroupWindow = Qt.createComponent("UtilityWindow.qml").createObject(applicationWindow);
            addGroupWindow.addContentItem("AddGroupWindow.qml");
            addGroupWindow.x = applicationWindow.width / 2 - addGroupWindow.width / 2
            addGroupWindow.y = applicationWindow.height / 2 - addGroupWindow.height / 2
            addGroupWindow.caption = qsTr("New group")
        }
    }


    MfxHilightedButton
    {
        id: editButton
        text: qsTr("Edit")
        width: addGroupButton.width
        color: "#2F80ED"
        visible: parent.patchScreenMode

        anchors.leftMargin: 2
        anchors.left: addGroupButton.right
        anchors.bottom: parent.bottom

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

    MfxHilightedButton
    {
        id: deleteButton
        text: width > 70 ? qsTr("Delete selected") : qsTr("Delete")
        width: editButton.width
        color: "#EB5757"
        visible: parent.patchScreenMode

        anchors.leftMargin: 2
        anchors.left: editButton.right
        anchors.bottom: parent.bottom

        onClicked:
        {
            groupListView.itemAtIndex(groupListView.currentIndex).deviceList.deleteSelected()
        }
    }

    Connections
    {
        target: project
        function onCurrentGroupChanged(groupName)
        {
            groupListView.itemAtIndex(groupListView.currentIndex).checked = false

            for(let i = 0; i < groupListView.count; i++)
            {
                if(groupListView.itemAtIndex(i).name === groupName)
                {
                    groupListView.currentIndex = i
                    break
                }
            }

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

    Connections
    {
        target: project
        function onGroupChanged()
        {
            groupListView.loadGroups();
        }
    }
}

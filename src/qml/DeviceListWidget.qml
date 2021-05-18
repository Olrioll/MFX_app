import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

ListView
{
    id: deviceListView
    anchors.margins: 2
    anchors.top: parent.top
    anchors.left: parent.left
    width: 392
    height: contentItem.height < 10 ? contentItem.height + 30 : contentItem.height
    clip: true
    spacing: 2
    ScrollBar.vertical: ScrollBar {}

    property string groupName: ""

    function loadDeviceList()
    {
        deviceListModel.clear()
        var patchesList = project.patchesIdList(groupName)

        for(let i = 0; i < patchesList.length; i++)
        {
            deviceListModel.insert(i, {counter: i + 1, currentId: patchesList[i]})
        }
    }



    function refreshPlatesNo()
    {
        for(let i = 0; i < deviceListModel.count; i++)
        {
            deviceListModel.get(i).counter = i + 1
        }
    }

    function deleteSelected()
    {
        var removedIDs = []
        for(let i = 0; i < deviceListView.count; i++)
        {
            if(deviceListView.itemAtIndex(i).checked)
            {
                removedIDs.push(deviceListView.itemAtIndex(i).patchId)
            }
        }

        project.removePatchesFromGroup(groupName, removedIDs)
    }

    function openEditWindow()
    {
        let editedList = []

        let prevType = ""
        for(let i = 0; i < deviceListView.count; i++)
        {
            if(deviceListView.itemAtIndex(i).checked)
            {
                if(prevType === "" || deviceListView.itemAtIndex(i).type === prevType)
                {
                    editedList.push(deviceListView.itemAtIndex(i).getId())
                    prevType = deviceListView.itemAtIndex(i).type
                }

                else
                    return;
            }
        }

        if(editedList.length)
        {
            if(prevType === "Sequences")
            {
                var addSequWindow = Qt.createComponent("AddSequencesWidget.qml").createObject(applicationWindow, {isEditMode: true, changedIdList: editedList});
                addSequWindow.x = applicationWindow.width / 2 - addSequWindow.width / 2
                addSequWindow.y = applicationWindow.height / 2 - addSequWindow.height / 2
            }

            else if(prevType === "Shot")
            {
                var addShotWindow = Qt.createComponent("AddShotWidget.qml").createObject(applicationWindow, {isEditMode: true, changedIdList: editedList});
                addShotWindow.x = applicationWindow.width / 2 - addShotWindow.width / 2
                addShotWindow.y = applicationWindow.height / 2 - addShotWindow.height / 2
            }

            else if(prevType === "Dimmer")
            {
                var addDimmerWindow = Qt.createComponent("AddDimmerWidget.qml").createObject(applicationWindow, {isEditMode: true, changedIdList: editedList});
                addDimmerWindow.x = applicationWindow.width / 2 - addDimmerWindow.width / 2
                addDimmerWindow.y = applicationWindow.height / 2 - addDimmerWindow.height / 2
            }

            else if(prevType === "Pyro")
            {
                var addPyroWindow = Qt.createComponent("AddPyroWidget.qml").createObject(applicationWindow, {isEditMode: true, changedIdList: editedList});
                addPyroWindow.x = applicationWindow.width / 2 - addPyroWindow.width / 2
                addPyroWindow.y = applicationWindow.height / 2 - addPyroWindow.height / 2
            }
        }
    }

    delegate: PatchPlate
    {
        no: counter
        patchId: currentId
        parentList: deviceListView
    }

    model: ListModel
    {
        id: deviceListModel
    }

    DropArea
    {
        id: deviceListWidgetDropArea
        anchors.fill: parent

        property var currPlate: null

        onEntered:
        {
            if(deviceListView.itemAt(drag.x, drag.y))
            {
                currPlate = deviceListView.itemAt(drag.x, drag.y)
                currPlate.withBorder = true
            }
        }

        onExited:
        {
            if(currPlate)
                currPlate.withBorder = false
        }

        onPositionChanged:
        {
            if(deviceListView.itemAt(drag.x, drag.y) !== currPlate)
            {
                if(currPlate)
                    currPlate.withBorder = false

                currPlate = deviceListView.itemAt(drag.x, drag.y)

                if(currPlate)
                    currPlate.withBorder = true
            }
        }

        onDropped:
        {
            project.setCurrentGroup(deviceListView.groupName)

            var dropToIndex = deviceListView.indexAt(drag.x, drag.y)

            if(drag.source.name === "Patch Plate")
            {
                if(dropToIndex !== -1)
                {
//                    deviceListModel.move(drag.source.no - 1, dropToIndex, 1)
                    project.addPatchesToGroup(deviceListView.groupName, drag.source.checkedIDs)
                    refreshPlatesNo()
                }
            }

            else if (drag.source.name === "Sequences")
            {
                var addSequWindow = Qt.createComponent("AddSequencesWidget.qml").createObject(applicationWindow, {groupName: deviceListView.groupName});
                addSequWindow.x = applicationWindow.width / 2 - addSequWindow.width / 2
                addSequWindow.y = applicationWindow.height / 2 - addSequWindow.height / 2
            }

            else if (drag.source.name === "Dimmer")
            {
                var addDimmerWindow = Qt.createComponent("AddDimmerWidget.qml").createObject(applicationWindow, {groupName: deviceListView.groupName});
                addDimmerWindow.x = applicationWindow.width / 2 - addDimmerWindow.width / 2
                addDimmerWindow.y = applicationWindow.height / 2 - addDimmerWindow.height / 2
            }

            else if (drag.source.name === "Shot")
            {
                var addShotWindow = Qt.createComponent("AddShotWidget.qml").createObject(applicationWindow, {groupName: deviceListView.groupName});
                addShotWindow.x = applicationWindow.width / 2 - addShotWindow.width / 2
                addShotWindow.y = applicationWindow.height / 2 - addShotWindow.height / 2
            }

            else if (drag.source.name === "Pyro")
            {
                var addPyroWindow = Qt.createComponent("AddPyroWidget.qml").createObject(applicationWindow, {groupName: deviceListView.groupName});
                addPyroWindow.x = applicationWindow.width / 2 - addPyroWindow.width / 2
                addPyroWindow.y = applicationWindow.height / 2 - addPyroWindow.height / 2
            }
        }
    }

    Connections
    {
        target: project
        function onPatchListChanged()
        {
            loadDeviceList()
        }
    }

    Connections
    {
        target: project
        function onGroupChanged()
        {
            loadDeviceList()
        }
    }


    Connections
    {
        target: project
        function onCurrentGroupIndexChanged()
        {
            loadDeviceList()
        }
    }

    Component.onCompleted:
    {
        loadDeviceList();
    }
}

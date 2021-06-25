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
    spacing: 2
    ScrollBar.vertical: ScrollBar {}

    property string groupName: ""

    function loadDeviceList()
    {
        deviceListModel.clear()
        var patchesList = project.patchesIdList(groupName)

        var sequ = []
        var dimm = []
        var shot = []
        var pyro = []

        for(var i = 0; i < patchesList.length; i++)
        {
            let currType = project.patchType(project.patchIndexForId(patchesList[i]))

            if(currType === "Sequences")
                sequ.push(patchesList[i])

            else if(currType === "Dimmer")
                dimm.push(patchesList[i])

            else if(currType === "Shot")
                shot.push(patchesList[i])

            else if(currType === "Pyro")
                pyro.push(patchesList[i])
        }

        var totalList = sequ.concat(dimm.concat(shot.concat(pyro)))

        for(i = 0; i < totalList.length; i++)
        {
            deviceListModel.insert(i, {counter: i + 1, currentId: totalList[i]})
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
                    editedList.push(deviceListView.itemAtIndex(i).patchId)
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

    Rectangle
    {
        id: dropMarker
        width: parent.width - 8
        height: 2
        color: "lightblue"
        visible: false
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

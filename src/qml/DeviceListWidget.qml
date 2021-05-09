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
            let index = project.patchIndexForId(patchesList[i])
            var propNamesList = project.patchPropertiesNames(index)
            var propValuesList = project.patchPropertiesValues(index)
            var cells = []
            for(let j = 0; j < propNamesList.length; j++)
            {
                cells.push({propName: propNamesList[j], propValue: propValuesList[j]})
            }

            var deviceType = project.patchType(index)
            var imageFile
            if (deviceType === "Sequences")
                imageFile = "qrc:/device_sequences"
            else if (deviceType === "Pyro")
                imageFile = "qrc:/device_pyro"
            else if (deviceType === "Shot")
                imageFile = "qrc:/device_shot"
            else if (deviceType === "Dimmer")
                imageFile = "qrc:/device_dimmer"

            deviceListModel.insert(i, {counter: i + 1, devType: deviceType, img: imageFile, currentCells: cells})
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
        var removedIndexes = []
        for(let i = 0; i < deviceListView.count; i++)
        {
            if(deviceListView.itemAtIndex(i).checked)
            {
                removedIndexes.push(i)
            }
        }

        project.removePatchesFromGroup(groupName, removedIndexes)
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
        type: devType
        imageFile: img
        no: counter
        cells: currentCells
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

        onDropped:
        {
            project.setCurrentGroup(deviceListView.groupName)

            var dropToIndex = deviceListView.indexAt(drag.x, drag.y)

            if(drag.source.name === "Patch Plate")
            {
                if(dropToIndex !== -1)
                {
                    deviceListModel.move(drag.source.no - 1, dropToIndex, 1)
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


    Component.onCompleted:
    {
        loadDeviceList();
    }
}

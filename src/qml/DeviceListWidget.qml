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

            var deviceType = project.patchType(i)
            var imageFile
            if (deviceType === "Sequences")
                imageFile = "qrc:/device_sequences"
            else if (deviceType === "Pyro")
                imageFile = "qrc:/device_pyro"
            else if (deviceType === "Shot")
                imageFile = "qrc:/device_shot"
            else if (deviceType === "Dimmer")
                imageFile = "qrc:/device_dimmer"

            deviceListModel.insert(i, {counter: i + 1, img: imageFile, currentCells: cells})
        }
    }



    function refreshPlatesNo()
    {
        for(let i = 0; i < deviceListModel.count; i++)
        {
            deviceListModel.get(i).counter = i + 1
        }
    }

    delegate: PatchPlate
    {
//        anchors.left: parent.left
//        anchors.right: parent.right
        imageFile: img
        no: counter
        cells: currentCells
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
//                addSequencesPlate(dropToIndex)
//                refreshPlatesNo()

                var addSequWindow = Qt.createComponent("AddSequencesWidget.qml").createObject(applicationWindow, {groupName: deviceListView.groupName});
                addSequWindow.x = applicationWindow.width / 2 - addSequWindow.width / 2
                addSequWindow.y = applicationWindow.height / 2 - addSequWindow.height / 2

//                project.addPatch([  {propName: "DMX", propValue: 0},
//                                  {propName: "min ang", propValue: -105},
//                                  {propName: "max ang", propValue: 105},
//                                  {propName: "RF pos", propValue: 3},
//                                  {propName: "RF ch", propValue: 21},
//                                  {propName: "height", propValue: 1}
//                                  ])
            }

            else if (drag.source.name === "Dimmer")
            {
                addDimmerPlate(dropToIndex)
                refreshPlatesNo()
            }

            else if (drag.source.name === "Shot")
            {
                addShotPlate(dropToIndex)
                refreshPlatesNo()
            }

            else if (drag.source.name === "Pyro")
            {
                addPyroPlate(dropToIndex)
                refreshPlatesNo()
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

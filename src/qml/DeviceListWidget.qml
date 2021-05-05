import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

ListView
{
    id: deviceListView
    anchors.margins: 2
    anchors.fill: parent
    clip: true
    spacing: 2
//    interactive: false
    ScrollBar.vertical: ScrollBar {}

    property bool isGeneralList: false

    function loadGeneralDeviceList()
    {
        deviceListModel.clear()
        var listSize = project.patchCount()
        for(let i = 0; i < listSize; i++)
        {
            var propNamesList = project.patchPropertiesNames(i)
            var propValuesList = project.patchPropertiesValues(i)
            var cells = []
//            console.log(propNamesList.length)
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


            deviceListModel.insert(deviceListView.count, {counter: deviceListView.count + 1, img: imageFile, currentCells: cells})
        }
    }

    function addSequencesPlate(index)
    {
        if(index === -1)
            index = 0

        deviceListModel.insert(index, {counter: deviceListView.count + 1, img: "qrc:/device_sequences",
                               currentCells: [  {propName: "DMX", propValue: "0"},
                                                {propName: "min ang", propValue: "-105"},
                                                {propName: "max ang", propValue: "+105"},
                                                {propName: "RF pos", propValue: "3"},
                                                {propName: "RF ch", propValue: "21"},
                                                {propName: "height", propValue: "1"}
                                                ]})
    }

    function addDimmerPlate(index)
    {
        if(index === -1)
            index = 0

        deviceListModel.insert(index, {counter: deviceListView.count + 1, img: "qrc:/device_dimmer",
                               currentCells: [  {propName: "DMX", propValue: "0"},
                                                {propName: "min ang", propValue: "-105"},
                                                {propName: "max ang", propValue: "+105"},
                                                {propName: "RF pos", propValue: "3"},
                                                {propName: "RF ch", propValue: "21"},
                                                {propName: "height", propValue: "1"}
                                                ]})
    }

    function addShotPlate(index)
    {
        if(index === -1)
            index = 0

        deviceListModel.insert(index, {counter: deviceListView.count + 1, img: "qrc:/device_shot",
                               currentCells: [  {propName: "DMX", propValue: "0"},
                                                {propName: "min ang", propValue: "-105"},
                                                {propName: "max ang", propValue: "+105"},
                                                {propName: "RF pos", propValue: "3"},
                                                {propName: "RF ch", propValue: "21"},
                                                {propName: "height", propValue: "1"}
                                                ]})
    }

    function addPyroPlate(index)
    {
        if(index === -1)
            index = 0

        deviceListModel.insert(index, {counter: deviceListView.count + 1, img: "qrc:/device_pyro",
                               currentCells: [  {propName: "DMX", propValue: "0"},
                                                {propName: "min ang", propValue: "-105"},
                                                {propName: "max ang", propValue: "+105"},
                                                {propName: "RF pos", propValue: "3"},
                                                {propName: "RF ch", propValue: "21"},
                                                {propName: "height", propValue: "1"}
                                                ]})
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
        anchors.left: parent.left
        anchors.right: parent.right
        imageFile: img
        no: counter
        cells: currentCells
    }

    model: ListModel
    {
        id: deviceListModel
    }

    Component.onCompleted:
    {
        if(isGeneralList)
        {
            loadGeneralDeviceList()
        }
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
                addSequencesPlate(dropToIndex)
                refreshPlatesNo()
                project.addPatch([  {propName: "DMX", propValue: 0},
                                  {propName: "min ang", propValue: -105},
                                  {propName: "max ang", propValue: 105},
                                  {propName: "RF pos", propValue: 3},
                                  {propName: "RF ch", propValue: 21},
                                  {propName: "height", propValue: 1}
                                  ])
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

//    Button
//    {
//        id: button
//        anchors.top: deviceListView.contentItem.bottom
//        onClicked: deviceListView.addSequencesPlate()
//    }
}

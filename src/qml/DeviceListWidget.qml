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

    property int draggedElementIndex: -1

    function addSequencesPlate()
    {
        deviceListModel.append({counter: deviceListView.count + 1, img: "qrc:/device_sequences",
                               currentCells: [  {propName: "DMX", propValue: "0"},
                                                {propName: "min ang", propValue: "-105"},
                                                {propName: "max ang", propValue: "+105"},
                                                {propName: "RF pos", propValue: "3"},
                                                {propName: "RF ch", propValue: "21"},
                                                {propName: "height", propValue: "1"}
                                                ]})
    }

    function addDimmerPlate()
    {
        deviceListModel.append({counter: deviceListView.count + 1, img: "qrc:/device_dimmer",
                               currentCells: [  {propName: "DMX", propValue: "0"},
                                                {propName: "min ang", propValue: "-105"},
                                                {propName: "max ang", propValue: "+105"},
                                                {propName: "RF pos", propValue: "3"},
                                                {propName: "RF ch", propValue: "21"},
                                                {propName: "height", propValue: "1"}
                                                ]})
    }

    function addShotPlate()
    {
        deviceListModel.append({counter: deviceListView.count + 1, img: "qrc:/device_shot",
                               currentCells: [  {propName: "DMX", propValue: "0"},
                                                {propName: "min ang", propValue: "-105"},
                                                {propName: "max ang", propValue: "+105"},
                                                {propName: "RF pos", propValue: "3"},
                                                {propName: "RF ch", propValue: "21"},
                                                {propName: "height", propValue: "1"}
                                                ]})
    }

    function addPyroPlate()
    {
        deviceListModel.append({counter: deviceListView.count + 1, img: "qrc:/device_pyro",
                               currentCells: [  {propName: "DMX", propValue: "0"},
                                                {propName: "min ang", propValue: "-105"},
                                                {propName: "max ang", propValue: "+105"},
                                                {propName: "RF pos", propValue: "3"},
                                                {propName: "RF ch", propValue: "21"},
                                                {propName: "height", propValue: "1"}
                                                ]})
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
        addSequencesPlate()
        addDimmerPlate()
        addShotPlate()
        addPyroPlate()
    }

    DropArea
    {
        anchors.fill: parent
        onEntered:
        {
            deviceListView.draggedElementIndex = deviceListView.indexAt(drag.x, drag.y)
            console.log(deviceListView.draggedElementIndex)
        }

        onExited:
        {
            var dropToIndex = deviceListView.indexAt(drag.x, drag.y)
            console.log(dropToIndex)

            if(deviceListView.draggedElementIndex !== -1 && dropToIndex !== -1)
                deviceListModel.move(deviceListView.draggedElementIndex, dropToIndex, 1)
        }

        onDropped:
        {
            console.log(drag)
        }
    }

//    Button
//    {
//        id: button
//        anchors.top: deviceListView.contentItem.bottom
//        onClicked: deviceListView.addSequencesPlate()
//    }
}

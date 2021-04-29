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

//    MouseArea
//    {
//        anchors.fill: parent
//        DropArea
//        {
//            anchors.fill: parent
//            onDropped: console.log("Dropped")
//        }
//    }

//    Button
//    {
//        id: button
//        anchors.top: deviceListView.contentItem.bottom
//        onClicked: deviceListView.addSequencesPlate()
//    }
}

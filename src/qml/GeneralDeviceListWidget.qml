import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
    id: generalListWidget
    anchors.fill: parent

    ListView
    {
        id: deviceListView
        anchors.margins: 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: deleteButton.top
        clip: true
        spacing: 2
        ScrollBar.vertical: ScrollBar {}

        function loadGeneralDeviceList()
        {
            deviceListModel.clear()
            var listSize = project.patchCount()
            for(let i = 0; i < listSize; i++)
            {
                var propNamesList = project.patchPropertiesNames(i)
                var propValuesList = project.patchPropertiesValues(i)
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

                deviceListModel.insert(deviceListView.count, {counter: deviceListView.count + 1, img: imageFile, currentCells: cells})
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
            loadGeneralDeviceList()
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
                    var addSequWindow = Qt.createComponent("AddSequencesWidget.qml").createObject(applicationWindow);
                    addSequWindow.x = applicationWindow.width / 2 - addSequWindow.width / 2
                    addSequWindow.y = applicationWindow.height / 2 - addSequWindow.height / 2
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
            function onPatchListChanged() {deviceListView.loadGeneralDeviceList()}
        }
    }

//    Button
//    {
//        id: addGroupButton
//        text: qsTr("Reverse Selection")
//        height: 24
//        width: (parent.width - anchors.margins * 4) / 3

//        anchors.margins: 2
//        anchors.bottomMargin: 4
//        anchors.left: parent.left
//        anchors.bottom: parent.bottom


//        bottomPadding: 2
//        topPadding: 2
//        rightPadding: 2
//        leftPadding: 2

//        background: Rectangle
//        {
//            color:
//            {
//                if(parent.enabled)
//                    parent.pressed ? "#222222" : "#27AE60"
//                else
//                    "#444444"
//            }
//            radius: 2
//        }

//        contentItem: Text
//        {
//            color: parent.enabled ? "#ffffff" : "#777777"
//            text: parent.text
//            horizontalAlignment: Text.AlignHCenter
//            verticalAlignment: Text.AlignVCenter
//            elide: Text.ElideRight
//            font.family: "Roboto"
//        }

//        onClicked:
//        {
//            for(let i = 0; i < deviceListView.count; i++)
//            {
//                deviceListView.itemAtIndex(i).checked = !deviceListView.itemAtIndex(i).checked;
//            }
//        }
//    }

    Button
    {
        id: editButton
        text: qsTr("Edit")
        height: 24
        width: (parent.width - anchors.margins * 3) / 2

        anchors.margins: 2
        anchors.bottomMargin: 4
        anchors.left: parent.left
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
        width: (parent.width - anchors.margins * 3) / 2

        anchors.margins: 2
        anchors.bottomMargin: 4
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
            var removedIndexes = []
            for(let i = 0; i < deviceListView.count; i++)
            {
                if(deviceListView.itemAtIndex(i).checked)
                {
                    removedIndexes.push(i)
                }
            }

            project.removePatches(removedIndexes)
        }
    }
}

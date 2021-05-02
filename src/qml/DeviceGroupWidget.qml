import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

ListView
{
    id: groupListView
    anchors.margins: 2
    anchors.fill: parent
    clip: true
    spacing: 2
    ScrollBar.vertical: ScrollBar {}

    delegate: DeviceGroup
    {
        anchors.left: parent.left
        name: groupName
    }

    function addGroup(name, index)
    {
        groupListModel.insert(index, {groupName: name})
    }

    model: ListModel
    {
        id: groupListModel
    }

    Component.onCompleted:
    {
        addGroup("Group1", 0)
        addGroup("Group2", 1)
        addGroup("Group3", 2)
    }

    DropArea
    {
        id: groupListWidgetDropArea
        anchors.fill: parent

        onDropped:
        {
//            var dropToIndex = deviceListView.indexAt(drag.x, drag.y)

//            if(drag.source.name === "Patch Plate")
//            {
//                if(dropToIndex !== -1)
//                {
//                    deviceListModel.move(drag.source.no - 1, dropToIndex, 1)
//                    refreshPlatesNo()
//                }
//            }

//            else if (drag.source.name === "Sequences")
//            {
//                addSequencesPlate(dropToIndex)
//                refreshPlatesNo()
//            }

//            else if (drag.source.name === "Dimmer")
//            {
//                addDimmerPlate(dropToIndex)
//                refreshPlatesNo()
//            }

//            else if (drag.source.name === "Shot")
//            {
//                addShotPlate(dropToIndex)
//                refreshPlatesNo()
//            }

//            else if (drag.source.name === "Pyro")
//            {
//                addPyroPlate(dropToIndex)
//                refreshPlatesNo()
//            }
        }
    }

//    Button
//    {
//        id: button
//        anchors.top: deviceListView.contentItem.bottom
//        onClicked: deviceListView.addSequencesPlate()
//    }
}

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

    delegate: DevicePlate
    {
        anchors.left: parent.left
        anchors.right: parent.right
        name: id
        imageFile: img
    }

    model: ListModel
    {
        id: deviceListModel
    }

    Component.onCompleted:
    {
        deviceListModel.append({id: "Sequences", img: "qrc:/device_sequences"})
        deviceListModel.append({id: "Dimmer", img: "qrc:/device_dimmer"})
        deviceListModel.append({id: "Shot", img: "qrc:/device_shot"})
        deviceListModel.append({id: "Pyro", img: "qrc:/device_pyro"})
    }

    DropArea
    {
        anchors.fill: parent

        onEntered:
        {
            console.log(drag.x, drag.y)
        }

        onExited:
        {
            console.log(drag.x, drag.y)
        }

        onDropped:
        {
            console.log(drag.x, drag.y)
        }
    }
}

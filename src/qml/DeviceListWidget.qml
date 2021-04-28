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

    delegate: PatchPlate
    {
        anchors.left: parent.left
        anchors.right: parent.right
        imageFile: img
    }

    model: ListModel
    {
        id: deviceListModel
    }

    Component.onCompleted:
    {
        deviceListModel.append({img: "qrc:/device_sequences"})
        deviceListModel.append({img: "qrc:/device_dimmer"})
        deviceListModel.append({img: "qrc:/device_shot"})
        deviceListModel.append({img: "qrc:/device_pyro"})
    }
}

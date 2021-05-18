import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

ListView
{
    id: deviceLibView
    anchors.margins: 2
    anchors.fill: parent
    clip: true
    spacing: 2
    ScrollBar.vertical: ScrollBar {}

    property bool held: false

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

    DevicePlate
    {
        id: draggedPlate
        visible: deviceLibView.held
        opacity: 0.8
        withBorder: true

        Drag.active: deviceLibView.held
        Drag.source: this
//        Drag.hotSpot.x: this.width / 2
//        Drag.hotSpot.y: this.height / 2

        states: State
        {
            when: deviceLibView.held

            ParentChange { target: draggedPlate; parent: patchScreen }
            AnchorChanges {
                target: draggedPlate
                anchors { horizontalCenter: undefined; verticalCenter: undefined; left: undefined; right: undefined }
            }
        }
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent

        drag.target: deviceLibView.held ? draggedPlate : undefined
        drag.axis: Drag.XAndYAxis

        onPressed:
        {
            var pressedItem = deviceLibView.itemAt(mouseX, mouseY)
            if(pressedItem)
            {
                deviceLibView.held = true
                draggedPlate.x = pressedItem.mapToItem(patchScreen, 0, 0).x
                draggedPlate.y = pressedItem.mapToItem(patchScreen, 0, 0).y
                draggedPlate.width = pressedItem.width
                draggedPlate.height = pressedItem.height
                draggedPlate.name = pressedItem.name
                draggedPlate.imageFile = pressedItem.imageFile
            }
        }

        onReleased:
        {
            if(drag.target)
            {
                drag.target.Drag.drop()
                deviceLibView.held = false
            }
        }
    }
}

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
    property bool held: false

    function loadDeviceList()
    {
        deviceListModel.clear()
        var listSize = project.patchCount()
        for(let i = 0; i < listSize; i++)
        {
            if(project.patchType(i) === deviceListView.groupName)
                deviceListModel.insert(deviceListView.count, {counter: deviceListView.count + 1, currentId: project.patchPropertyForIndex(i, "ID")})
        }
    }

    function refreshPlatesNo()
    {
        for(let i = 0; i < deviceListModel.count; i++)
        {
            deviceListModel.get(i).counter = i + 1
        }
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
        no: counter
        patchId: currentId
    }

    model: ListModel
    {
        id: deviceListModel
    }

    Component.onCompleted:
    {
        loadDeviceList()
    }

    PatchPlate
    {
        id: draggedPlate
        visible: deviceListView.held
        opacity: 0.8
        withBorder: true

        Drag.active: deviceListView.held
        Drag.source: this
        //            Drag.hotSpot.x: this.width / 2
        //            Drag.hotSpot.y: this.height / 2

        states: State
        {
            when: deviceListView.held

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
        propagateComposedEvents: true

        drag.target: deviceListView.held ? draggedPlate : undefined
        drag.axis: Drag.XAndYAxis

        onPressAndHold:
        {
            var pressedItem = deviceListView.itemAt(mouseX, mouseY)
            if(pressedItem)
            {
                draggedPlate.checkedIDs = []
                for(let i = 0; i < deviceListView.count; i++)
                {
                    if(deviceListView.itemAtIndex(i).checked)
                        draggedPlate.checkedIDs.push(deviceListView.itemAtIndex(i).patchId)
                }

                if(draggedPlate.checkedIDs.length === 0) // Перетаскивем только одну плашку, а она может быть и не выделена
                {
                    draggedPlate.checkedIDs.push(pressedItem.patchId)
                }

                deviceListView.held = true
                draggedPlate.x = pressedItem.mapToItem(patchScreen, 0, 0).x
                draggedPlate.y = pressedItem.mapToItem(patchScreen, 0, 0).y
                draggedPlate.no = pressedItem.no
                draggedPlate.width = pressedItem.width
                draggedPlate.height = pressedItem.height
                draggedPlate.name = pressedItem.name
                draggedPlate.imageFile = pressedItem.imageFile
                draggedPlate.refreshCells()
            }
        }

        onReleased:
        {
            if(drag.target)
            {
                drag.target.Drag.drop()
                deviceListView.held = false
            }
        }
    }

    DropArea
    {
        id: deviceListWidgetDropArea
        anchors.fill: parent

        onDropped:
        {
            //                var dropToIndex = deviceListView.indexAt(drag.x, drag.y)

            //                if(drag.source.name === "Patch Plate")
            //                {
            //                    if(dropToIndex !== -1)
            //                    {
            //                        deviceListModel.move(drag.source.no - 1, dropToIndex, 1)
            //                        refreshPlatesNo()
            //                    }
            //                }

            if(!applicationWindow.isPatchEditorOpened)
            {
                if (drag.source.name === "Sequences")
                {
                    var addSequWindow = Qt.createComponent("AddSequencesWidget.qml").createObject(applicationWindow);
                    addSequWindow.x = applicationWindow.width / 2 - addSequWindow.width / 2
                    addSequWindow.y = applicationWindow.height / 2 - addSequWindow.height / 2
                }

                else if (drag.source.name === "Dimmer")
                {
                    var addDimmerWindow = Qt.createComponent("AddDimmerWidget.qml").createObject(applicationWindow);
                    addDimmerWindow.x = applicationWindow.width / 2 - addDimmerWindow.width / 2
                    addDimmerWindow.y = applicationWindow.height / 2 - addDimmerWindow.height / 2
                }

                else if (drag.source.name === "Shot")
                {
                    var addShotWindow = Qt.createComponent("AddShotWidget.qml").createObject(applicationWindow);
                    addShotWindow.x = applicationWindow.width / 2 - addShotWindow.width / 2
                    addShotWindow.y = applicationWindow.height / 2 - addShotWindow.height / 2
                }

                else if (drag.source.name === "Pyro")
                {
                    var addPyroWindow = Qt.createComponent("AddPyroWidget.qml").createObject(applicationWindow);
                    addPyroWindow.x = applicationWindow.width / 2 - addPyroWindow.width / 2
                    addPyroWindow.y = applicationWindow.height / 2 - addPyroWindow.height / 2
                }
            }
        }
    }

    Connections
    {
        target: project
        function onPatchListChanged() {deviceListView.loadDeviceList()}
    }
}

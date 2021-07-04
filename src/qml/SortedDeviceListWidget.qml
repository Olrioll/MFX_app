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
//    clip: true
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

        property string infoText: ""

        Drag.active: deviceListView.held
        Drag.source: this
        Drag.hotSpot.x: this.width / 2
        Drag.hotSpot.y: this.height / 2

        states: State
        {
            when: deviceListView.held

            ParentChange { target: draggedPlate; parent: patchScreen }
            AnchorChanges {
                target: draggedPlate
                anchors { horizontalCenter: undefined; verticalCenter: undefined; left: undefined; right: undefined }
            }
        }

        Text
        {
            anchors.centerIn: parent
            color: "#ffffff"
            font.family: "Roboto"
            font.pixelSize: 12
            text: parent.infoText
        }
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        propagateComposedEvents: true

        property var pressedItem: null
        property int pressedX
        property int pressedY
//        property int mappedPressedX
//        property int mappedPressedY
        property bool wasDragging: false

        drag.target: deviceListView.held ? draggedPlate : undefined
        drag.axis: Drag.XAndYAxis

        drag.minimumX: 0
        drag.maximumX: patchScreen.width - draggedPlate.width
        drag.minimumY: 0
        drag.maximumY: patchScreen.height - draggedPlate.height

        drag.threshold: 0
        drag.smoothed: false

        onClicked:
        {
            pressedItem = deviceListView.itemAt(mouseX, mouseY)
            if(pressedItem)
            {
                if(!wasDragging)
                    project.setPatchProperty(pressedItem.patchId, "checked", !project.patchProperty(pressedItem.patchId, "checked"))

                wasDragging = false
            }
        }


        onPressed:
        {
            pressedX = mouseX
            pressedY = mouseY

            pressedItem = deviceListView.itemAt(mouseX, mouseY)
            if(pressedItem)
            {
//                mappedPressedX = pressedItem.mapFromItem(mouseArea, mouseX, mouseY).x
//                mappedPressedY = pressedItem.mapFromItem(mouseArea, mouseX, mouseY).y
                draggedPlate.Drag.hotSpot.x = pressedItem.mapFromItem(mouseArea, mouseX, mouseY).x
                draggedPlate.Drag.hotSpot.y = pressedItem.mapFromItem(mouseArea, mouseX, mouseY).y

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

                draggedPlate.infoText = qsTr("Adding patches with IDs: " + draggedPlate.checkedIDs)

                draggedPlate.refreshCells()
            }
        }

        onPositionChanged:
        {
            wasDragging = true

//            let currX = mouseArea.mapToItem(patchScreen, mouseX, mouseY).x - mappedPressedX
//            let currY = mouseArea.mapToItem(patchScreen, mouseX, mouseY).y - mappedPressedY

//            if(currX < 0)
//                draggedPlate.x = 0
//            else if(currX > patchScreen.width - draggedPlate.width)
//                draggedPlate.x = patchScreen.width - draggedPlate.width
//            else
//                draggedPlate.x = currX

//            if(currY < 0)
//                draggedPlate.y = 0
//            else if(currY > patchScreen.height - draggedPlate.height)
//                draggedPlate.y = patchScreen.height - draggedPlate.height
//            else
//                draggedPlate.y = currY
        }

        onReleased:
        {
            if(drag.target)
            {
                drag.target.Drag.drop()
                deviceListView.held = false
                wasDragging = false
                pressedItem.withBorder = false
                pressedItem = null
            }
        }
    }

    Rectangle
    {
        id: groupBackground
        anchors.leftMargin: -3
        anchors.left: parent.left
        anchors.topMargin: -3
        anchors.top: parent.top
        height: parent.height + 4
        width: parent.parent ? parent.parent.width : parent.width
        color: "transparent"
        radius: 2

        border.width: 1
        border.color: "transparent"

        DropArea
        {
            anchors.fill: parent

            onEntered: groupBackground.border.color = "lightblue"
            onExited: groupBackground.border.color = "transparent"
        }
    }

//    Rectangle
//    {
//        id: dropMarker
//        width: parent.width - 8
//        height: 2
//        color: "lightblue"
//        visible: false
//    }

//    DropArea
//    {
//        id: deviceListWidgetDropArea
//        anchors.fill: parent

//        property var currPlate: null

//        onEntered:
//        {
//            if(deviceListView.itemAt(drag.x, drag.y))
//            {
//                currPlate = deviceListView.itemAt(drag.x, drag.y)
//                dropMarker.width = currPlate.width
//                dropMarker.visible = true
//            }
//        }

//        onExited:
//        {
//            dropMarker.visible = false
//        }

//        onPositionChanged:
//        {
//            if(deviceListView.itemAt(drag.x, drag.y) !== currPlate)
//            {
//                currPlate = deviceListView.itemAt(drag.x, drag.y)

//                if(currPlate)
//                {
//                    dropMarker.width = currPlate.width
//                    dropMarker.x = currPlate.x
//                    dropMarker.y = currPlate.y + currPlate.height
//                    dropMarker.visible = true
//                }
//            }
//        }

//        onDropped:
//        {
//            dropMarker.visible = false

//            if(!applicationWindow.isPatchEditorOpened)
//            {
//                if (drag.source.name === "Sequences")
//                {
//                    var addSequWindow = Qt.createComponent("AddSequencesWidget.qml").createObject(applicationWindow);
//                    addSequWindow.x = applicationWindow.width / 2 - addSequWindow.width / 2
//                    addSequWindow.y = applicationWindow.height / 2 - addSequWindow.height / 2
//                }

//                else if (drag.source.name === "Dimmer")
//                {
//                    var addDimmerWindow = Qt.createComponent("AddDimmerWidget.qml").createObject(applicationWindow);
//                    addDimmerWindow.x = applicationWindow.width / 2 - addDimmerWindow.width / 2
//                    addDimmerWindow.y = applicationWindow.height / 2 - addDimmerWindow.height / 2
//                }

//                else if (drag.source.name === "Shot")
//                {
//                    var addShotWindow = Qt.createComponent("AddShotWidget.qml").createObject(applicationWindow);
//                    addShotWindow.x = applicationWindow.width / 2 - addShotWindow.width / 2
//                    addShotWindow.y = applicationWindow.height / 2 - addShotWindow.height / 2
//                }

//                else if (drag.source.name === "Pyro")
//                {
//                    var addPyroWindow = Qt.createComponent("AddPyroWidget.qml").createObject(applicationWindow);
//                    addPyroWindow.x = applicationWindow.width / 2 - addPyroWindow.width / 2
//                    addPyroWindow.y = applicationWindow.height / 2 - addPyroWindow.height / 2
//                }
//            }
//        }
//    }

    Connections
    {
        target: project
        function onPatchListChanged() {deviceListView.loadDeviceList()}
    }
}

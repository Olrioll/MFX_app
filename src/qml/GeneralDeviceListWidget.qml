import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import "qrc:/"

Item
{
    id: generalListWidget
    width: layout.width + 10

    function deleteSelected()
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

    function changeView()
    {
        layout.currentIndex  = layout.currentIndex === 0 ? 1 : 0
        layout.width = layout.widthNeeded()
    }

    StackLayout
    {
        id: layout

        width: widthNeeded()
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottomMargin: 10
        anchors.bottom: deleteButton.top

        function widthNeeded()
        {
            if(currentIndex === 0)
            {
                return 400
            }

            else if (currentIndex === 1)
            {
                for(let i = 0; i < sortedDeviceListView.count; i++)
                {
                    if(sortedDeviceListView.itemAtIndex(i).isExpanded)
                        return 420
                }

                return 170
            }
        }

        ListView
        {
            id: deviceListView
//            clip: true
            spacing: 2
            ScrollBar.vertical: ScrollBar
            {
                anchors
                {
                    right: deviceListView.right
                    top: deviceListView.top
                    bottom: deviceListView.bottom
                    rightMargin: -3
                }
            }

            property bool held: false

            function loadGeneralDeviceList()
            {
                deviceListModel.clear()
                var listSize = project.patchCount()
                for(let i = 0; i < listSize; i++)
                {
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
                            editedList.push(deviceListView.itemAtIndex(i).patchId)
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
                loadGeneralDeviceList()
            }

            PatchPlate
            {
                id: draggedPlate
                visible: mouseArea.wasDragging
                opacity: 0.8
                withBorder: true

                Drag.active: mouseArea.wasDragging
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

                property var pressedItem: null
                property int pressedX
                property int pressedY
                property bool wasDragging: false

                drag.target: deviceListView.held ? draggedPlate : undefined
                drag.axis: Drag.XAndYAxis

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

                onPositionChanged:
                {
                    wasDragging = true
                    let dx = mouseX - pressedX
                    let dy = mouseY - pressedY
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
                id: dropMarker
                width: parent.width - 8
                height: 2
                color: "lightblue"
                visible: false
            }

            DropArea
            {
                id: deviceListWidgetDropArea
                anchors.fill: parent

                property var currPlate: null

                onEntered:
                {
                    if(deviceListView.itemAt(drag.x, drag.y))
                    {
                        currPlate = deviceListView.itemAt(drag.x, drag.y)
                        dropMarker.width = currPlate.width
                        dropMarker.visible = true
                    }
                }

                onExited:
                {
                    dropMarker.visible = false
                }

                onPositionChanged:
                {
                    if(deviceListView.itemAt(drag.x, drag.y) !== currPlate)
                    {
                        currPlate = deviceListView.itemAt(drag.x, drag.y)

                        if(currPlate)
                        {
                            dropMarker.width = currPlate.width
                            dropMarker.x = currPlate.x
                            dropMarker.y = currPlate.y + currPlate.height
                            dropMarker.visible = true
                        }
                    }
                }

                onDropped:
                {
                    dropMarker.visible = false

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
                function onPatchListChanged() {deviceListView.loadGeneralDeviceList()}
            }
        }

        ListView
        {
            id: sortedDeviceListView
//            clip: true
            spacing: 10
            ScrollBar.vertical: ScrollBar
            {
                anchors
                {
                    right: sortedDeviceListView.right
                    top: sortedDeviceListView.top
                    bottom: sortedDeviceListView.bottom
                    rightMargin: -3
                }
            }

            property bool held: false

            function loadGroups()
            {
                groupListModel.append({groupName: "Sequences"})
                groupListModel.append({groupName: "Dimmer"})
                groupListModel.append({groupName: "Shot"})
                groupListModel.append({groupName: "Pyro"})
            }

            delegate: TypeGroup
            {
                id: typeGroup
                name: groupName
                Connections
                {
                    target: typeGroup
                    function onViewChanged()
                    {
                        layout.width = layout.widthNeeded()
                    }
                }
            }

            model: ListModel
            {
                id: groupListModel
            }

            Component.onCompleted:
            {
                loadGroups();
            }
        }
    }

    Item
    {
        id: buttonsBackground
        height: 40
        width: parent.width
        anchors.left: parent.left
        anchors.bottomMargin: -2
        anchors.bottom: parent.bottom

        LinearGradient
        {
            anchors.fill: parent
            start: Qt.point(0, parent.height / 3)
            end: Qt.point(0, 0)
            gradient: Gradient
            {
                GradientStop { position: 1.0; color: "#00000000" }
                GradientStop { position: 0.0; color: "#FF000000" }
            }
        }
    }

    Button
    {
        id: editButton
        text: qsTr("Edit")
        height: 24
        width: (parent.width - 10) / 2

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

        onClicked:
        {
            deviceListView.openEditWindow()
        }
    }

    Button
    {
        id: deleteButton
        text: qsTr("Delete selected")
        height: 24
        width: editButton.width

        anchors.leftMargin: 2
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
            var confirmDeleteDialog = Qt.createComponent("ConfirmationDialog.qml").createObject(applicationWindow);
            confirmDeleteDialog.x = applicationWindow.width / 2 - confirmDeleteDialog.width / 2
            confirmDeleteDialog.y = applicationWindow.height / 2 - confirmDeleteDialog.height / 2
            confirmDeleteDialog.accepted.connect(generalListWidget.deleteSelected)
            confirmDeleteDialog.caption = qsTr("Action confirmation")
            confirmDeleteDialog.dialogText = qsTr("Are you shure you want\nto delete selected patches?")
            confirmDeleteDialog.acceptButtonText = qsTr("Delete")
            confirmDeleteDialog.cancelButtonText = qsTr("Cancel")
            confirmDeleteDialog.acceptButtonColor = "#EB5757"
        }
    }
}

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI 1.0
import MFX.UI.Styles 1.0
import MFX.UI.Components.Basic 1.0
import MFX.UI.Components.PatchPlate 1.0

Component
{
    Rectangle
    {
        id: mainScreenDeviceListWidget

        objectName: "device_list"

        color: "black"
        radius: 2
        clip: true

        border.width: 2
        border.color: "#444444"

        MouseArea
        {
            anchors.fill: parent
        
            propagateComposedEvents: false
            preventStealing: true
        
            onWheel: (wheel) => {
                            wheel.accepted = true
                        }
        }

        MfxButton
        {
            id: devicesButton
            height: 24
            text: translationsManager.translationTrigger + qsTr("Devices")
            checkable: true

            anchors.topMargin: 4
            anchors.leftMargin: 4
            anchors.rightMargin: parent.width / 2

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            ButtonGroup.group: switchDevicesListButtons
        }

        MfxButton
        {
            id: groupsButton
            height: 24
            text: translationsManager.translationTrigger + qsTr("Groups")
            checkable: true

            anchors.topMargin: 4
            anchors.rightMargin: 4

            anchors.top: parent.top
            anchors.left: devicesButton.right
            anchors.right: parent.right

            ButtonGroup.group: switchDevicesListButtons
        }

        ButtonGroup
        {
            id: switchDevicesListButtons
            checkedButton: devicesButton

            onClicked: button == devicesButton ? devicesListStackLayout.currentIndex = 0 : devicesListStackLayout.currentIndex = 1
        }

        StackLayout
        {
            id: devicesListStackLayout
            anchors.fill: parent
            anchors.topMargin: 32
            anchors.leftMargin: 6
            anchors.bottomMargin: 6
            clip: true


            ListView
            {
                id: sortedDeviceListView

                spacing: 10
                MouseArea
                {
                    anchors.fill: parent;
                    z:-1
                    onClicked: project.uncheckPatch();
                }

                ScrollBar.vertical: ScrollBar {
                    anchors.right: sortedDeviceListView.contentItem.right
                    anchors.rightMargin: 3

                    policy: ScrollBar.AsNeeded

                    background: Rectangle {
                        id: _background

                        width: 6
                        implicitWidth: 6

                        radius: 3

                        color: "#1AFFFFFF"
                    }

                    contentItem: Rectangle {
                        id: _indicator

                        width: 6
                        implicitWidth: 6

                        radius: 3

                        color: "#80C4C4C4"
                    }
                }

                function loadGroups()
                {
                    groupListModel.append({groupName: "Sequences"})
                    //TODO-DEVICES-TYPES пока не используем другие типы устройств - только Sequences, поэтому комментируем
                    //                    огда понадобитс€ восстановить, делаем поиск по TODO-DEVICES-TYPES
//                            groupListModel.append({groupName: "Dimmer"})
                    groupListModel.append({groupName: "Shot"})
//                            groupListModel.append({groupName: "Pyro"})
                }

                delegate: Item
                    {
                        id: typeGroup

                        anchors.left: sortedDeviceListView.contentItem.left
                        anchors.right: sortedDeviceListView.contentItem.right

                        height: collapseButton.checked ? collapseButton.height + deviceListView.contentItem.height + 20 : collapseButton.height
                        property string name: groupName
                        property bool isExpanded: collapseButton.checked

                        Button
                        {
                            id: collapseButton
                            width: 16
                            height: 16
                            checkable: true

                            bottomPadding: 0
                            topPadding: 0
                            rightPadding: 0
                            leftPadding: 0

                            background: Rectangle {
                                color: "#444444"
                                radius: 2
                            }

                            contentItem: Text {
                                color: "#ffffff"
                                text: parent.checked ? "-" : "+"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                font.family: Fonts.robotoRegular.name
                                font.pixelSize: 14
                            }

                            onCheckedChanged:
                            {
                                isExpanded = checked
                            }
                        }

                        Rectangle
                        {
                            color: "#000000"
                            radius: 2
                            anchors.leftMargin: 10
                            anchors.left: collapseButton.right
                            height: collapseButton.height
                            width: groupNameText.width + 4

                            Text
                            {
                                id: groupNameText
                                color: "#ffffff"
                                text: typeGroup.name
                                anchors.leftMargin: 2
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: Text.AlignHLeft
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                font.family: Fonts.robotoRegular.name
                                font.pixelSize: 12
                            
                                MouseArea
                                {
                                    anchors.fill: parent
                                    onDoubleClicked: deviceListView.selectAll();
                                }
                            }
                        }

                        Item
                        {
                            id: listArea
                            visible: collapseButton.checked
                            anchors.left: typeGroup.left
                            anchors.right: typeGroup.right
                            anchors.leftMargin: 18
                            anchors.rightMargin: 18
                            anchors.top: parent.top
                            anchors.topMargin: 30

                            height: deviceListView.height + 4

                            property alias deviceListView: deviceListView

                            ListView
                            {
                                id: deviceListView
                                anchors.margins: 2
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                //width: 392
                                height: contentItem.height < 10 ? contentItem.height + 30 : contentItem.height
                                spacing: 2
                                interactive: false

                                property string groupName: typeGroup.name
                                property bool held: false

                                function getItemAtGlobalPosition(posX, posY)
                                {
                                    return itemAt(mapFromGlobal(posX, posY).x, mapFromGlobal(posX, posY).y)
                                }

                                function loadDeviceList()
                                {
                                    deviceListModel.clear()
                                    var listSize = project.patchCount()
                                    for(let i = 0; i < listSize; i++)
                                    {
                                        let patch_id = project.patchPropertyForIndex(i, "ID")

                                        if( project.patchTypeStr( patch_id ) === deviceListView.groupName )
                                            deviceListModel.insert( deviceListView.count, {counter: deviceListView.count + 1, currentId: patch_id} )
                                    }
                                }

                                function refreshPlatesNo()
                                {
                                    for(let i = 0; i < deviceListModel.count; i++)
                                    {
                                        deviceListModel.get(i).counter = i + 1
                                    }
                                }

                                function selectAll()
                                {
                                    for(let i = 0; i < deviceListModel.count; i++)
                                    {
                                        project.setPatchProperty(deviceListModel.get(i).currentId, "checked", true)

                                    }
                                    cueContentManager.cleanSelectionRequest()
                                }

                                delegate: PatchPlate
                                {
                                    anchors.left: deviceListView.contentItem.left
                                    anchors.right: deviceListView.contentItem.right
                                    no: counter
                                    patchId: currentId

                                    DropArea
                                    {
                                        anchors.fill: parent;
                                        property bool isEnter: false

                                        onDropped:
                                        {
                                            //console.log("onDropped", drop.source.name, drop.source.typeStr )
                                            if( drop.source.isActionPlate && (drop.source.type == project.patchType( patchId )) )
                                            {
                                                project.setPatchProperty(patchId, "act", drop.source.name);
                                                project.setPatchProperty(patchId, "checked", false)
                                                isEnter = false;
                                                refreshCells()
                                            }
                                        }
                                        onEntered:
                                        {
                                            //console.log("onEntered", drag.source.typeStr, project.patchTypeStr( patchId ))
                                            if( drag.source.isActionPlate && (drag.source.type == project.patchType( patchId )) )
                                            {
                                                project.setPatchProperty(patchId, "checked", true);
                                                isEnter=true;
                                            }
                                        }
                                        onExited:
                                        {
                                            if(isEnter)
                                                project.setPatchProperty(patchId, "checked", false)
                                        }
                                    }
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
                                    visible: deviceListView.held && mouseArea.wasPressedAndMoved && !draggedCuePlate.visible
                                    opacity: 0.8
                                    withBorder: true

                                    property string infoText: ""
                                    property string intersectionState: draggedCuePlate.state

                                    Drag.active: deviceListView.held
                                    Drag.source: this

                                    states: State
                                    {
                                        when: deviceListView.held

                                        ParentChange { target: draggedPlate; parent: mainScreen }
                                        AnchorChanges {
                                            target: draggedPlate
                                            anchors { horizontalCenter: undefined; verticalCenter: undefined; left: undefined; right: undefined }
                                        }
                                    }

                                    Text
                                    {
                                        anchors.centerIn: parent
                                        color: "#ffffff"
                                        font.family: Fonts.robotoRegular.name
                                        font.pixelSize: 12
                                        text: parent.infoText
                                    }

                                    onParentChanged:
                                    {
                                        if(draggedCuePlate)
                                            draggedCuePlate.parent = parent
                                    }
                                }

                                Item
                                {
                                    id: draggedCuePlate
                                    visible: false

                                    x: draggedPlate.x /*+ draggedPlate.Drag.hotSpot.x*/
                                    y: draggedPlate.y /*+ draggedPlate.Drag.hotSpot.y*/

                                    height: 10
                                    width: 100

                                    Rectangle
                                    {
                                        id: frame
                                        anchors.fill: parent

                                        radius: 4
                                        color: "#7F27AE60"
                                        border.width: 2
                                        border.color: "#27AE60"
                                    }

                                    states:
                                    [
                                        State
                                        {
                                            name: "intersected"
                                            PropertyChanges
                                            {
                                                target: frame
                                                color: "#3FEB5757"
                                            }

                                            PropertyChanges
                                            {
                                                target: frame.border
                                                color: "#EB5757"
                                            }
                                        }
                                    ]
                                }

                                MfxMouseArea
                                {
                                    id: mouseArea
                                    anchors.fill: parent

                                    property var pressedItem: null
                                    property bool wasDragging: false

                                    drag.target: deviceListView.held ? draggedPlate : undefined
                                    drag.axis: Drag.XAndYAxis

                                    drag.minimumX: 0
                                    drag.maximumX: mainScreen.width - draggedCuePlate.width
                                    drag.minimumY: 0
                                    drag.maximumY: mainScreen.height - draggedCuePlate.height

                                    drag.threshold: 0
                                    drag.smoothed: false

                                    onClicked:
                                    {
                                        pressedItem = deviceListView.itemAt(mouseX, mouseY)
                                        if(pressedItem)
                                        {
                                            cueContentManager.cleanSelectionRequest()

                                            if(!wasDragging)
                                                project.setPatchProperty(pressedItem.patchId, "checked", !project.patchProperty(pressedItem.patchId, "checked"))

                                            wasDragging = false
                                        }
                                    }


                                    onPressed:
                                    {
                                        pressedItem = deviceListView.itemAt(mouseX, mouseY)
                                        if(pressedItem)
                                        {
                                            draggedPlate.checkedIDs = []

                                            for(let i = 0; i < deviceListView.count; i++)
                                                if(deviceListView.itemAtIndex(i).checked)
                                                    draggedPlate.checkedIDs.push(deviceListView.itemAtIndex(i).patchId)

                                            if(!draggedPlate.checkedIDs.includes(pressedItem.patchId))
                                                draggedPlate.checkedIDs.push(pressedItem.patchId)

                                            deviceListView.held = true
                                            draggedPlate.x = pressedItem.mapToItem(mainScreen, mouseX, mouseY).x
                                            draggedPlate.y = pressedItem.mapToItem(mainScreen, 0, 0).y + draggedPlate.height/2

                                            draggedPlate.no = pressedItem.no

                                            let maxDuration = deviceManager.maxActionsDuration(draggedPlate.checkedIDs);

                                            draggedPlate.width = playerWidget.msecToPixels(maxDuration);
                                            console.log("width:", draggedPlate.width)
                                            draggedCuePlate.width = draggedPlate.width;
                                            draggedPlate.height = draggedCuePlate.height
                                            draggedPlate.name = pressedItem.name
                                            draggedPlate.imageFile = pressedItem.imageFile

                                            draggedPlate.refreshCells()
                                        }
                                    }

                                    onPositionChanged:
                                    {
                                        wasDragging = true
                                        if(playerWidget.contains(mouseArea.mapToItem(playerWidget, mouseX, mouseY)))
                                        {
                                            draggedCuePlate.visible = true

                                            // ѕровер€ем, накладывемс€ ли на какую-нибудь плашку
                                            if(playerWidget.isRectIntersectsWithCuePlate(mouseArea.mapToItem(playerWidget.cueView, mouseX, mouseY), draggedCuePlate.width, draggedCuePlate.height))
                                            {
                                                draggedCuePlate.state = "intersected"
                                            }

                                            else
                                            {
                                                draggedCuePlate.state = ""
                                            }

                                        }
                                        else
                                        {
                                            draggedCuePlate.visible = false
                                        }
                                    }

                                    onReleased:
                                    {
                                        if(drag.target)
                                        {
                                        if(drag.target.x < 1)
                                            drag.target.x = 3;

                                            drag.target.Drag.drop()
                                            deviceListView.held = false
                                            wasDragging = false
                                            pressedItem.withBorder = false
                                            pressedItem = null
                                            draggedCuePlate.visible = false
                                        }
                                    }
                                }

                                Connections
                                {
                                    target: project
                                    function onPatchListChanged() {deviceListView.loadDeviceList()}
                                }
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

            DeviceGroupWidget
            {
                patchScreenMode: false
                dropAreaAvaliable: false
            }
        }

        PatchPlate
        {
            id: draggedPlate2
            visible: stackLayoutMouseArea.wasPressedAndMoved && !draggedCuePlate2.visible
            opacity: 0.8
            withBorder: true
            parent: mainScreen

            property string infoText: ""
            property string intersectionState: draggedCuePlate2.state

            Drag.active: stackLayoutMouseArea.wasPressedAndMoved
            Drag.source: draggedPlate2
            Drag.hotSpot.x: 10
            Drag.hotSpot.y: 10

            Text
            {
                anchors.centerIn: parent
                color: "#ffffff"
                font.family: Fonts.robotoRegular.name
                font.pixelSize: 12
                text: parent.infoText
            }

            onParentChanged:
            {
                if(draggedCuePlate2)
                    draggedCuePlate2.parent = parent
            }
        }

        Item
        {
            id: draggedCuePlate2
            visible: false
            parent: mainScreen

            x: draggedPlate2.x
            y: draggedPlate2.y

            height: 10
            width: 100

            Rectangle
            {
                id: frame2
                anchors.fill: parent

                radius: 4
                color: "#7F27AE60"
                border.width: 2
                border.color: "#27AE60"
            }

            states:
                [
                State
                {
                    name: "intersected"
                    PropertyChanges
                    {
                        target: frame2
                        color: "#3FEB5757"
                    }

                    PropertyChanges
                    {
                        target: frame2.border
                        color: "#EB5757"
                    }
                }
            ]
        }

        MfxMouseArea
        {
            id: stackLayoutMouseArea
            anchors.leftMargin: 40
            anchors.fill: devicesListStackLayout
            propagateComposedEvents: true
            hoverEnabled: true

            visible: devicesListStackLayout.currentIndex !== 0

            drag.target: draggedPlate2
            drag.axis: Drag.XAndYAxis

            drag.minimumX: 0
            drag.maximumX: mainScreen.width - draggedPlate2.width
            drag.minimumY: 0
            drag.maximumY: mainScreen.height - draggedPlate2.height

            drag.threshold: 0
            drag.smoothed: false

            onPressed:
            {
                draggedPlate2.x = mapToItem(mainScreen, mouseX, mouseY).x
                draggedPlate2.y = mapToItem(mainScreen, mouseX, mouseY).y

                draggedPlate2.checkedIDs = project.checkedPatchesList()
                draggedPlate2.infoText = qsTr("Adding patches with IDs: " + draggedPlate2.checkedIDs)
                draggedPlate2.refreshCells()
            }

            onPositionChanged:
            {
                if(playerWidget.contains(mapToItem(playerWidget, mouseX, mouseY)))
                {
                    draggedCuePlate2.visible = true

                    // ѕровер€ем, накладывемс€ ли на какую-нибудь плашку
                    if(playerWidget.isRectIntersectsWithCuePlate(mapToItem(playerWidget.cueView, mouseX, mouseY), draggedCuePlate2.width, draggedCuePlate2.height))
                    {
                        draggedCuePlate2.state = "intersected"
                    }

                    else
                    {
                        draggedCuePlate2.state = ""
                    }
                }

                else
                {
                    draggedCuePlate2.visible = false
                }
            }

            onReleased:
            {
                if(drag.target)
                {
                    drag.target.Drag.drop()
                    draggedCuePlate2.visible = false
                }
                wasPressedAndMoved = false
            }
        }
    }
}
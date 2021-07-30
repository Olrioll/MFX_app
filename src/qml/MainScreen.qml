import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import "qrc:/"

Item
{
    id: mainScreen

    property var sceneWidget: null
    property alias playerWidget: playerWidget

    function setupSceneWidget(widget)
    {
        sceneWidget = widget

        if(!sceneWidget)
            return

        sceneWidget.parent = leftPanel
        sceneWidget.anchors.fill = leftPanel
        sceneWidget.visible = visualizationButton.checked
    }

    Item
    {
        id: leftPanel
//        width: parent.width * 0.67
        anchors.margins: 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: rightPanel.left
        anchors.bottom: playerWidget.top

        MfxButton
        {
            id: visualizationButton
            checkable: true
            width: 100
            z: 1
            text: qsTr("Visualization")

            anchors.topMargin: 6
            anchors.leftMargin: 6
            anchors.top: parent.top
            anchors.left: parent.left

            onCheckedChanged:
            {
                if(sceneWidget)
                    checked ? sceneWidget.visible = true : sceneWidget.visible = false
            }

            ButtonGroup.group: leftButtonsGroup
        }

        MfxButton
        {
            id: cueListButton
            checkable: true
            width: 100
            z: 1
            text: qsTr("Cue List")

            anchors.topMargin: 6
            anchors.leftMargin: 2
            anchors.top: parent.top
            anchors.left: visualizationButton.right

            ButtonGroup.group: leftButtonsGroup
        }

        MfxButton
        {
            id: deviceListButton1
            checkable: true
            width: 100
            z: 1
            text: qsTr("Device List")

            anchors.topMargin: 6
            anchors.leftMargin: 2
            anchors.top: parent.top
            anchors.left: cueListButton.right

            ButtonGroup.group: leftButtonsGroup
        }

        ButtonGroup
        {
            id: leftButtonsGroup
            checkedButton: visualizationButton

        }

        MfxButton
        {
            id: cueContentButton
            checkable: true
            width: 100
            z: 1
            text: qsTr("Cue Content")

            anchors.topMargin: 6
            anchors.rightMargin: 2
            anchors.top: parent.top
            anchors.right: deviceListButton2.left

            onClicked:
            {
                if(checked)
                    deviceListButton2.checked = false
            }
        }

        MfxButton
        {
            id: deviceListButton2
            checkable: true
            width: 100
            z: 1
            text: qsTr("Device List")
            checked: true

            anchors.topMargin: 6
            anchors.rightMargin: 6
            anchors.top: parent.top
            anchors.right: parent.right

            onClicked:
            {
                if(checked)
                    cueContentButton.checked = false
            }
        }

        Item
        {
            id: rightWidget

            z: 1
            width: 440
            anchors.topMargin: 2
            anchors.top: cueContentButton.bottom
            anchors.bottom: parent.bottom
            anchors.rightMargin: 2
            anchors.right: parent.right
            visible: cueContentButton.checked || deviceListButton2.checked

            Rectangle
            {
                id: rightWidgetFrame
                anchors.fill: parent
                color: "black"
                radius: 2
                clip: true

                border.width: 2
                border.color: "#444444"


                ListView
                {
                    id: sortedDeviceListView

                    anchors.fill: parent
                    anchors.topMargin: 6
                    anchors.leftMargin: 6
                    spacing: 10
                    ScrollBar.vertical: ScrollBar
                    {
                        policy: ScrollBar.AsNeeded
                        anchors
                        {
                            right: sortedDeviceListView.right
                            top: sortedDeviceListView.top
                            bottom: sortedDeviceListView.bottom
                            rightMargin: -3
                        }
                    }

                    function loadGroups()
                    {
                        groupListModel.append({groupName: "Sequences"})
                        groupListModel.append({groupName: "Dimmer"})
                        groupListModel.append({groupName: "Shot"})
                        groupListModel.append({groupName: "Pyro"})
                    }

                    delegate: Component
                    {
                        Item
                        {
                            id: typeGroup
                            height: collapseButton.checked ? collapseButton.height + deviceListView.contentItem.height + 20 : collapseButton.height
                            property string name: groupName
                            property alias deviceList: deviceListView
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
                                    font.family: "Roboto"
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
                                    font.family: "Roboto"
                                    font.pixelSize: 12
                                }
                            }

                            Item
                            {
                                id: listArea
                                visible: collapseButton.checked
                                x: 18
                                y: 30

                                ListView
                                {
                                    id: deviceListView
                                    anchors.margins: 2
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    width: 392
                                    height: contentItem.height < 10 ? contentItem.height + 30 : contentItem.height
                                    spacing: 2
                                    ScrollBar.vertical: ScrollBar {}

                                    property string groupName: typeGroup.name
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
                                        visible: deviceListView.held && mouseArea.wasPressedAndMoved && !draggedCuePlate.visible
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
                                            font.family: "Roboto"
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

                                        x: draggedPlate.x + draggedPlate.Drag.hotSpot.x
                                        y: draggedPlate.y + draggedPlate.Drag.hotSpot.y

                                        height: 12
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
                                    }

                                    MfxMouseArea
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

                                        drag.minimumX: 0
                                        drag.maximumX: mainScreen.width - draggedPlate.width
                                        drag.minimumY: 0
                                        drag.maximumY: mainScreen.height - draggedPlate.height

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
                                                draggedPlate.x = pressedItem.mapToItem(mainScreen, 0, 0).x
                                                draggedPlate.y = pressedItem.mapToItem(mainScreen, 0, 0).y
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
                                            if(playerWidget.contains(mouseArea.mapToItem(playerWidget, mouseX, mouseY)))
                                            {
                                                draggedCuePlate.visible = true
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
        }
    }

//    MfxMouseArea
//    {
//        id: panelsResizeArea
//        width: 4
//        anchors.top: parent.top
//        anchors.bottom: playerWidget.top
//        anchors.left: leftPanel.right

//        property int previousX

//        cursor: Qt.SizeHorCursor

//        onPressed:
//        {
//            previousX = mouseX
//        }

//        onMouseXChanged:
//        {
//            var dx = mouseX - previousX

//            leftPanel.width += dx
//        }
//    }

    Item
    {
        id: rightPanel

        width: 372
        anchors.top: parent.top
        anchors.bottomMargin: 2
        anchors.bottom: playerWidget.top
        anchors.right: parent.right

        Rectangle
        {
            id: rightPanelBackground
            anchors.fill: parent
            color: "#222222"
        }

        MfxButton
        {
            id: sequencesButton
            checkable: true
            width: 68
            text: qsTr("Sequences")
            textSize: 10

            anchors.top: parent.top
            anchors.left: parent.left

            ButtonGroup.group: rightButtonsGroup
        }

        MfxButton
        {
            id: dimmerButton
            checkable: true
            width: 68
            text: qsTr("Dimmer")
            textSize: 10

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: sequencesButton.right

            ButtonGroup.group: rightButtonsGroup
        }

        MfxButton
        {
            id: shotButton
            checkable: true
            width: 68
            text: qsTr("Shot")
            textSize: 10

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: dimmerButton.right

            ButtonGroup.group: rightButtonsGroup
        }

        MfxButton
        {
            id: pyroButton
            checkable: true
            width: 68
            text: qsTr("Pyro")
            textSize: 10

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: shotButton.right

            ButtonGroup.group: rightButtonsGroup
        }

        MfxButton
        {
            id: cueButton
            checkable: true
            width: 60
            text: qsTr("Cue")
            textSize: 10

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: pyroButton.right

            ButtonGroup.group: rightButtonsGroup
        }

        ButtonGroup
        {
            id: rightButtonsGroup
            checkedButton: sequencesButton

        }

        MfxButton
        {
            id: addButton
            text: qsTr("+")

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: cueButton.right
            anchors.right: parent.right

        }

        Item
        {
            id: actionViewWidget

            anchors.topMargin: 2
            anchors.top: sequencesButton.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            Rectangle
            {
                id: actionViewBackground
                anchors.fill: parent
                color: "#333333"
                radius: 2
            }


            MfxButton
            {
                id: lingericButton
                checkable: true
                width: 72
                height: 26
                text: qsTr("Lingeric")
                textSize: 10

                anchors.top: parent.top
                anchors.left: parent.left

                ButtonGroup.group: actionTypesGroup
            }

            MfxButton
            {
                id: dynamicButton
                checkable: true
                width: 72
                height: 26
                text: qsTr("Dynamic")
                textSize: 10

                anchors.top: parent.top
                anchors.left: lingericButton.right

                ButtonGroup.group: actionTypesGroup
            }

            MfxButton
            {
                id: staticButton
                checkable: true
                width: 72
                height: 26
                text: qsTr("Static")
                textSize: 10

                anchors.top: parent.top
                anchors.left: dynamicButton.right

                ButtonGroup.group: actionTypesGroup
            }

            ButtonGroup
            {
                id: actionTypesGroup
                checkedButton: lingericButton

            }

            Rectangle
            {
                id: actionViewBackground2
                anchors.fill: parent
                color: "#4f4f4f"
                radius: 2

                anchors.topMargin: 24
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                Rectangle
                {
                    id: actionViewBackground3
                    color: "black"

                    anchors.margins: 2
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }

                GridView
                {
                    id: actionView

                    anchors.margins: 2
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    clip: true

                    cellWidth: 60
                    cellHeight: 52

                    model: ListModel
                    {
                        id: actionListModel
                    }

                    delegate: Component
                    {
                        Item
                        {
                            id: actionPlate
                            width: actionView.cellWidth
                            height: actionView.cellHeight

                            property string name: actionName
                            property bool checked: checkedState

                            Rectangle
                            {
                                width: actionView.cellWidth - 4
                                height: actionView.cellHeight - 4
                                id: actionPlateBAckground
                                anchors.centerIn: parent
                                color: "#666666"
                                radius: 2

                                Rectangle
                                {
                                    color: "black"
                                    radius: 2

                                    anchors.topMargin: 2
                                    anchors.bottomMargin: 13
                                    anchors.leftMargin: 2
                                    anchors.rightMargin: 2
                                    anchors.fill: parent

                                    Image
                                    {
                                        source: "qrc:/imagePlaceholder"
                                        anchors.centerIn: parent
                                    }
                                }

                                Text
                                {
                                    id: actionPlateName
                                    text: actionPlate.name

                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideMiddle
                                    color: "#ffffff"
                                    font.family: "Roboto"
                                    font.pixelSize: 10

                                    anchors.bottom: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            Rectangle
                            {
                                width: actionView.cellWidth - 4
                                height: actionView.cellHeight - 4
                                id: actionPlateBorder
                                anchors.centerIn: parent
                                color: "transparent"
                                radius: 2

                                border.width: 2
                                border.color: "#27AE60"

                                visible: parent.checked
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {policy: ScrollBar.AlwaysOn}

                    Item
                    {
                        id: topShadow
                        height: 20
                        width: parent.width
                        anchors.left: parent.left
                        anchors.top: parent.top

                        visible: actionView.contentY > 0

                        LinearGradient
                        {
                            anchors.fill: parent
                            start: Qt.point(0, 0)
                            end: Qt.point(0, parent.height)
                            gradient: Gradient
                            {
                                GradientStop { position: 1.0; color: "#00000000" }
                                GradientStop { position: 0.0; color: "#FF000000" }
                            }
                        }
                    }

                    Item
                    {
                        id: bottomShadow
                        height: 20
                        width: parent.width
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom

                        LinearGradient
                        {
                            anchors.fill: parent
                            start: Qt.point(0, parent.height)
                            end: Qt.point(0, 0)
                            gradient: Gradient
                            {
                                GradientStop { position: 1.0; color: "#00000000" }
                                GradientStop { position: 0.0; color: "#FF000000" }
                            }
                        }
                    }

                    Connections
                    {
                        target: actionsManager
                        function onActionsLoaded()
                        {
                            let actionsList = actionsManager.getActions()

                            actionListModel.clear()
                            actionsList.forEach(function(currAction, index)
                            {
                                actionListModel.insert(index, {actionName: currAction["name"]})
                            })
                        }
                    }

                    MfxMouseArea
                    {
                        id: actionsViewMouseArea

                        anchors.fill: parent

                        onClicked:
                        {
                            let clickedItemName = actionView.itemAt(mouseX, mouseY).name
                            if(clickedItemName)
                            {
                                for(let i = 0; i < actionListModel.count; i++)
                                {
                                    actionListModel.get(i).actionName === clickedItemName ?
                                                actionListModel.setProperty(i, "checkedState", true) : actionListModel.setProperty(i, "checkedState", false)
                                }
                            }
                        }
                    }

                    Component.onCompleted:
                    {
//                        for (let i = 1; i < 81; i++)
//                        {
//                            actionListModel.insert(i - 1, {actionName: "name" + i})
//                        }

                        let actionsList = actionsManager.getActions()

                        actionListModel.clear()
                        actionsList.forEach(function(currAction, index)
                        {
                            actionListModel.insert(index, {actionName: currAction["name"], checkedState: false})
                        })

                        actionsViewMouseArea.parent = actionView.contentItem
                    }
                }
            }
        }
    }

    Player
    {
        id: playerWidget
        height: minHeight
        anchors.margins: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}

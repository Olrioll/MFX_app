import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import MFX.UI.Components.Templates 1.0 as MFXUICT
import MFX.UI.Styles 1.0 as MFXUIS

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
        sceneWidget.visible = true// Временно закомментировали - сцена всегда должна быть видима = visualizationButton.checked
    }

    function checkedActionName()
    {
        return actionView.checkedActionName()
    }

    function adjustBackgroundImageOnX()
    {
        sceneWidget.adjustBackgroundImageOnX()

        if((cueListButton.checked || deviceListButton1.checked) && (cueContentButton.checked || deviceListButton2.checked))
        {

        }

        else if((cueListButton.checked || deviceListButton1.checked) && !(cueContentButton.checked || deviceListButton2.checked))
        {

            sceneWidget.backgroundImage.x += leftWidget.width / 2
        }

        else if(!(cueListButton.checked || deviceListButton1.checked) && (cueContentButton.checked || deviceListButton2.checked))
        {

            sceneWidget.backgroundImage.x -= rightWidget.width / 2
        }
    }

    Item
    {
        id: leftPanel
        anchors.margins: 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: rightPanel.left
        anchors.bottom: playerWidget.top

        MfxButton
        {
            id: visualizationButton
            checkable: true
            checked: true
            width: 100
            z: 1
            text: qsTr("Visualization")

            anchors.topMargin: 6
            anchors.leftMargin: 6
            anchors.top: parent.top
            anchors.left: parent.left

            visible: false // Временно закомментировали - сцена всегда должна быть видима = visualizationButton.checked

            onCheckedChanged:
            {
                if(sceneWidget)
                    checked ? sceneWidget.visible = true : sceneWidget.visible = false
            }
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
            anchors.left: parent.left

            onCheckedChanged:
            {
                if(checked)
                {
                    deviceListButton1.checked = false
                }

                mainScreen.adjustBackgroundImageOnX()
            }
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


            onCheckedChanged:
            {
                if(checked)
                {
                    mainScreenDeviceListWidget.parent = leftWidget
                    deviceListButton2.checked = false
                    cueListButton.checked = false
                }

                mainScreen.adjustBackgroundImageOnX()
            }
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

            onCheckedChanged:
            {
                if(checked)
                    deviceListButton2.checked = false

                mainScreen.adjustBackgroundImageOnX()
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

            onCheckedChanged:
            {
                if(checked)
                {
                    cueContentButton.checked = false
                    mainScreenDeviceListWidget.parent = rightWidget
                    deviceListButton1.checked = false
                }

                mainScreen.adjustBackgroundImageOnX()
            }
        }

        Item
        {
            id: leftWidget

            z: 1
            width: 490
            anchors.topMargin: 2
            anchors.top: cueContentButton.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            anchors.leftMargin: 2
            anchors.left: parent.left
            visible: cueListButton.checked || deviceListButton1.checked

            MfxTable
            {
                id: cueListWidget
                anchors.fill: parent
                visible: cueListButton.checked
            }
        }

        Item
        {
            id: rightWidget

            z: 1
            width: 490
            anchors.topMargin: 2
            anchors.top: cueContentButton.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            anchors.rightMargin: 2
            anchors.right: parent.right
            visible: cueContentButton.checked || deviceListButton2.checked

            Rectangle {
                id: cueContentCalculatorWidget

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: mainScreenCueContentWidget.left
                anchors.rightMargin: 2

                width: 176

                color: "#444444"
                radius:2

                visible: mainScreenCueContentWidget.visible

                Flickable {
                    anchors.fill: parent
                    anchors.topMargin: 8
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.bottomMargin: 8

                    contentHeight: calculatorContentLayout.height

                    clip: true

                    ColumnLayout {
                        id: calculatorContentLayout

                        anchors.left: parent.left
                        anchors.right: parent.right

                        height: childrenRect.height

                        spacing: 0

                        Item {
                            id: calculatorTextInputItem

                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            Layout.maximumHeight: 30
                            Layout.minimumHeight: 30

                            property var operationApplying
                            property int value: 0
                            property var unitMultiplierType: ""
                            property var unitMultiplier: 1

                            Rectangle {
                                anchors.fill: parent

                                radius: 2

                                color: "#222222"
                            }

                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: 4
                                anchors.rightMargin: 4

                                font.family: MFXUIS.Fonts.robotoMedium.objectName
                                font.pixelSize: 12

                                lineHeightMode: Text.FixedHeight
                                lineHeight: 14

                                horizontalAlignment: Qt.AlignRight
                                verticalAlignment: Qt.AlignVCenter

                                color: "#FFFFFF"

                                text: "0"
                            }
                        }

                        MFXUICT.LayoutSpacer {
                            fixedHeight: 4
                        }

                        Grid {
                            id: calculatorButtons

                            Layout.fillWidth: true
                            Layout.preferredHeight: 156
                            Layout.maximumHeight: 156
                            Layout.minimumHeight: 156

                            columns: 4
                            rows: 4

                            rowSpacing: 4
                            columnSpacing: 4

                            Repeater {
                                model: ListModel {
                                    ListElement {
                                        text: "1"
                                        operation: function(){}
                                        highlighted: true
                                    }
                                    ListElement {
                                        text: "2"
                                        operation: function(){}
                                        highlighted: true
                                    }
                                    ListElement {
                                        text: "3"
                                        operation: function(){}
                                        highlighted: true
                                    }
                                    ListElement {
                                        text: "*"
                                        operation: function(){}
                                        highlighted: false
                                    }
                                    ListElement {
                                        text: "4"
                                        operation: function(){}
                                        highlighted: true
                                    }
                                    ListElement {
                                        text: "5"
                                        operation: function(){}
                                        highlighted: true
                                    }
                                    ListElement {
                                        text: "6"
                                        operation: function(){}
                                        highlighted: true
                                    }
                                    ListElement {
                                        text: "/"
                                        operation: function(){}
                                        highlighted: false
                                    }
                                    ListElement {
                                        text: "7"
                                        operation: function(){}
                                        highlighted: true
                                    }
                                    ListElement {
                                        text: "8"
                                        operation: function(){}
                                        highlighted: true
                                    }
                                    ListElement {
                                        text: "9"
                                        operation: function(){}
                                        highlighted: true
                                    }
                                    ListElement {
                                        text: "%"
                                        operation: function(){}
                                        highlighted: false
                                    }
                                    ListElement {
                                        text: "-"
                                        operation: function(){}
                                        highlighted: false
                                    }
                                    ListElement {
                                        text: "0"
                                        operation: function(){}
                                        highlighted: true
                                    }
                                    ListElement {
                                        text: "+"
                                        operation: function(){}
                                        highlighted: false
                                    }
                                    ListElement {
                                        text: "C"
                                        operation: function(){}
                                        highlighted: false
                                    }
                                }

                                delegate: Button {
                                    id: calculatorButton

                                    width: 36
                                    height: 36

                                    background: Rectangle {
                                        color: model.highlighted ? calculatorButton.enabled ? "#888888" : "#80888888" : calculatorButton.enabled ? "#666666" : "#80666666"

                                        radius: 2

                                        layer.enabled: true
                                        layer.effect: DropShadow {
                                            horizontalOffset: 0
                                            verticalOffset: 1
                                            radius: 4
                                            samples: 9
                                            spread: 0
                                            color: "#40000000"
                                        }

                                        Rectangle {
                                            anchors.fill: parent

                                            radius: parent.radius

                                            color: "#24FFFFFF"

                                            visible: calculatorButton.pressed
                                        }
                                    }

                                    contentItem: Text {
                                        font.family: MFXUIS.Fonts.robotoMedium.name
                                        font.pixelSize: 10

                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: 12

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        color: calculatorButton.enabled ? "#FFFFFF" : "#80FFFFFF"

                                        text: model.text
                                    }

                                    onClicked: {
                                        model.operation()
                                    }
                                }
                            }
                        }

                        MFXUICT.LayoutSpacer {
                            fixedHeight: 6
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 24
                            Layout.maximumHeight: 24
                            Layout.minimumHeight: 24

                            spacing: 3

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                MfxButton
                                {
                                    id: minutesButton

                                    anchors.fill: parent

                                    checkable: false

                                    fontFamilyName: MFXUIS.Fonts.robotoMedium.name
                                    enableShadow: true
                                    textSize: 10
                                    color: "#888888"
                                    pressedColor: "#ababab"

                                    text: qsTr("min")

                                    onClicked: {
                                        //TODO реализовать
                                    }
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                MfxButton
                                {
                                    id: secondsButton

                                    anchors.fill: parent

                                    checkable: false

                                    fontFamilyName: MFXUIS.Fonts.robotoMedium.name
                                    enableShadow: true
                                    textSize: 10
                                    color: "#888888"
                                    pressedColor: "#ababab"

                                    text: qsTr("sec")

                                    onClicked: {
                                        //TODO реализовать
                                    }
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                MfxButton
                                {
                                    id: msecondsButton

                                    anchors.fill: parent

                                    checkable: false

                                    fontFamilyName: MFXUIS.Fonts.robotoMedium.name
                                    enableShadow: true
                                    textSize: 10
                                    color: "#888888"
                                    pressedColor: "#ababab"

                                    text: qsTr("ms")

                                    onClicked: {
                                        //TODO реализовать
                                    }
                                }
                            }
                        }

                        MFXUICT.LayoutSpacer {
                            fixedHeight: 20
                        }

                        Grid {
                            Layout.fillWidth: true
                            Layout.preferredHeight: childrenRect.height
                            Layout.maximumHeight: childrenRect.height
                            Layout.minimumHeight: childrenRect.height

                            columns: 2
                            rows: children.length / 2

                            rowSpacing: 4
                            columnSpacing: 4

                            Repeater {
                                model: ListModel {
                                    id: propertyModel

                                    ListElement { text: qsTr("Delay"); callback: function() {}; enabled: true}
                                    ListElement { text: qsTr("Between"); callback: function() {}; enabled: false }
                                    ListElement { text: qsTr("Action"); callback: function() {}; enabled: true }
                                    ListElement { text: qsTr("Time"); callback: function() {}; enabled: true }
                                }

                                delegate: MfxButton {
                                    width: 76
                                    height: 24

                                    checkable: false

                                    fontFamilyName: MFXUIS.Fonts.robotoMedium.name
                                    textSize: 10
                                    color: "#2F80ED"
                                    pressedColor: "#649ce8"
                                    disabledColor: "#80649ce8"
                                    disabledTextColor: "#80ffffff"

                                    enabled: model.enabled

                                    text: model.text

                                    onClicked: {
                                        model.callback()
                                    }
                                }
                            }
                        }

                        MFXUICT.LayoutSpacer {
                            fixedHeight: 20
                        }

                        Grid {
                            Layout.fillWidth: true
                            Layout.preferredHeight: childrenRect.height
                            Layout.maximumHeight: childrenRect.height
                            Layout.minimumHeight: childrenRect.height

                            columns: 2
                            rows: children.length / 2

                            rowSpacing: 4
                            columnSpacing: 4

                            Repeater {
                                model: ListModel {
                                    ListElement { text: qsTr("Forward"); callback: function() {}; }
                                    ListElement { text: qsTr("Backward"); callback: function() {};  }
                                    ListElement { text: qsTr("Inside"); callback: function() {};  }
                                    ListElement { text: qsTr("Outside"); callback: function() {};  }
                                    ListElement { text: qsTr("Mirror"); callback: function() {};  }
                                    ListElement { text: qsTr("Random"); callback: function() {};  }
                                }

                                delegate: MfxButton {
                                    width: 76
                                    height: 24

                                    checkable: false

                                    fontFamilyName: MFXUIS.Fonts.robotoMedium.name
                                    enableShadow: true
                                    textSize: 10
                                    color: "#888888"
                                    pressedColor: "#ababab"

                                    text: model.text

                                    onClicked: {
                                        model.callback()
                                    }
                                }
                            }
                        }

                        MFXUICT.LayoutSpacer {}
                    }

                }
            }

            Rectangle
            {
                id: mainScreenCueContentWidget
                anchors.fill: parent
                color: "#444444"
                radius: 2
                clip: true

                visible: cueContentButton.checked

                Rectangle {
                    anchors.fill: parent
                    anchors.topMargin: 32
                    anchors.bottomMargin: 2
                    anchors.leftMargin: 2
                    anchors.rightMargin: 2

                    radius: 2

                    color: "#222222"

                    RowLayout {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottomMargin: 2
                        anchors.leftMargin: 2
                        anchors.rightMargin: 2

                        height: 20

                        spacing: 2

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            MfxButton
                            {
                                id: leftButton

                                anchors.fill: parent
                                checkable: false

                                text: qsTr("Left")

                                onClicked: {
                                    //TODO реализовать
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            MfxButton
                            {
                                id: unevenButton

                                anchors.fill: parent

                                checkable: false

                                text: qsTr("Uneven")

                                onClicked: {
                                    //TODO реализовать
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            MfxButton
                            {
                                id: allButton

                                anchors.fill: parent

                                checkable: false

                                text: qsTr("All")

                                onClicked: {
                                    //TODO реализовать
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            MfxButton
                            {
                                id: evenButton

                                anchors.fill: parent

                                checkable: false

                                text: qsTr("Even")

                                onClicked: {
                                    //TODO реализовать
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            MfxButton
                            {
                                id: rightButton

                                anchors.fill: parent

                                checkable: false

                                text: qsTr("Right")

                                onClicked: {
                                    //TODO реализовать
                                }
                            }
                        }
                    }
                }

                ListView {
                    id: cueContentTableListView

                    anchors.fill: parent
                    anchors.leftMargin: 2
                    anchors.rightMargin: 2
                    anchors.bottomMargin: 26

                    clip: true

                    headerPositioning: ListView.OverlayHeader

                    header: Item {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 30

                        z: 2

                        Rectangle {
                            anchors.fill: parent
                            anchors.bottomMargin: -2
                            radius: 2

                            color: "#444444"
                        }
                    }

                    model: 9

                    delegate: Item {
                        id: cueContentTableListViewRow

                        anchors.left: parent.left
                        anchors.right: parent.right

                        height: 30

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.leftMargin: 2
                            anchors.rightMargin: 2

                            height: 1

                            color: "#66000000"
                        }
                    }
                }
            }

            Rectangle
            {
                id: mainScreenDeviceListWidget
                anchors.fill: parent
                color: "black"
                radius: 2
                clip: true

                border.width: 2
                border.color: "#444444"

                visible: deviceListButton1.checked || deviceListButton2.checked

                MfxButton
                {
                    id: devicesButton
                    height: 24
                    text: qsTr("Devices")
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
                    text: qsTr("Groups")
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

                        delegate: Item
                            {
                                id: typeGroup
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
                                        font.family: MFXUIS.Fonts.robotoRegular.name
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
                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 12
                                    }
                                }

                                Item
                                {
                                    id: listArea
                                    visible: collapseButton.checked
                                    x: 18
                                    y: 30

                                    property alias deviceListView: deviceListView

                                    ListView
                                    {
                                        id: deviceListView
                                        anchors.margins: 2
                                        anchors.top: parent.top
                                        anchors.left: parent.left
                                        width: 392
                                        height: contentItem.height < 10 ? contentItem.height + 30 : contentItem.height
                                        spacing: 2
                                        interactive: false

                                        ScrollBar.vertical: ScrollBar {}

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
                                            property string intersectionState: draggedCuePlate.state

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
                                                font.family: MFXUIS.Fonts.robotoRegular.name
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

                                                    if(!draggedPlate.checkedIDs.includes(pressedItem.patchId))
                                                        draggedPlate.checkedIDs.push(pressedItem.patchId)

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

                                                    // Проверяем, накладывемся ли на какую-нибудь плашку
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
                        font.family: MFXUIS.Fonts.robotoRegular.name
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

                            // Проверяем, накладывемся ли на какую-нибудь плашку
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


//            MfxButton
//            {
//                id: lingericButton
//                checkable: true
//                width: 72
//                height: 26
//                text: qsTr("Lingeric")
//                textSize: 10

//                anchors.top: parent.top
//                anchors.left: parent.left

//                ButtonGroup.group: actionTypesGroup
//            }

//            MfxButton
//            {
//                id: dynamicButton
//                checkable: true
//                width: 72
//                height: 26
//                text: qsTr("Dynamic")
//                textSize: 10

//                anchors.top: parent.top
//                anchors.left: lingericButton.right

//                ButtonGroup.group: actionTypesGroup
//            }

//            MfxButton
//            {
//                id: staticButton
//                checkable: true
//                width: 72
//                height: 26
//                text: qsTr("Static")
//                textSize: 10

//                anchors.top: parent.top
//                anchors.left: dynamicButton.right

//                ButtonGroup.group: actionTypesGroup
//            }

//            ButtonGroup
//            {
//                id: actionTypesGroup
//                checkedButton: lingericButton

//            }

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

                    function checkedActionName()
                    {
                        for(let i = 0; i < actionListModel.count; i++)
                        {
                            if(actionListModel.get(i).checkedState)
                            {
                                return actionListModel.get(i).actionName
                            }
                        }

                        return ""
                    }

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
                                    font.family: MFXUIS.Fonts.robotoRegular.name
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

//                        signal actionChecked(string actionName)

                        onClicked:
                        {
                            let clickedItemName = actionView.itemAt(mouseX, mouseY).name
                            if(clickedItemName)
                            {
                                for(let i = 0; i < actionListModel.count; i++)
                                {
                                    if(actionListModel.get(i).actionName === clickedItemName)
                                    {
                                        actionListModel.setProperty(i, "checkedState", true)
                                        let checkedPatches = project.checkedPatchesList()

                                        checkedPatches.forEach(function(patchId)
                                        {
                                           project.setPatchProperty(patchId, "act", clickedItemName);
                                        })
                                    }

                                    else
                                    {
                                        actionListModel.setProperty(i, "checkedState", false)
                                    }
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

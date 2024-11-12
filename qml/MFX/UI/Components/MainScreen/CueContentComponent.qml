import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml.Models 2.12

import MFX.Enums 1.0
import MFX.UI.Components.Basic 1.0

Component
{
    Rectangle
    {
        id: mainScreenCueContentWidget

        objectName: "cue_content"

        function processPatternPanelActionSelected(actionName)
        {
            cueContentManager.replaceActionForSelectedItemsRequest(actionName);
        }

        color: "#444444"
        radius: 2
        clip: true

        MouseArea {
            anchors.fill: parent

            propagateComposedEvents: false
            preventStealing: true

            onWheel: (wheel) => {
                            wheel.accepted = true
                        }
        }

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

                        text: translationsManager.translationTrigger + qsTr("First")

                        enabled: true //cueContentManager.selectedTableRole !== CueContentSelectedTableRole.Unknown
                        disabledColor: "#804f4f4f"
                        disabledTextColor: "#30ffffff"
                        onClicked: {
                            cueContentManager.onSelectLeftItemsRequest();
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

                        text: translationsManager.translationTrigger + qsTr("Uneven")

                        enabled:  true //cueContentManager.selectedTableRole !== CueContentSelectedTableRole.Unknown

                        disabledColor: "#804f4f4f"
                        disabledTextColor: "#30ffffff"

                        onClicked: {
                            cueContentManager.onSelectUnevenItemsRequest();
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

                        text: translationsManager.translationTrigger + qsTr("All")

                        enabled:  true //cueContentManager.selectedTableRole !== CueContentSelectedTableRole.Unknown

                        disabledColor: "#804f4f4f"
                        disabledTextColor: "#30ffffff"

                        onClicked: {
                            cueContentManager.onSelectAllItemsRequest();
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

                        text: translationsManager.translationTrigger + qsTr("Even")

                        enabled:  true //cueContentManager.selectedTableRole !== CueContentSelectedTableRole.Unknown

                        disabledColor: "#804f4f4f"
                        disabledTextColor: "#30ffffff"

                        onClicked: {
                            cueContentManager.onSelectEvenItemsRequest();
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

                        text: translationsManager.translationTrigger + qsTr("Last")

                        enabled:  true //cueContentManager.selectedTableRole !== CueContentSelectedTableRole.Unknown

                        disabledColor: "#804f4f4f"
                        disabledTextColor: "#30ffffff"

                        onClicked: {
                            cueContentManager.onSelectRightItemsRequest();
                        }
                    }
                }
            }
        }

        Keys.onEscapePressed:
        {
            cueContentManager.cleanSelectionRequest()
        }

        DelegateModel
        {
            id:visualModel
            model:cueContentManager.cueContentSorted
            delegate: FocusScope
            {

                id: cueContentListViewDelegate

                property int rowIndex: model.index
                property int rowNumber: rowIndex + 1
                property string delay: model.delayTimeDecorator
                property string between: model.betweenTimeDecorator
                property var rfChannel: model.rfChannel
                property var device: model.device
                property var dmxSlot: model.dmxSlot
                property var action: model.action
                property var effect: model.effect
                property var angle: model.angle
                property string time: model.timeTimeDecorator
                property string prefire: model.prefireTimeDecorator

                property bool active: model.active
                property bool selected: model.selected

                property color activeTextColor: "#F2C94C"
                property color activeBackgroundColor: "#1AFFFAFA"

                property color selectedRoleTextColor: "#27AE60"

                property color selectedTextColor: "#FFFFFF"
                property color selectedBackgroundColor: "#802F80ED"

                property color textColor: "#FFFFFF"
                property color backgroundColor: "transparent"

                Keys.onEscapePressed: {
                    cueContentManager.cleanSelectionRequest()
                }

                QtObject {
                    id: cueContentListViewDelegatePrivateProperties

                    property color calculatedBackgroundColor: cueContentListViewDelegate.active ? cueContentListViewDelegate.activeBackgroundColor
                                                                                                : cueContentListViewDelegate.selected ? cueContentListViewDelegate.selectedBackgroundColor
                                                                                                                                        : cueContentListViewDelegate.backgroundColor
                    property color calculatedTextColor: cueContentListViewDelegate.active ? cueContentListViewDelegate.activeTextColor
                                                                                            : cueContentListViewDelegate.selected ? cueContentListViewDelegate.selectedTextColor
                                                                                                                                : cueContentListViewDelegate.textColor
                    function calculateTextColor(currentRole) {
                        return cueContentListViewDelegate.active ? cueContentListViewDelegate.activeTextColor
                                                                    : cueContentListViewDelegate.selected ? currentRole ? cueContentListViewDelegate.selectedRoleTextColor
                                                                                                                        : cueContentListViewDelegate.selectedTextColor
                        : cueContentListViewDelegate.textColor
                    }
                }

                anchors.left: cueContentTableListView.contentItem.left
                anchors.right: cueContentTableListView.contentItem.right

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

                Rectangle {
                    anchors.fill: parent

                    color: cueContentListViewDelegatePrivateProperties.calculatedBackgroundColor

                    Behavior on color { ColorAnimation { duration: 1 } }
                }

                RowLayout {
                    anchors.fill: parent

                    spacing: 0

                    Text {

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueContentTableListView.columnWidths[0]
                        Layout.maximumWidth: cueContentTableListView.columnWidths[0]
                        Layout.minimumWidth: cueContentTableListView.columnWidths[0]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.family: MFXUIS.Fonts.robotoRegular.name
                        font.pixelSize: 10

                        color: cueContentListViewDelegatePrivateProperties.calculatedTextColor

                        text: cueContentListViewDelegate.rowNumber

                        Behavior on color { ColorAnimation { duration: 250 } }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 5

                        color: "#1FFFFFFF"
                    }

                    Text {
                        id: timingTypeValueItem

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueContentTableListView.columnWidths[1]
                        Layout.maximumWidth: cueContentTableListView.columnWidths[1]
                        Layout.minimumWidth: cueContentTableListView.columnWidths[1]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.family: MFXUIS.Fonts.robotoRegular.name
                        font.pixelSize: 10

                        property bool currentRole: cueContentManager.timingTypeSelectedTableRole === cueContentManager.selectedTableRole

                        color: cueContentListViewDelegatePrivateProperties.calculateTextColor(currentRole)

                        text: {
                            switch(cueContentManager.timingTypeSelectedTableRole) {
                            case CueContentSelectedTableRole.Delay:
                                return cueContentListViewDelegate.delay
                            case CueContentSelectedTableRole.Between:
                                return cueContentListViewDelegate.between
                            }
                            return qsTr("---")
                        }

                        Behavior on color { ColorAnimation { duration: 250 } }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 5

                        color: "#1FFFFFFF"
                    }

                    Text {
                        id: deviceTypeValueItem

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueContentTableListView.columnWidths[2]
                        Layout.maximumWidth: cueContentTableListView.columnWidths[2]
                        Layout.minimumWidth: cueContentTableListView.columnWidths[2]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.family: MFXUIS.Fonts.robotoRegular.name
                        font.pixelSize: 10

                        property bool currentRole: cueContentManager.deviceTypeSelectedTableRole === cueContentManager.selectedTableRole

                        color: cueContentListViewDelegatePrivateProperties.calculateTextColor(currentRole)

                        text: {
                            switch(cueContentManager.deviceTypeSelectedTableRole) {
                            case CueContentSelectedTableRole.RfChannel:
                                return cueContentListViewDelegate.rfChannel
                            case CueContentSelectedTableRole.Device:
                                return cueContentListViewDelegate.device
                            case CueContentSelectedTableRole.DmxChannel:
                                return cueContentListViewDelegate.dmxSlot
                            }
                            return qsTr("---")
                        }

                        Behavior on color { ColorAnimation { duration: 250 } }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 5
                        color: "#1FFFFFFF"
                    }

                    Text {
                        id: actionTypeValueItem

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueContentTableListView.columnWidths[3]
                        Layout.maximumWidth: cueContentTableListView.columnWidths[3]
                        Layout.minimumWidth: cueContentTableListView.columnWidths[3]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.family: MFXUIS.Fonts.robotoRegular.name
                        font.pixelSize: 10

                        property bool currentRole: cueContentManager.actionTypeSelectedTableRole === cueContentManager.selectedTableRole
                        color: cueContentListViewDelegatePrivateProperties.calculateTextColor(currentRole)

                        text: {
                            switch(cueContentManager.actionTypeSelectedTableRole) {
                            case CueContentSelectedTableRole.Action:
                                return cueContentListViewDelegate.action
                            case CueContentSelectedTableRole.Angle:
                                return cueContentListViewDelegate.angle
                            case CueContentSelectedTableRole.Effect:
                                return cueContentListViewDelegate.effect
                            }
                            return qsTr("---")
                        }

                        Behavior on color { ColorAnimation { duration: 250 } }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 5
                        color: "#1FFFFFFF"
                    }

                    Text {
                        id: durationTypeValueItem

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueContentTableListView.columnWidths[4]
                        Layout.maximumWidth: cueContentTableListView.columnWidths[4]
                        Layout.minimumWidth: cueContentTableListView.columnWidths[4]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.family: MFXUIS.Fonts.robotoRegular.name
                        font.pixelSize: 10

                        property bool currentRole: cueContentManager.durationTypeSelectedTableRole === cueContentManager.selectedTableRole

                        color: cueContentListViewDelegatePrivateProperties.calculateTextColor(currentRole)

                        text: {
                            switch(cueContentManager.durationTypeSelectedTableRole)
                            {
                                case CueContentSelectedTableRole.Time:
                                    return cueContentListViewDelegate.time
                                case CueContentSelectedTableRole.Prefire:
                                    return cueContentListViewDelegate.prefire
                            }
                            return qsTr("---")
                        }

                        Behavior on color { ColorAnimation { duration: 250 } }
                    }
                }

                Drag.active: dragArea.held
                Drag.source: cueContentListViewDelegate
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2
                MouseArea
                {
                    anchors.fill: parent
                    id:dragArea

                    propagateComposedEvents: true
                    preventStealing: false

                    onClicked: {
                        console.log(model.selected)
                        model.selected = !model.selected;
                        if(model.selected){
                            project.uncheckPatch();
                        }

                        cueContentListViewDelegate.forceActiveFocus()
                    }

                    property bool held: false

                    anchors { left: parent.left; right: parent.right }
                    drag.target: held ? cueContentListViewDelegate : undefined
                    drag.axis: Drag.YAxis
                    onReleased: held = false

                    DropArea {
                        anchors { fill: parent; margins: 10 }
                        onDropped: {
                            console.log("onDrop",drag.source.name)
                            model.action = drag.source.name
                            project.changeAction(cueName,model.device,drag.source.name)
                            model.selected = false;
                            return;
                        }
                        onEntered:
                        {
                            console.log("onEnter",drag.source.name,containsDrag)
                            if(drag.source.name)
                            {
                                model.selected = true;
                                if(model.selected)
                                    project.uncheckPatch();
                            }
                        }
                        onExited:
                        {
                            if(drag.source.name)
                                model.selected = false;
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

            property int columnsCount: 5
            property var columnProportions: [1, 2, 2, 2, 2]
            property var columnWidths: [0, 0, 0, 0, 0]

            function calculateColumnWidths(width) {
                return columnProportions.map(function(columnProportion) {
                    return (width - (columnsCount - 1)) * (columnProportion / cueContentTableListView.columnProportions.reduce((a, b) => a + b, 0))
                });
            }

            Component.onCompleted: {
                cueContentTableListView.columnWidths = cueContentTableListView.calculateColumnWidths(cueContentTableListView.width)
            }

            onWidthChanged: {
                cueContentTableListView.columnWidths = cueContentTableListView.calculateColumnWidths(cueContentTableListView.width)
            }

            clip: true

            headerPositioning: ListView.OverlayHeader
            spacing: 1
            orientation: Qt.Vertical
            MouseArea{
                anchors.fill: parent;
                z:-1
                onClicked: {
                    cueContentManager.onDeselecAllItemsRequest();
                }
            }

            header: FocusScope {
                id: headerItem

                anchors.left: parent.left
                anchors.right: parent.right
                height: 30

                z: 2

                Keys.onEscapePressed: {
                    cueContentManager.cleanSelectionRequest()
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.bottomMargin: -2
                    radius: 2

                    color: "#444444"
                }

                RowLayout
                {
                    anchors.fill: parent

                    spacing: 0

                    SelectableTableHeaderItem
                    {
                        id: cueContentNumber

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueContentTableListView.columnWidths[0]
                        Layout.maximumWidth: cueContentTableListView.columnWidths[0]
                        Layout.minimumWidth: cueContentTableListView.columnWidths[0]

                        currentIndex: 0

                        model: ListModel
                        {
                            ListElement { value: 0; text: qsTr("¹") }
                        }

                        switchable: false
                        allowSorting: false

                        MouseArea
                        {
                            anchors.fill: parent
                            onDoubleClicked:
                            {
                                cueContentManager.onSortFromHeaderRequest(CueContentSelectedTableRole.Delay, CueContentSortingType.Ascending)
                                cueContentManager.cleanSelectionRequest()

                                timingTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                                deviceTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                                actionTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                                durationTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                            }
                        }
                    }

                    Rectangle
                    {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 4

                        color: "#1FFFFFFF"
                    }

                    SelectableTableHeaderItem
                    {
                        id: timingTypeHeaderItem

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueContentTableListView.columnWidths[1]
                        Layout.maximumWidth: cueContentTableListView.columnWidths[1]
                        Layout.minimumWidth: cueContentTableListView.columnWidths[1]

                        model: ListModel {
                            id: timingTypeHeaderModel
                        }

                        property bool isLoading: true

                        onCurrentIndexChanged: {
                            if(!isLoading) {
                                cueContentManager.onTimingTypeSelectedTableRoleChangeRequest(timingTypeHeaderItem.value)
                            }
                        }

                        onSelectRequest: {
                            cueContentManager.onSelectAllFromHeaderRequest(timingTypeHeaderItem.value)
                        }

                        onDeselectRequest: {
                            cueContentManager.onDeselectAllFromHeaderRequest(timingTypeHeaderItem.value)
                        }

                        onSortRequest: {
                            cueContentManager.onSortFromHeaderRequest(timingTypeHeaderItem.value, timingTypeHeaderItem.sortingType)

                            deviceTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                            actionTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                            durationTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                        }

                        Component.onCompleted: {
                            timingTypeHeaderModel.append({ "value": CueContentSelectedTableRole.Delay, "text": qsTr("Delay") })
                            timingTypeHeaderModel.append({ "value": CueContentSelectedTableRole.Between, "text": qsTr("Between") })
                            timingTypeHeaderItem.setValue(cueContentManager.timingTypeSelectedTableRole)

                            isLoading = false;
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 4

                        color: "#1FFFFFFF"
                    }

                    SelectableTableHeaderItem
                    {
                        id: deviceTypeHeaderItem

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueContentTableListView.columnWidths[2]
                        Layout.maximumWidth: cueContentTableListView.columnWidths[2]
                        Layout.minimumWidth: cueContentTableListView.columnWidths[2]

                        model: ListModel {
                            id: deviceTypeHeaderModel
                        }

                        property bool isLoading: true

                        onCurrentIndexChanged: {
                            if(!isLoading) {
                                cueContentManager.onDeviceTypeSelectedTableRoleChangeRequest(deviceTypeHeaderItem.value)
                            }
                        }

                        onSelectRequest: {
                            cueContentManager.onSelectAllFromHeaderRequest(deviceTypeHeaderItem.value)
                        }

                        onDeselectRequest: {
                            cueContentManager.onDeselectAllFromHeaderRequest(deviceTypeHeaderItem.value)
                        }

                        onSortRequest: {
                            cueContentManager.onSortFromHeaderRequest(deviceTypeHeaderItem.value, deviceTypeHeaderItem.sortingType)

                            timingTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                            actionTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                            durationTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                        }

                        Component.onCompleted: {
                            deviceTypeHeaderModel.append({ "value": CueContentSelectedTableRole.RfChannel, "text": qsTr("RF ch") })
                            deviceTypeHeaderModel.append({ "value": CueContentSelectedTableRole.Device, "text": qsTr("Device") })
                            deviceTypeHeaderModel.append({ "value": CueContentSelectedTableRole.DmxChannel, "text": qsTr("DMX ch") })
                            deviceTypeHeaderItem.setValue(cueContentManager.deviceTypeSelectedTableRole)

                            isLoading = false;
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 4

                        color: "#1FFFFFFF"
                    }

                    SelectableTableHeaderItem
                    {
                        id: actionTypeHeaderItem

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueContentTableListView.columnWidths[3]
                        Layout.maximumWidth: cueContentTableListView.columnWidths[3]
                        Layout.minimumWidth: cueContentTableListView.columnWidths[3]

                        model: ListModel {
                            id: actionTypeHeaderModel
                        }

                        property bool isLoading: true

                        onCurrentIndexChanged: {
                            if(!isLoading) {
                                cueContentManager.onActionTypeSelectedTableRoleChangeRequest(actionTypeHeaderItem.value)
                            }
                        }

                        onSelectRequest: {
                            cueContentManager.onSelectAllFromHeaderRequest(actionTypeHeaderItem.value)
                        }

                        onDeselectRequest: {
                            cueContentManager.onDeselectAllFromHeaderRequest(actionTypeHeaderItem.value)
                        }

                        onSortRequest: {
                            cueContentManager.onSortFromHeaderRequest(actionTypeHeaderItem.value, actionTypeHeaderItem.sortingType)

                            timingTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                            deviceTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                            durationTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                        }

                        Component.onCompleted: {
                            actionTypeHeaderModel.append({ "value": CueContentSelectedTableRole.Effect, "text": qsTr("Effect") })
                            actionTypeHeaderModel.append({ "value": CueContentSelectedTableRole.Action, "text": qsTr("Action") })
                            actionTypeHeaderModel.append({ "value": CueContentSelectedTableRole.Angle, "text": qsTr("Angle") })
                            actionTypeHeaderItem.setValue(cueContentManager.actionTypeSelectedTableRole)

                            isLoading = false;
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 4

                        color: "#1FFFFFFF"
                    }

                    SelectableTableHeaderItem
                    {
                        id: durationTypeHeaderItem

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueContentTableListView.columnWidths[4]
                        Layout.maximumWidth: cueContentTableListView.columnWidths[4]
                        Layout.minimumWidth: cueContentTableListView.columnWidths[4]

                        model: ListModel {
                            id: durationTypeHeaderModel
                        }

                        property bool isLoading: true

                        onCurrentIndexChanged: {
                            if(!isLoading) {
                                cueContentManager.onDurationTypeSelectedTableRoleChangeRequest(durationTypeHeaderItem.value)
                            }
                        }

                        onSelectRequest: {
                            cueContentManager.onSelectAllFromHeaderRequest(durationTypeHeaderItem.value)
                        }

                        onDeselectRequest: {
                            cueContentManager.onDeselectAllFromHeaderRequest(durationTypeHeaderItem.value)
                        }

                        onSortRequest: {
                            cueContentManager.onSortFromHeaderRequest(durationTypeHeaderItem.value, durationTypeHeaderItem.sortingType)

                            timingTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                            deviceTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                            actionTypeHeaderItem.sortingType = CueContentSortingType.Unknown
                        }

                        Component.onCompleted: {
                            durationTypeHeaderModel.append({ "value": CueContentSelectedTableRole.Time, "text": qsTr("Time") })
                            durationTypeHeaderModel.append({ "value": CueContentSelectedTableRole.Prefire, "text": qsTr("Prefire") })
                            durationTypeHeaderItem.setValue(cueContentManager.durationTypeSelectedTableRole)

                            isLoading = false;
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    propagateComposedEvents: true
                    preventStealing: false

                    onClicked: {
                        mouse.accepted = false;
                        if(!headerItem.activeFocus) {
                            headerItem.forceActiveFocus()
                        }
                    }

                    onPressed: {
                        mouse.accepted = false;
                    }

                    onReleased: {
                        mouse.accepted = false;
                    }
                }
            }

            model: visualModel
        }
    }
}
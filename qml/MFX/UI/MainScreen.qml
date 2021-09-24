import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import MFX.UI.Components.Basic 1.0 as MFXUICB
import MFX.UI.Components.Templates 1.0 as MFXUICT
import MFX.Enums 1.0 as MFXE
import MFX.Models 1.0 as MDFM
import MFX.UI.Styles 1.0 as MFXUIS

import "qrc:/"

FocusScope
{
    id: mainScreen

    property var sceneWidget: null
    property alias playerWidget: playerWidget

    focus: true

    function setupSceneWidget(widget)
    {
        sceneWidget = widget

        if(!sceneWidget)
            return

        sceneWidget.parent = sceneWidgetContainer
        sceneWidget.anchors.fill = sceneWidgetContainer
        sceneWidget.anchors.topMargin = 33
        sceneWidget.anchors.rightMargin = 5
        sceneWidget.anchors.leftMargin = 5
        sceneWidget.anchors.bottomMargin = 5
        sceneWidget.visible = true// Временно закомментировали - сцена всегда должна быть видима = visualizationButton.checked
    }

    function adjustBackgroundImageOnX()
    {
        sceneWidget.adjustBackgroundImageOnX()

        if((cueListButton.checked || leftDeviceListButton.checked) && (actionstButton.checked || rightDeviceListButton.checked))
        {

        }

        else if((cueListButton.checked || leftDeviceListButton.checked) && !(actionstButton.checked || rightDeviceListButton.checked))
        {

            sceneWidget.backgroundImage.x += leftPanelLoader.width / 2
        }

        else if(!(cueListButton.checked || leftDeviceListButton.checked) && (actionstButton.checked || rightDeviceListButton.checked))
        {

            sceneWidget.backgroundImage.x -= rightPanelLoader.width / 2
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

        Item {
            id: sceneWidgetContainer

            anchors.fill: parent
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 5

            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 24
                Layout.maximumHeight: 24
                Layout.minimumHeight: 24

                spacing: 2

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100
                    Layout.maximumWidth: 100
                    Layout.minimumWidth: 100

                    visible: false // Временно закомментировали - сцена всегда должна быть видима = visualizationButton.checked

                    MfxButton
                    {
                        id: visualizationButton

                        anchors.fill: parent

                        checkable: true
                        checked: true
                        //z: 1
                        text: translationsManager.translationTrigger + qsTr("Visualization")

                        onCheckedChanged:
                        {
                            if(sceneWidget)
                                checked ? sceneWidget.visible = true : sceneWidget.visible = false
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100
                    Layout.maximumWidth: 100
                    Layout.minimumWidth: 100

                    MfxButton
                    {
                        id: cueListButton

                        anchors.fill: parent

                        checkable: true
                        //z: 1
                        text: translationsManager.translationTrigger + qsTr("Cue List")

                        onCheckedChanged:
                        {
                            if(checked)
                            {
                                leftDeviceListButton.checked = false
                            }

                            mainScreen.adjustBackgroundImageOnX()
                        }
                    }

                }

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100
                    Layout.maximumWidth: 100
                    Layout.minimumWidth: 100

                    MfxButton
                    {
                        id: leftDeviceListButton

                        anchors.fill: parent

                        checkable: true
                        //z: 1
                        text: translationsManager.translationTrigger + qsTr("Device List")

                        onCheckedChanged:
                        {
                            if(checked)
                            {
                                rightDeviceListButton.checked = false
                                cueListButton.checked = false
                            }

                            mainScreen.adjustBackgroundImageOnX()
                        }
                    }
                }

                MFXUICT.LayoutSpacer {}

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100
                    Layout.maximumWidth: 100
                    Layout.minimumWidth: 100

                    MfxButton
                    {
                        id: actionstButton

                        anchors.fill: parent

                        checkable: true
                        //z: 1
                        text: translationsManager.translationTrigger + qsTr("Cue Content")

                        onCheckedChanged:
                        {
                            if(checked)
                                rightDeviceListButton.checked = false

                            mainScreen.adjustBackgroundImageOnX()
                        }
                    }

                }

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100
                    Layout.maximumWidth: 100
                    Layout.minimumWidth: 100

                    MfxButton
                    {
                        id: rightDeviceListButton

                        anchors.fill: parent

                        checkable: true
                        //z: 1
                        text: translationsManager.translationTrigger + qsTr("Device List")
                        checked: true

                        onCheckedChanged:
                        {
                            if(checked)
                            {
                                actionstButton.checked = false
                                leftDeviceListButton.checked = false
                            }

                            mainScreen.adjustBackgroundImageOnX()
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                spacing: 3

                Component {
                    id: calculatorComponent

                    Rectangle {
                        id: cueContentCalculatorWidget

                        color: "#444444"
                        radius:2

                        MouseArea {
                            anchors.fill: parent

                            propagateComposedEvents: false
                            preventStealing: true

                            onWheel: (wheel) => {
                                         wheel.accepted = true
                                     }
                        }

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
                                    Layout.preferredHeight: 48
                                    Layout.maximumHeight: 48
                                    Layout.minimumHeight: 48

                                    property var operationApplyingText: ""
                                    property var operationApplying
                                    property string value: "0"
                                    property string unitMultiplierType: ""

                                    RowLayout {
                                        anchors.fill: parent

                                        spacing: 4

                                        Item {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true

                                            ColumnLayout {
                                                anchors.fill: parent

                                                spacing: 4

                                                Text {
                                                    Layout.fillWidth: true
                                                    Layout.fillHeight: true

                                                    font.family: MFXUIS.Fonts.robotoRegular.name
                                                    font.pixelSize: 10

                                                    lineHeightMode: Text.FixedHeight
                                                    lineHeight: 14

                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignBottom

                                                    color: "#FFFFFF"

                                                    text: qsTr("min")
                                                }


                                                MFXUICB.TextFieldWithBackground {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 30
                                                    Layout.maximumHeight: 30
                                                    Layout.minimumHeight: 30

                                                    color: "#FFFFFF"
                                                    activeStateOnFocus: true
                                                    backgroundColor: "#222222"
                                                    borderColor: "#222222"
                                                    borderWidth: 2

                                                    text: calculatorTextInputItem.value
                                                    inputMask: "00"
                                                    validator: IntValidator { bottom: 0; top: 60 }

                                                    onActiveStateChanged: {
                                                        if(activeState) {
                                                            calculatorTextInputItem.unitMultiplierType = qsTr("min")
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true

                                            ColumnLayout {
                                                anchors.fill: parent

                                                spacing: 4

                                                Text {
                                                    Layout.fillWidth: true
                                                    Layout.fillHeight: true

                                                    font.family: MFXUIS.Fonts.robotoRegular.name
                                                    font.pixelSize: 10

                                                    lineHeightMode: Text.FixedHeight
                                                    lineHeight: 14

                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignBottom

                                                    color: "#FFFFFF"

                                                    text: qsTr("sec")
                                                }

                                                MFXUICB.TextFieldWithBackground {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 30
                                                    Layout.maximumHeight: 30
                                                    Layout.minimumHeight: 30

                                                    color: "#FFFFFF"
                                                    activeStateOnFocus: true
                                                    backgroundColor: "#222222"
                                                    borderColor: "#222222"
                                                    borderWidth: 2

                                                    text: calculatorTextInputItem.value
                                                    inputMask: "00"
                                                    validator: IntValidator { bottom: 0; top: 60 }

                                                    onActiveStateChanged: {
                                                        if(activeState) {
                                                            calculatorTextInputItem.unitMultiplierType = qsTr("sec")
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true

                                            ColumnLayout {
                                                anchors.fill: parent

                                                spacing: 4

                                                Text {
                                                    Layout.fillWidth: true
                                                    Layout.fillHeight: true

                                                    font.family: MFXUIS.Fonts.robotoRegular.name
                                                    font.pixelSize: 10

                                                    lineHeightMode: Text.FixedHeight
                                                    lineHeight: 14

                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignBottom

                                                    color: "#FFFFFF"

                                                    text: qsTr("x10ms")
                                                }

                                                MFXUICB.TextFieldWithBackground {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 30
                                                    Layout.maximumHeight: 30
                                                    Layout.minimumHeight: 30

                                                    color: "#FFFFFF"
                                                    activeStateOnFocus: true
                                                    backgroundColor: "#222222"
                                                    borderColor: "#222222"
                                                    borderWidth: 2

                                                    text: calculatorTextInputItem.value
                                                    inputMask: "00"
                                                    validator: IntValidator { bottom: 0; top: 60 }

                                                    onActiveStateChanged: {
                                                        if(activeState) {
                                                            calculatorTextInputItem.unitMultiplierType = qsTr("ms")
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            ColumnLayout {
                                                anchors.fill: parent
                                                Item {
                                                    Layout.fillWidth: true
                                                    Layout.fillHeight: true
                                                }

                                                Item {
                                                    Layout.preferredHeight: 30
                                                    Layout.maximumHeight: 30
                                                    Layout.minimumHeight: 30
                                                    Layout.fillWidth: true

                                                    Button {
                                                        id: cleanButton

                                                        anchors.fill: parent

                                                        highlighted: false

                                                        background: Rectangle {
                                                            color: cleanButton.highlighted ? cleanButton.enabled ? "#888888" : "#80888888" : cleanButton.enabled ? "#666666" : "#80666666"

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

                                                                visible: cleanButton.pressed
                                                            }
                                                        }

                                                        contentItem: Item {}

                                                        onClicked: {
                                                            //TODO
                                                        }
                                                    }

                                                    Image {
                                                        anchors.centerIn: parent

                                                        width: 18
                                                        height: 18

                                                        sourceSize: Qt.size(18,18)

                                                        source: "qrc:/icons/main_screen/main_screen_calculator_clear_icon.svg"

                                                        layer.enabled: true
                                                        layer.effect: ColorOverlay {
                                                            color: "#ffffff"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                MFXUICT.LayoutSpacer {
                                    fixedHeight: 6
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
                                                operation: function(){
                                                    if((calculatorTextInputItem.value.length === 1) && (calculatorTextInputItem.value[0] === "0")) {
                                                        calculatorTextInputItem.value = "1"
                                                    } else {
                                                        calculatorTextInputItem.value += "1"
                                                    }
                                                }
                                                highlighted: true
                                            }
                                            ListElement {
                                                text: "2"
                                                operation: function(){
                                                    if((calculatorTextInputItem.value.length === 1) && (calculatorTextInputItem.value[0] === "0")) {
                                                        calculatorTextInputItem.value = "2"
                                                    } else {
                                                        calculatorTextInputItem.value += "2"
                                                    }
                                                }
                                                highlighted: true
                                            }
                                            ListElement {
                                                text: "3"
                                                operation: function(){
                                                    if((calculatorTextInputItem.value.length === 1) && (calculatorTextInputItem.value[0] === "0")) {
                                                        calculatorTextInputItem.value = "3"
                                                    } else {
                                                        calculatorTextInputItem.value += "3"
                                                    }
                                                }
                                                highlighted: true
                                            }
                                            ListElement {
                                                text: "*"
                                                operation: function(){
                                                    calculatorTextInputItem.operationApplyingText = "*"
                                                    calculatorTextInputItem.operationApplying = MFXE.CalculatorOperator.Multiply
                                                }
                                                highlighted: false
                                            }
                                            ListElement {
                                                text: "4"
                                                operation: function(){
                                                    if((calculatorTextInputItem.value.length === 1) && (calculatorTextInputItem.value[0] === "0")) {
                                                        calculatorTextInputItem.value = "4"
                                                    } else {
                                                        calculatorTextInputItem.value += "4"
                                                    }
                                                }
                                                highlighted: true
                                            }
                                            ListElement {
                                                text: "5"
                                                operation: function(){
                                                    if((calculatorTextInputItem.value.length === 1) && (calculatorTextInputItem.value[0] === "0")) {
                                                        calculatorTextInputItem.value = "5"
                                                    } else {
                                                        calculatorTextInputItem.value += "5"
                                                    }
                                                }
                                                highlighted: true
                                            }
                                            ListElement {
                                                text: "6"
                                                operation: function(){
                                                    if((calculatorTextInputItem.value.length === 1) && (calculatorTextInputItem.value[0] === "0")) {
                                                        calculatorTextInputItem.value = "6"
                                                    } else {
                                                        calculatorTextInputItem.value += "6"
                                                    }
                                                }
                                                highlighted: true
                                            }
                                            ListElement {
                                                text: "/"
                                                operation: function(){
                                                    calculatorTextInputItem.operationApplyingText = "/"
                                                    calculatorTextInputItem.operationApplying = MFXE.CalculatorOperator.Divide
                                                }
                                                highlighted: false
                                            }
                                            ListElement {
                                                text: "7"
                                                operation: function(){
                                                    if((calculatorTextInputItem.value.length === 1) && (calculatorTextInputItem.value[0] === "0")) {
                                                        calculatorTextInputItem.value = "7"
                                                    } else {
                                                        calculatorTextInputItem.value += "7"
                                                    }
                                                }
                                                highlighted: true
                                            }
                                            ListElement {
                                                text: "8"
                                                operation: function(){
                                                    if((calculatorTextInputItem.value.length === 1) && (calculatorTextInputItem.value[0] === "0")) {
                                                        calculatorTextInputItem.value = "8"
                                                    } else {
                                                        calculatorTextInputItem.value += "8"
                                                    }
                                                }
                                                highlighted: true
                                            }
                                            ListElement {
                                                text: "9"
                                                operation: function(){
                                                    if((calculatorTextInputItem.value.length === 1) && (calculatorTextInputItem.value[0] === "0")) {
                                                        calculatorTextInputItem.value = "9"
                                                    } else {
                                                        calculatorTextInputItem.value += "9"
                                                    }
                                                }
                                                highlighted: true
                                            }
                                            ListElement {
                                                text: "%"
                                                operation: function(){
                                                    calculatorTextInputItem.operationApplyingText = "%"
                                                    calculatorTextInputItem.operationApplying = MFXE.CalculatorOperator.Percent
                                                    calculatorTextInputItem.unitMultiplierType = ""
                                                }
                                                highlighted: false
                                            }
                                            ListElement {
                                                text: "-"
                                                operation: function(){
                                                    calculatorTextInputItem.operationApplyingText = "-"
                                                    calculatorTextInputItem.operationApplying = MFXE.CalculatorOperator.Substract
                                                }
                                                highlighted: false
                                            }
                                            ListElement {
                                                text: "0"
                                                operation: function(){
                                                    if((calculatorTextInputItem.value.length > 0) && (calculatorTextInputItem.value[0] !== "0")) {
                                                        calculatorTextInputItem.value += "0"
                                                    }
                                                }
                                                highlighted: true
                                            }
                                            ListElement {
                                                text: "+"
                                                operation: function(){
                                                    calculatorTextInputItem.operationApplyingText = "+"
                                                    calculatorTextInputItem.operationApplying = MFXE.CalculatorOperator.Add
                                                }
                                                highlighted: false
                                            }
                                            ListElement {
                                                text: "C"
                                                operation: function(){
                                                    calculatorTextInputItem.value = 0
                                                    calculatorTextInputItem.operationApplying = undefined
                                                    calculatorTextInputItem.operationApplyingText = ""
                                                    calculatorTextInputItem.unitMultiplierType = ""
                                                }
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
                                            enableShadow: true

                                            enabled: model.enabled

                                            text: translationsManager.translationTrigger + model.text

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

                                            text: translationsManager.translationTrigger + model.text

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
                }

                Component {
                    id: actionsComponent

                    Rectangle {
                        id: mainScreenCueContentWidget

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

                                        onClicked: {
                                            cueContentManager.onSelectRightItemsRequest();
                                        }
                                    }
                                }
                            }
                        }

                        Keys.onEscapePressed: {
                            cueContentManager.cleanSelectionRequest()
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

                                RowLayout {
                                    anchors.fill: parent

                                    spacing: 0

                                    MFXUICB.SelectableTableHeaderItem {
                                        id: cueContentNumber

                                        Layout.fillHeight: true
                                        Layout.preferredWidth: cueContentTableListView.columnWidths[0]
                                        Layout.maximumWidth: cueContentTableListView.columnWidths[0]
                                        Layout.minimumWidth: cueContentTableListView.columnWidths[0]

                                        currentIndex: 0

                                        model: ListModel {
                                            ListElement { value: 0; text: qsTr("№") }
                                        }

                                        switchable: false

                                        MouseArea {
                                            anchors.fill: parent
                                            onDoubleClicked: {
                                                cueContentManager.cleanSelectionRequest()
                                            }
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

                                    MFXUICB.SelectableTableHeaderItem {
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
                                            cueContentManager.onSortFromHeaderRequest(timingTypeHeaderItem.value)
                                        }

                                        Component.onCompleted: {
                                            timingTypeHeaderModel.append({ "value": MFXE.CueContentSelectedTableRole.Delay, "text": qsTr("Delay") })
                                            timingTypeHeaderModel.append({ "value": MFXE.CueContentSelectedTableRole.Between, "text": qsTr("Between") })
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

                                    MFXUICB.SelectableTableHeaderItem {
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
                                            cueContentManager.onSortFromHeaderRequest(deviceTypeHeaderItem.value)
                                        }

                                        Component.onCompleted: {
                                            deviceTypeHeaderModel.append({ "value": MFXE.CueContentSelectedTableRole.RfChannel, "text": qsTr("RF ch") })
                                            deviceTypeHeaderModel.append({ "value": MFXE.CueContentSelectedTableRole.Device, "text": qsTr("Device") })
                                            deviceTypeHeaderModel.append({ "value": MFXE.CueContentSelectedTableRole.DmxChannel, "text": qsTr("DMX ch") })
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

                                    MFXUICB.SelectableTableHeaderItem {
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
                                            cueContentManager.onSortFromHeaderRequest(actionTypeHeaderItem.value)
                                        }

                                        Component.onCompleted: {
                                            actionTypeHeaderModel.append({ "value": MFXE.CueContentSelectedTableRole.Effect, "text": qsTr("Effect") })
                                            actionTypeHeaderModel.append({ "value": MFXE.CueContentSelectedTableRole.Action, "text": qsTr("Action") })
                                            actionTypeHeaderModel.append({ "value": MFXE.CueContentSelectedTableRole.Angle, "text": qsTr("Angle") })
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

                                    MFXUICB.SelectableTableHeaderItem {
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
                                            cueContentManager.onSortFromHeaderRequest(durationTypeHeaderItem.value)
                                        }

                                        Component.onCompleted: {
                                            durationTypeHeaderModel.append({ "value": MFXE.CueContentSelectedTableRole.Time, "text": qsTr("Time") })
                                            durationTypeHeaderModel.append({ "value": MFXE.CueContentSelectedTableRole.Prefire, "text": qsTr("Prefire") })
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

                            model: cueContentManager.cueContentSorted

                            delegate: FocusScope {
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

                                property color selectedTextColor: "#27AE60"
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

                                    Behavior on color { ColorAnimation { duration: 250 } }
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

                                        color: cueContentListViewDelegatePrivateProperties.calculatedTextColor

                                        text: {
                                            switch(cueContentManager.timingTypeSelectedTableRole) {
                                            case MFXE.CueContentSelectedTableRole.Delay:
                                                return cueContentListViewDelegate.delay
                                            case MFXE.CueContentSelectedTableRole.Between:
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

                                        color: cueContentListViewDelegatePrivateProperties.calculatedTextColor

                                        text: {
                                            switch(cueContentManager.deviceTypeSelectedTableRole) {
                                            case MFXE.CueContentSelectedTableRole.RfChannel:
                                                return cueContentListViewDelegate.rfChannel
                                            case MFXE.CueContentSelectedTableRole.Device:
                                                return cueContentListViewDelegate.device
                                            case MFXE.CueContentSelectedTableRole.DmxChannel:
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

                                        color: cueContentListViewDelegatePrivateProperties.calculatedTextColor

                                        text: {
                                            switch(cueContentManager.actionTypeSelectedTableRole) {
                                            case MFXE.CueContentSelectedTableRole.Action:
                                                return cueContentListViewDelegate.action
                                            case MFXE.CueContentSelectedTableRole.Angle:
                                                return cueContentListViewDelegate.angle
                                            case MFXE.CueContentSelectedTableRole.Effect:
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

                                        color: cueContentListViewDelegatePrivateProperties.calculatedTextColor

                                        text: {
                                            switch(cueContentManager.durationTypeSelectedTableRole) {
                                            case MFXE.CueContentSelectedTableRole.Time:
                                                return cueContentListViewDelegate.time
                                            case MFXE.CueContentSelectedTableRole.Prefire:
                                                return cueContentListViewDelegate.prefire
                                            }
                                            return qsTr("---")
                                        }

                                        Behavior on color { ColorAnimation { duration: 250 } }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent

                                    propagateComposedEvents: true
                                    preventStealing: false

                                    onClicked: {
                                        cueContentListViewDelegate.forceActiveFocus()
                                    }
                                }
                            }
                        }
                    }
                }

                Component {
                    id: devicesListComponent

                    Rectangle
                    {
                        id: mainScreenDeviceListWidget

                        color: "black"
                        radius: 2
                        clip: true

                        border.width: 2
                        border.color: "#444444"

                        MouseArea {
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
                                    //                   Когда понадобится восстановить, делаем поиск по TODO-DEVICES-TYPES
        //                            groupListModel.append({groupName: "Dimmer"})
        //                            groupListModel.append({groupName: "Shot"})
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
                                                    anchors.left: deviceListView.contentItem.left
                                                    anchors.right: deviceListView.contentItem.right
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

                Component {
                    id: cueListComponent

                    Rectangle {
                        id: cueListWidget

                        color: "#444444"
                        radius: 2

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
                        }

                        //TODO должно поставляться из логики бекенда - перенести в c++ часть
                        enum CueListViewItemTypes {
                            GlobalOffset, //Эта роль подразумевает элемент GlobalOffset - он не редактируется
                            Normal // Обычный элемент CUE
                        }

                        ListView {
                            id: cueListView

                            anchors.fill: parent

                            anchors.leftMargin: 2
                            anchors.rightMargin: 2
                            anchors.bottomMargin: 2

                            property int columnsCount: 4
                            property var columnProportions: [1, 3, 2, 2]
                            property var columnWidths: [0, 0, 0, 0]

                            function calculateColumnWidths(width) {
                                return columnProportions.map(function(columnProportion) {
                                    return (width - (columnsCount - 1)) * (columnProportion / cueListView.columnProportions.reduce((a, b) => a + b, 0))
                                });
                            }

                            Component.onCompleted: {
                                cueListView.columnWidths = cueListView.calculateColumnWidths(cueListView.width)
                            }

                            onWidthChanged: {
                                cueListView.columnWidths = cueListView.calculateColumnWidths(cueListView.width)
                            }

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


                                RowLayout {
                                    anchors.fill: parent

                                    spacing: 0

                                    Text {

                                        Layout.fillHeight: true
                                        Layout.preferredWidth: cueListView.columnWidths[0]
                                        Layout.maximumWidth: cueListView.columnWidths[0]
                                        Layout.minimumWidth: cueListView.columnWidths[0]

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 10

                                        color: "#FFFFFF"

                                        text: translationsManager.translationTrigger + qsTr("№")
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

                                    Text {

                                        Layout.fillHeight: true
                                        Layout.preferredWidth: cueListView.columnWidths[1]
                                        Layout.maximumWidth: cueListView.columnWidths[1]
                                        Layout.minimumWidth: cueListView.columnWidths[1]

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 10

                                        color: "#FFFFFF"

                                        text: translationsManager.translationTrigger + qsTr("Cue")
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

                                    Text {

                                        Layout.fillHeight: true
                                        Layout.preferredWidth: cueListView.columnWidths[2]
                                        Layout.maximumWidth: cueListView.columnWidths[2]
                                        Layout.minimumWidth: cueListView.columnWidths[2]

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 10

                                        color: "#FFFFFF"

                                        text: translationsManager.translationTrigger + qsTr("Start time")
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

                                    Text {

                                        Layout.fillHeight: true
                                        Layout.preferredWidth: cueListView.columnWidths[3]
                                        Layout.maximumWidth: cueListView.columnWidths[3]
                                        Layout.minimumWidth: cueListView.columnWidths[3]

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 10

                                        color: "#FFFFFF"

                                        text: translationsManager.translationTrigger + qsTr("Total time")
                                    }
                                }

                            }

                            model: cueManager.cuesSorted

                            delegate: FocusScope {
                                id: cueListViewDelegate

                                property bool active: model.active
                                property bool selected: model.selected
                                property var id: model.uuid
                                property int rowIndex: model.index
                                property string name: model.name
                                property string startTime: model.startTimeDecorator
                                property string totalTime: model.durationTimeDecorator

                                property color activeTextColor: "#F2C94C"
                                property color activeBackgroundColor: "#1AFFFAFA"

                                property color selectedTextColor: "#80FFFFFF"
                                property color selectedBackgroundColor: "#80000000"

                                property color textColor: "#FFFFFF"
                                property color backgroundColor: "transparent"

                                QtObject {
                                    id: cueListViewDelegatePrivateProperties

                                    property color calculatedBackgroundColor: cueListViewDelegate.active ? cueListViewDelegate.activeBackgroundColor
                                                                                                         : cueListViewDelegate.selected ? cueListViewDelegate.selectedBackgroundColor
                                                                                                                                        : cueListViewDelegate.backgroundColor

                                    property color calculatedTextColor: cueListViewDelegate.active ? cueListViewDelegate.activeTextColor
                                                                                                   : cueListViewDelegate.selected ? cueListViewDelegate.selectedTextColor
                                                                                                                                  : cueListViewDelegate.textColor
                                }

                                anchors.left: cueListView.contentItem.left
                                anchors.right: cueListView.contentItem.right

                                height: 30

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.leftMargin: 6
                                    anchors.rightMargin: 6

                                    color: cueListViewDelegatePrivateProperties.calculatedBackgroundColor

                                    Behavior on color { ColorAnimation { duration: 150 } }

                                    MouseArea {
                                        id: cueListViewDelegateSelectionMouseArea

                                        anchors.fill: parent

                                        onClicked: {
                                            if(cueListViewDelegate.selected) {
                                                cueManager.cueDeselectedOnCueListRequest(cueListViewDelegate.name)
                                            } else {
                                                cueManager.cueSelectedOnCueListRequest(cueListViewDelegate.name)
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.leftMargin: 6
                                    anchors.rightMargin: 6

                                    height: 1

                                    color: "#80000000"
                                }

                                RowLayout {
                                    anchors.fill: parent

                                    spacing: 0

                                    Text {

                                        Layout.fillHeight: true
                                        Layout.preferredWidth: cueListView.columnWidths[0]
                                        Layout.maximumWidth: cueListView.columnWidths[0]
                                        Layout.minimumWidth: cueListView.columnWidths[0]

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 10

                                        color: cueListViewDelegatePrivateProperties.calculatedTextColor

                                        text: cueListViewDelegate.rowIndex
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

                                    MFXUICB.TransparentTextField {
                                        id: cueListViewDelegateNameTextField

                                        Layout.fillHeight: true
                                        Layout.preferredWidth: cueListView.columnWidths[1]
                                        Layout.maximumWidth: cueListView.columnWidths[1]
                                        Layout.minimumWidth: cueListView.columnWidths[1]

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        textSize: 10

                                        textColor: cueListViewDelegatePrivateProperties.calculatedTextColor

                                        text: cueListViewDelegate.name

                                        onTextEdited: {
                                            if(text.length > 0) {
                                                cueManager.cueNameChangeRequest(cueListViewDelegate.id, text)
                                            }
                                        }

                                        Keys.priority: Keys.BeforeItem
                                        Keys.onPressed: (keyEvent) => {
                                                            if((keyEvent === Qt.Key_Escape) || (keyEvent === Qt.Key_Enter)) {
                                                                cueListViewDelegateNameTextField.focus = false;
                                                                cueListViewDelegateNameTextField._textItem.focus = false;
                                                                keyEvent.accepted = true;
                                                                return;
                                                            }
                                                            keyEvent.accepted = false;
                                                        }

                                        MouseArea {
                                            id: cueListViewDelegateNameTextFieldMouseArea

                                            anchors.fill: parent

                                            property bool waitingForASecondClick: false
                                            property int doubleClickDuration: 300

                                            Timer {
                                                id: doubleClickTimer

                                                interval: cueListViewDelegateNameTextFieldMouseArea.doubleClickDuration
                                                running: false
                                                repeat: false

                                                onTriggered: {
                                                    if(cueListViewDelegateNameTextFieldMouseArea.waitingForASecondClick) {
                                                        cueListViewDelegateNameTextFieldMouseArea.waitingForASecondClick = false;
                                                        cueListViewDelegateSelectionMouseArea.clicked(null)
                                                    }
                                                }
                                            }

                                            propagateComposedEvents: false
                                            preventStealing: true

                                            onClicked: {
                                                if(waitingForASecondClick) {
                                                    if(doubleClickTimer.running) {
                                                        doubleClickTimer.stop()
                                                        cueListViewDelegateNameTextField.forceFocus()
                                                    }
                                                    waitingForASecondClick = false
                                                } else {
                                                    doubleClickTimer.start()
                                                    waitingForASecondClick = true;
                                                }
                                                mouse.accepted = true
                                            }
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

                                    Text {

                                        Layout.fillHeight: true
                                        Layout.preferredWidth: cueListView.columnWidths[2]
                                        Layout.maximumWidth: cueListView.columnWidths[2]
                                        Layout.minimumWidth: cueListView.columnWidths[2]

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 10

                                        color: cueListViewDelegatePrivateProperties.calculatedTextColor

                                        text: cueListViewDelegate.startTime
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

                                    Text {

                                        Layout.fillHeight: true
                                        Layout.preferredWidth: cueListView.columnWidths[3]
                                        Layout.maximumWidth: cueListView.columnWidths[3]
                                        Layout.minimumWidth: cueListView.columnWidths[3]

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 10

                                        color: cueListViewDelegatePrivateProperties.calculatedTextColor

                                        text: cueListViewDelegate.totalTime
                                    }
                                }
                            }
                        }
                    }
                }

                Loader {
                    id: leftPanelLoader

                    Layout.fillHeight: true

                    states: [
                        State {
                            name: "hidden"
                            when: !leftDeviceListButton.checked && !cueListButton.checked
                            PropertyChanges {
                                target: leftPanelLoader
                                Layout.preferredWidth: 0
                                Layout.maximumWidth: 0
                                Layout.minimumWidth: 0
                                sourceComponent: undefined
                            }
                        },
                        State {
                            name: "cue"
                            when: cueListButton.checked
                            PropertyChanges {
                                target: leftPanelLoader
                                Layout.fillWidth: true
                                sourceComponent: cueListComponent
                            }
                        },
                        State {
                            name: "devices"
                            when: leftDeviceListButton.checked
                            PropertyChanges {
                                target: leftPanelLoader
                                Layout.fillWidth: true
                                sourceComponent: devicesListComponent
                            }
                        }
                    ]
                }

                MFXUICT.LayoutSpacer {
                    id: contentSpacer
                    states: [
                        State {
                            name: "collapsed"
                            when: (leftPanelLoader.state !== "hidden") && (rightPanelLoader.state !== "hidden")
                            PropertyChanges {
                                target: contentSpacer
                                Layout.preferredWidth: 0
                                Layout.maximumWidth: 0
                                Layout.minimumWidth: 0
                                visible: false
                            }
                        },
                        State {
                            name: "expanded"
                            when: (leftPanelLoader.state === "hidden") || (rightPanelLoader.state === "hidden")
                            PropertyChanges {
                                target: contentSpacer
                                Layout.fillWidth: true
                                visible: true
                            }
                        }
                    ]
                }

                Loader {
                    id: calculatorLoader

                    Layout.fillHeight: true

                    states: [
                        State {
                            name: "visible"
                            when: actionstButton.checked
                            PropertyChanges {
                                target: calculatorLoader
                                Layout.preferredWidth: 176
                                Layout.maximumWidth: 176
                                Layout.minimumWidth: 176
                                sourceComponent: calculatorComponent
                            }
                        },
                        State {
                            name: "hidden"
                            when: !actionstButton.checked
                            PropertyChanges {
                                target: calculatorLoader
                                Layout.preferredWidth: 0
                                Layout.maximumWidth: 0
                                Layout.minimumWidth: 0
                                sourceComponent: undefined
                            }
                        }

                    ]
                }

                Loader {
                    id: rightPanelLoader

                    Layout.fillHeight: true

                    states: [
                        State {
                            name: "hidden"
                            when: !rightDeviceListButton.checked && !actionstButton.checked
                            PropertyChanges {
                                target: rightPanelLoader
                                Layout.preferredWidth: 0
                                Layout.maximumWidth: 0
                                Layout.minimumWidth: 0
                                sourceComponent: undefined
                            }
                        },
                        State {
                            name: "actions"
                            when: actionstButton.checked
                            PropertyChanges {
                                target: rightPanelLoader
                                Layout.fillWidth: true
                                sourceComponent: actionsComponent
                            }
                        },
                        State {
                            name: "devices"
                            when: rightDeviceListButton.checked
                            PropertyChanges {
                                target: rightPanelLoader
                                Layout.fillWidth: true
                                sourceComponent: devicesListComponent
                            }
                        }
                    ]
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
            text: translationsManager.translationTrigger + qsTr("Sequences")
            textSize: 10
            color: "#2F80ED"

            anchors.top: parent.top
            anchors.left: parent.left

            ButtonGroup.group: rightButtonsGroup

            //TODO-DEVICES-TYPES пока не используем другие типы устройств - только Sequences, поэтому комментируем
            //                   Когда понадобится восстановить, делаем поиск по TODO-DEVICES-TYPES
            visible: true
        }

        MfxButton
        {
            id: dimmerButton
            checkable: true
            width: 68
            text: translationsManager.translationTrigger + qsTr("Dimmer")
            textSize: 10
            color: "#2F80ED"

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: sequencesButton.right

            ButtonGroup.group: rightButtonsGroup

            //TODO-DEVICES-TYPES пока не используем другие типы устройств - только Sequences, поэтому комментируем
            //                   Когда понадобится восстановить, делаем поиск по TODO-DEVICES-TYPES
            visible: false
        }

        MfxButton
        {
            id: shotButton
            checkable: true
            width: 68
            text: translationsManager.translationTrigger + qsTr("Shot")
            textSize: 10
            color: "#2F80ED"

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: dimmerButton.right

            ButtonGroup.group: rightButtonsGroup

            //TODO-DEVICES-TYPES пока не используем другие типы устройств - только Sequences, поэтому комментируем
            //                   Когда понадобится восстановить, делаем поиск по TODO-DEVICES-TYPES
            visible: false
        }

        MfxButton
        {
            id: pyroButton
            checkable: true
            width: 68
            text: translationsManager.translationTrigger + qsTr("Pyro")
            textSize: 10
            color: "#2F80ED"

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: shotButton.right

            ButtonGroup.group: rightButtonsGroup

            //TODO-DEVICES-TYPES пока не используем другие типы устройств - только Sequences, поэтому комментируем
            //                   Когда понадобится восстановить, делаем поиск по TODO-DEVICES-TYPES
            visible: false
        }

        MfxButton
        {
            id: cueButton
            checkable: true
            width: 60
            text: translationsManager.translationTrigger + qsTr("Cue")
            textSize: 10

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: pyroButton.right

            ButtonGroup.group: rightButtonsGroup

            //TODO-DEVICES-TYPES пока не используем другие типы устройств - только Sequences, поэтому комментируем
            //                   Когда понадобится восстановить, делаем поиск по TODO-DEVICES-TYPES
            visible: false
        }

        ButtonGroup
        {
            id: rightButtonsGroup
            checkedButton: sequencesButton

        }

        MfxButton
        {
            id: addButton
            text: translationsManager.translationTrigger + qsTr("+")

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: cueButton.right
            anchors.right: parent.right

            //TODO-DEVICES-TYPES пока не используем другие типы устройств - только Sequences, поэтому комментируем
            //                   Когда понадобится восстановить, делаем поиск по TODO-DEVICES-TYPES
            visible: false
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

            //TODO пока что тип данных для паттерны скрыт, а соответственно, скрыты кнопки фильтрации по типу паттерна
            //     а также убран отступ для панели с паттернами. После того, как фича будет реализована - достаточно убрать
            //     эту переменную в местах, где она используется, вернув правильные значения
            property bool patternTypesFeatureHidden: true

            MfxButton
            {
                id: lingericButton
                checkable: true
                width: 72
                height: 26
                text: translationsManager.translationTrigger + qsTr("Lingeric")
                textSize: 10

                anchors.top: parent.top
                anchors.left: parent.left

                ButtonGroup.group: actionTypesGroup

                visible: !actionViewWidget.patternTypesFeatureHidden

                onClicked: {
                    patternManager.patternsFiltered.patternFilteringTypeChangeRequest(MDFM.PatternType.Sequential)
                }
            }

            MfxButton
            {
                id: dynamicButton
                checkable: true
                width: 72
                height: 26
                text: translationsManager.translationTrigger + qsTr("Dynamic")
                textSize: 10

                anchors.top: parent.top
                anchors.left: lingericButton.right

                ButtonGroup.group: actionTypesGroup

                visible: !actionViewWidget.patternTypesFeatureHidden

                onClicked: {
                    patternManager.patternsFiltered.patternFilteringTypeChangeRequest(MDFM.PatternType.Dynamic)
                }
            }

            MfxButton
            {
                id: staticButton
                checkable: true
                width: 72
                height: 26
                text: translationsManager.translationTrigger + qsTr("Static")
                textSize: 10

                anchors.top: parent.top
                anchors.left: dynamicButton.right

                ButtonGroup.group: actionTypesGroup

                visible: !actionViewWidget.patternTypesFeatureHidden

                onClicked: {
                    patternManager.patternsFiltered.patternFilteringTypeChangeRequest(MDFM.PatternType.Static)
                }
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

                anchors.topMargin: !actionViewWidget.patternTypesFeatureHidden ? 24 : 0
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

                    ScrollBar.vertical: ScrollBar {policy: ScrollBar.AlwaysOn}

                    model: patternManager.patternsFiltered

                    delegate: Item {
                        id: actionPlate

                        property string name: model.name
                        property bool checked: model.uuid === patternManager.selectedPatternUuid

                        width: actionView.cellWidth
                        height: actionView.cellHeight

                        Item
                        {

                            anchors.fill: parent

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

                                visible: actionPlate.checked
                            }
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked:  {
                                if(actionPlate.checked) {
                                    patternManager.cleanPatternSelectionRequest()
                                } else {
                                    patternManager.currentPatternChangeRequest(model.uuid)

                                    let checkedPatches = project.checkedPatchesList()

                                    checkedPatches.forEach(function(patchId)
                                    {
                                       project.setPatchProperty(patchId, "act", actionPlate.name);
                                    })
                                }
                            }
                        }
                    }



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

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import MFX.UI.Components.Basic 1.0
import MFX.UI.Components.Templates 1.0
import MFX.UI.Styles 1.0

Component
{
    Rectangle
    {
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

        Flickable
        {
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 8

            contentHeight: calculatorContentLayout.height

            clip: true

            ColumnLayout
            {
                id: calculatorContentLayout

                anchors.left: parent.left
                anchors.right: parent.right

                height: childrenRect.height

                spacing: 0

                Item 
                {
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

                                    font.family: Fonts.robotoRegular.name
                                    font.pixelSize: 10

                                    lineHeightMode: Text.FixedHeight
                                    lineHeight: 14

                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignBottom

                                    color: "#FFFFFF"

                                    text: qsTr("min")
                                }

                                TextFieldWithBackground
                                {
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

                                    onActiveStateChanged:
                                    {
                                        if(activeState)
                                        {
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

                                    font.family: Fonts.robotoRegular.name
                                    font.pixelSize: 10

                                    lineHeightMode: Text.FixedHeight
                                    lineHeight: 14

                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignBottom

                                    color: "#FFFFFF"

                                    text: qsTr("sec")
                                }

                                TextFieldWithBackground
                                {
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

                                    onActiveStateChanged:
                                    {
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

                                    font.family: Fonts.robotoRegular.name
                                    font.pixelSize: 10

                                    lineHeightMode: Text.FixedHeight
                                    lineHeight: 14

                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignBottom

                                    color: "#FFFFFF"

                                    text: qsTr("x10ms")
                                }

                                TextFieldWithBackground
                                {
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

                                    onActiveStateChanged:
                                    {
                                        if(activeState)
                                        {
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
                                            layer.effect: DropShadow
                                            {
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

                LayoutSpacer
                {
                    fixedHeight: 6
                }

                Grid 
                {
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
                                font.family: Fonts.robotoMedium.name
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

                LayoutSpacer
                {
                    fixedHeight: 20
                }

                Grid 
                {
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

                            fontFamilyName: Fonts.robotoMedium.name
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

                LayoutSpacer
                {
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
                            ListElement { text: qsTr("Inside"); callback: function() {
                                let selectedCue = cueContentManager.onGetSelectedDeviseList();
                                project.onInsideOutside(cueName, selectedCue,true);
                            };  }
                            ListElement { text: qsTr("Outside"); callback: function() {
                                let selectedCue = cueContentManager.onGetSelectedDeviseList();
                                project.onInsideOutside(cueName, selectedCue, false);

                            };  }
                            ListElement { text: qsTr("Mirror"); callback: function() {
                                let selectedCue = cueContentManager.onGetSelectedDeviseList();
                                project.onMirror(cueName, selectedCue);
                            };  }
                            ListElement { text: qsTr("Random"); callback: function() {
                                let selectedCue = cueContentManager.onGetSelectedDeviseList();
                                project.onRandom(cueName, selectedCue);
                            };  }
                        }

                        delegate: MfxButton {
                            width: 76
                            height: 24

                            checkable: false

                            fontFamilyName: Fonts.robotoMedium.name
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

                LayoutSpacer {}
            }
        }
    }
}
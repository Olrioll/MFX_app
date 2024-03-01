import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: addPyroWidget
    width: 148
    height: 338

    property bool isEditMode: false
    property var changedIdList: []
    property string groupName: ""
    property var currentInput: quantityField

    function markAllInputsInactive()
    {
        quantityField.isActiveInput = false
        rfPosField.isActiveInput = false
        rfChField.isActiveInput = false
        channelField.isActiveInput = false
    }

    function add()
    {
        //--- Определяем инкремент RF pos

        let isNegative = false
        let operatorIndex = rfPosField.text.indexOf('+')

        if(operatorIndex === -1)
        {
            operatorIndex = rfPosField.text.indexOf('-')
            if(operatorIndex !== -1)
                isNegative = true
        }



        let currentRfPosValue = (operatorIndex === -1) ? Number(rfPosField.text) : Number(rfPosField.text.slice(0, operatorIndex))

        let rfPosIncrement = 0
        if(operatorIndex !== -1)
        {
            rfPosIncrement = Number(rfPosField.text.slice(operatorIndex + 1))
            if(isNegative)
                rfPosIncrement = -rfPosIncrement
        }

        //--- Определяем инкремент RF ch

        isNegative = false
        operatorIndex = rfChField.text.indexOf('+')

        if(operatorIndex === -1)
        {
            operatorIndex = rfChField.text.indexOf('-')
            if(operatorIndex !== -1)
                isNegative = true
        }



        let currentRfChValue = (operatorIndex === -1) ? Number(rfChField.text) : Number(rfChField.text.slice(0, operatorIndex))

        let rfChIncrement = 0
        if(operatorIndex !== -1)
        {
            rfChIncrement = Number(rfChField.text.slice(operatorIndex + 1))
            if(isNegative)
                rfChIncrement = -rfChIncrement
        }

        let currentId = project.lastPatchId() + 1;

        for(let i = 0; i < Number(quantityField.text); i++)
        {
            project.addPatch( "Pyro",
                             [
                              {propName: "ID", propValue: currentId},
                              {propName: "DMX", propValue: 0},
                              {propName: "RF pos", propValue: currentRfPosValue},
                              {propName: "RF ch", propValue: currentRfChValue},
                              {propName: "channel", propValue: Number(channelField.text)}
                             ])


            if(groupName)
            {
                project.addPatchToGroup(groupName, currentId)
            }

            currentRfPosValue += rfPosIncrement
            currentRfChValue += rfChIncrement
            currentId++
        }
    }

    function edit()
    {
        //--- Определяем инкремент RF pos

        let isNegative = false
        let operatorIndex = rfPosField.text.indexOf('+')

        if(operatorIndex === -1)
        {
            operatorIndex = rfPosField.text.indexOf('-')
            if(operatorIndex !== -1)
                isNegative = true
        }



        let currentRfPosValue = (operatorIndex === -1) ? Number(rfPosField.text) : Number(rfPosField.text.slice(0, operatorIndex))

        let rfPosIncrement = 0
        if(operatorIndex !== -1)
        {
            rfPosIncrement = Number(rfPosField.text.slice(operatorIndex + 1))
            if(isNegative)
                rfPosIncrement = -rfPosIncrement
        }

        //--- Определяем инкремент RF ch

        isNegative = false
        operatorIndex = rfChField.text.indexOf('+')

        if(operatorIndex === -1)
        {
            operatorIndex = rfChField.text.indexOf('-')
            if(operatorIndex !== -1)
                isNegative = true
        }



        let currentRfChValue = (operatorIndex === -1) ? Number(rfChField.text) : Number(rfChField.text.slice(0, operatorIndex))

        let rfChIncrement = 0
        if(operatorIndex !== -1)
        {
            rfChIncrement = Number(rfChField.text.slice(operatorIndex + 1))
            if(isNegative)
                rfChIncrement = -rfChIncrement
        }

        for(let i = 0; i < changedIdList.length; i++)
        {
            project.onEditPatch(
                             [
                              {propName: "ID", propValue: changedIdList[i]},
                              {propName: "RF pos", propValue: currentRfPosValue},
                              {propName: "RF ch", propValue: currentRfChValue},
                              {propName: "channel", propValue: Number(channelField.text)}
                             ])

            currentRfPosValue += rfPosIncrement
            currentRfChValue += rfChIncrement
        }
    }

    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 28
        anchors.leftMargin: 0
        anchors.topMargin: -16
        radius: 2
        color: "#444444"
        clip: true

        MouseArea
        {
            id: mouseArea
            height: 28
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            drag.target: addPyroWidget
            drag.axis: Drag.XandYAxis

            drag.minimumX: applicationWindow.childWidgetsArea().x
            drag.maximumX: applicationWindow.childWidgetsArea().width - addPyroWidget.width
            drag.minimumY: applicationWindow.childWidgetsArea().y
            drag.maximumY: applicationWindow.childWidgetsArea().height - addPyroWidget.height
        }

        Text
        {
            id: windowTitle
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("Add Pyro")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: MFXUIS.Fonts.robotoRegular.name
            font.pixelSize: 12
            topPadding: 9
        }

        Button
        {
            id: closeButton
            width: 25
            height: 25
            anchors.top: parent.top
            anchors.topMargin: 4
            anchors.right: parent.right

            bottomPadding: 0
            topPadding: 0
            rightPadding: 0
            leftPadding: 0

            background: Rectangle {
                color: "#444444"
                opacity: 0
            }

            Image
            {
                source: "qrc:/utilityCloseButton"
            }

            onClicked:
            {
                applicationWindow.isPatchEditorOpened = false
                addPyroWidget.destroy()
            }
        }

        //--- Рабочая область

        Rectangle
        {
            x: 7
            y: 34
            width: 133
            height: 78
            color: "#222222"
            radius: 2
        }

        Text
        {
            id: quantityText
            x: 37
            y: 40
            height: 17
            color: quantityField.isActiveInput ? "#27AE60" : "#ffffff"
            text: translationsManager.translationTrigger + qsTr("Quantity")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideMiddle
            font.family: MFXUIS.Fonts.robotoRegular.name

            visible: !(changedIdList.length > 1)
        }

        TextField
        {
            id: quantityField
            x: 98
            y: 40
            width: 36
            height: 18
            text: "1"
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            padding: 0
            leftPadding: -2
            font.pointSize: 8
            visible: !(changedIdList.length > 1)

            property bool isActiveInput: true
            property string lastSelectedText

            validator: RegExpValidator { regExp: /[0-9]+/ }
            maximumLength: 2

            background: Rectangle
            {
                color: "#000000"
                radius: 2
            }

            onFocusChanged:
            {
                if(focus)
                {
                    markAllInputsInactive();
                    isActiveInput = true;
                    addPyroWidget.currentInput = this;
                    selectAll();
                    lastSelectedText = selectedText
                }
            }
        }

        TextField
        {
            id: rfPosField
            x: 11
            y: 82
            width: 36
            height: 18
            color: "#ffffff"
            text: "1"
            horizontalAlignment: Text.AlignHCenter
            padding: 0
            leftPadding: -2
            font.pointSize: 8

            property bool isActiveInput: false
            property string lastSelectedText

            function checkValue()
            {
                if(text === "")
                    return false

                let operatorIndex = text.indexOf('+')

                if(operatorIndex === -1)
                    operatorIndex = text.indexOf('-')

                let checkedText = (operatorIndex === -1) ? text : text.slice(0, operatorIndex)
                return (Number(checkedText) >= 1 && Number(checkedText) < 1000)
            }

            background: Rectangle
            {
                color: "#000000"
                radius: 2
            }

            onFocusChanged:
            {
                if(focus)
                {
                    markAllInputsInactive();
                    isActiveInput = true
                    addPyroWidget.currentInput = this
                    selectAll();
                    lastSelectedText = selectedText
                }
            }
        }

        TextField
        {
            id: rfChField
            x: 56
            y: 82
            width: 36
            height: 18
            color: "#ffffff"
            text: "1"
            horizontalAlignment: Text.AlignHCenter
            padding: 0
            leftPadding: -2
            font.pointSize: 8

            property bool isActiveInput: false
            property string lastSelectedText

            function checkValue()
            {
                if(text === "")
                    return false

                let operatorIndex = text.indexOf('+')

                if(operatorIndex === -1)
                    operatorIndex = text.indexOf('-')

                let checkedText = (operatorIndex === -1) ? text : text.slice(0, operatorIndex)
                return (Number(checkedText) >= 1 && Number(checkedText) < 10000)
            }

            background: Rectangle
            {
                color: "#000000"
                radius: 2
            }

            onFocusChanged:
            {
                if(focus)
                {
                    markAllInputsInactive();
                    isActiveInput = true
                    addPyroWidget.currentInput = this
                    selectAll();
                    lastSelectedText = selectedText
                }
            }
        }

        TextField
        {
            id: channelField
            x: 101
            y: 82
            width: 36
            height: 18
            color: "#ffffff"
            text: "10"
            horizontalAlignment: Text.AlignHCenter
            padding: 0
            leftPadding: -2
            font.pointSize: 8

            property bool isActiveInput: false
            property string lastSelectedText

            function checkValue()
            {
                if(text === "")
                    return false

                return (Number(text) >= 0 && Number(text) < 200)
            }

            validator: RegExpValidator { regExp: /[0-9]+/ }
            maximumLength: 3

            background: Rectangle
            {
                color: "#000000"
                radius: 2
            }

            onFocusChanged:
            {
                if(focus)
                {
                    markAllInputsInactive();
                    isActiveInput = true
                    addPyroWidget.currentInput = this
                    selectAll();
                    lastSelectedText = selectedText
                }
            }
        }

        Text {
            x: 13
            y: 63
            height: 17
            color: rfPosField.isActiveInput ? "#27AE60" : "#ffffff"
            text: translationsManager.translationTrigger + qsTr("RF pos")
            elide: Text.ElideMiddle
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            x: 58
            y: 63
            height: 17
            color: rfChField.isActiveInput ? "#27AE60" : "#ffffff"
            text: translationsManager.translationTrigger + qsTr("RF ch")
            elide: Text.ElideMiddle
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            x: 93
            y: 63
            width: 44
            height: 17
            color: channelField.isActiveInput ? "#27AE60" : "#ffffff"
            text: translationsManager.translationTrigger + qsTr("channel")
            elide: Text.ElideMiddle
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        CalcWidget
        {
            id: calcWidget
            x: 11
            y: 125

            minusButtonText: channelField.isActiveInput ? "." : "-"
        }

        MfxButton
        {
            id: setButton
            x: 11
            y: 295
            width: 124
            color: "#2F80ED"
            text: translationsManager.translationTrigger + qsTr("Set")
            enabled:
            {
                        rfPosField.checkValue() &&
                        rfChField.checkValue() &&
                        channelField.checkValue()
            }

            onClicked:
            {
                if(addPyroWidget.isEditMode)
                {
                    addPyroWidget.edit()
                }

                else
                {
                    addPyroWidget.add()
                }

                applicationWindow.isPatchEditorOpened = false
                addPyroWidget.destroy();
            }
        }
    }

    states: [
        State
        {
            name: "editMode"
            when: addPyroWidget.isEditMode
            PropertyChanges {target: windowTitle; text: translationsManager.translationTrigger + qsTr("Edit Pyro")}
            PropertyChanges {target: setButton; text: translationsManager.translationTrigger + qsTr("Apply")}
            PropertyChanges {target: quantityText; text: translationsManager.translationTrigger + qsTr("Patch ID")}
            PropertyChanges {target: quantityField; maximumLength: 3}
        }
    ]

    Connections
    {
        target: calcWidget
        function onDigitClicked(digit)
        {
            if(currentInput.lastSelectedText === currentInput.text)
            {
                currentInput.lastSelectedText = ""
                currentInput.text = ""
            }


            currentInput.text = currentInput.text + digit
        }
    }

    Component.onCompleted:
    {
        applicationWindow.isPatchEditorOpened = true

        if(isEditMode && changedIdList.length === 1)
        {
            var propNamesList = project.patchPropertiesNames(project.patchIndexForId(changedIdList[0]))
            var propValuesList = project.patchPropertiesValues(project.patchIndexForId(changedIdList[0]))

            quantityField.text = propValuesList[propNamesList.indexOf("ID")];
            rfPosField.text = propValuesList[propNamesList.indexOf("RF pos")];
            rfChField.text = propValuesList[propNamesList.indexOf("RF ch")];
            channelField.text = propValuesList[propNamesList.indexOf("channel")];
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:3}
}
##^##*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: addSequWindow
    width: 300
    height: 294

    property bool isEditMode: false
    property var changedIdList: []
    onChangedIdListChanged: isOneDevice = (changedIdList.length < 2/* && addSequWindow.isEditMode*/)
    property bool isOneDevice
    property string groupName: ""
    property var currentInput: quantityField
    property string selColor: isOneDevice ? "yellow" : ""

    function markAllInputsInactive()
    {
        quantityField.isActiveInput = false
        dmxField.isActiveInput = false
        rfPosField.isActiveInput = false
        rfChField.isActiveInput = false
        heightField.isActiveInput = false
        minAngField.isActiveInput = false
        maxAngField.isActiveInput = false
    }

    function add()
    {
        //--- Определяем инкремент канала DMX

        let isNegative = false
        let operatorIndex = dmxField.text.indexOf('+')

        if(operatorIndex === -1)
        {
            operatorIndex = dmxField.text.indexOf('-')
            if(operatorIndex !== -1)
                isNegative = true
        }

        let currentDmxValue = (operatorIndex === -1) ? Number(dmxField.text) : Number(dmxField.text.slice(0, operatorIndex))

        let dmxIncrement = 0
        if(operatorIndex !== -1)
        {
            dmxIncrement = Number(dmxField.text.slice(operatorIndex + 1))
            if(isNegative)
                dmxIncrement = -dmxIncrement
        }

        //--- Определяем инкремент RF pos

        isNegative = false
        operatorIndex = rfPosField.text.indexOf('+')

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

        //--- Определяем инкремент RF pos

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
        deviceManager.reloadPattern()

        for(let i = 0; i < Number(quantityField.text); i++)
        {
            project.addPatch( "Sequences",
                             [
                              {propName: "ID", propValue: currentId},
                              {propName: "DMX", propValue: currentDmxValue},
                              {propName: "RF pos", propValue: currentRfPosValue},
                              {propName: "RF ch", propValue: currentRfChValue},
                              {propName: "min ang", propValue: Number(minAngField.text)},
                              {propName: "max ang", propValue: Number(maxAngField.text)},
                              {propName: "height", propValue: Number(heightField.text)},
                              {propName: "color type", propValue: addSequWindow.selColor}
                             ])
            deviceManager.onEditPatch(
                                    [
                                     {propName: "ID", propValue: currentId},
                                     {propName: "DMX", propValue: currentDmxValue},
                                     {propName: "RF pos", propValue: currentRfPosValue},
                                     {propName: "RF ch", propValue: currentRfChValue},
                                     {propName: "min ang", propValue: Number(minAngField.text)},
                                     {propName: "max ang", propValue: Number(maxAngField.text)},
                                     {propName: "height", propValue: Number(heightField.text)},
                                     {propName: "color type", propValue: addSequWindow.selColor}
                                    ])

            if(groupName)
            {
                project.addPatchToGroup(groupName, currentId)
            }

            currentDmxValue += dmxIncrement
            currentRfPosValue += rfPosIncrement
            currentRfChValue += rfChIncrement
            currentId++
        }
    }

    function edit()
    {
        //--- Определяем инкремент канала DMX

        let isNegative = false
        let isDmxUnused = dmxField.text == "~"
        let operatorIndex = dmxField.text.indexOf('+')

        if(operatorIndex === -1)
        {
            operatorIndex = dmxField.text.indexOf('-')
            if(operatorIndex !== -1)
                isNegative = true
        }

        let currentDmxValue = (operatorIndex === -1) ? Number(dmxField.text) : Number(dmxField.text.slice(0, operatorIndex))

        let dmxIncrement = 0
        if(operatorIndex !== -1)
        {
            dmxIncrement = Number(dmxField.text.slice(operatorIndex + 1))
            if(isNegative)
                dmxIncrement = -dmxIncrement
        }

        //--- Определяем инкремент RF pos

        isNegative = false
        let isRfPoxUnused = rfPosField.text == "~"
        operatorIndex = rfPosField.text.indexOf('+')

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

        //--- Определяем инкремент RF pos

        isNegative = false
        let isRfChFieldUnused = rfChField.text == "~"
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

        let isMinAng  =  minAngField.text == "~"
        let isMaxAng  =  maxAngField.text == "~"
        let isHeight  =  heightField.text == "~"
        let isColor   =  addSequWindow.selColor == ""
        deviceManager.reloadPattern();
        for(let i = 0; i < changedIdList.length; i++)
        {
            project.onEditPatch(
                             [
                              {propName: "ID", propValue: changedIdList[i]},
                              isDmxUnused?{}:{propName: "DMX", propValue: currentDmxValue},
                              isMinAng?{}:{propName: "min ang", propValue: Number(minAngField.text)},
                              isMaxAng?{}:{propName: "max ang", propValue: Number(maxAngField.text)},
                              isRfPoxUnused?{}: {propName: "RF pos", propValue:  currentRfPosValue},
                              isRfChFieldUnused?{}:{propName: "RF ch", propValue: currentRfChValue},
                              isHeight?{}:{propName: "height", propValue: Number(heightField.text)},
                              isColor?{}:{propName: "color type", propValue: addSequWindow.selColor}
                             ])
            deviceManager.onEditPatch(
                        [
                         {propName: "ID", propValue: changedIdList[i]},
                         isDmxUnused?{}:{propName: "DMX", propValue: currentDmxValue},
                         isMinAng?{}:{propName: "min ang", propValue: Number(minAngField.text)},
                         isMaxAng?{}:{propName: "max ang", propValue: Number(maxAngField.text)},
                         isRfPoxUnused?{}:{propName: "RF pos", propValue: currentRfPosValue},
                         isRfChFieldUnused?{}:{propName: "RF ch", propValue: currentRfChValue},
                         isHeight?{}:{propName: "height", propValue: Number(heightField.text)},
                         isColor?{}:{propName: "color type", propValue: addSequWindow.selColor}
                        ])

            currentDmxValue += dmxIncrement
            currentRfPosValue += rfPosIncrement
            currentRfChValue += rfChIncrement
        }
    }

    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
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

            drag.target: addSequWindow
            drag.axis: Drag.XandYAxis

            drag.minimumX: applicationWindow.childWidgetsArea().x
            drag.maximumX: applicationWindow.childWidgetsArea().width - addSequWindow.width
            drag.minimumY: applicationWindow.childWidgetsArea().y
            drag.maximumY: applicationWindow.childWidgetsArea().height - addSequWindow.height
        }

        Text
        {
            id: windowTitle
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("Add Sequences")
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
                addSequWindow.destroy()
            }
        }

        //--- Рабочая область

        Rectangle
        {
            x: 4
            y: 34
            width: 164
            height: 70
            color: "#222222"
            radius: 2
        }

        Text
        {
            id: quantityText
            y: 40
            height: 17
            color: quantityField.isActiveInput ? "#27AE60" : "#ffffff"
            text: translationsManager.translationTrigger + qsTr("Quantity")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 194
            anchors.leftMargin: 35
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: MFXUIS.Fonts.robotoRegular.name

            visible: !(changedIdList.length > 1)
        }

        TextField
        {
            id: quantityField
            x: 99
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
                    addSequWindow.currentInput = this;
                    selectAll();
                    lastSelectedText = selectedText
                }
            }
        }

        TextField
        {
            id: dmxField
            x: 8
            y: 82
            width: 36
            height: 18
            text: isOneDevice? "1": "~"
            color: "#ffffff"
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
                return (Number(checkedText) >= 1 && Number(checkedText) < 509)
            }

//            validator: RegExpValidator { regExp: /[0-9]+/ }
//            maximumLength: 3

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
                    addSequWindow.currentInput = this
                    selectAll();
                    lastSelectedText = selectedText
                }
            }
        }

        TextField
        {
            id: rfPosField
            x: 48
            y: 82
            width: 36
            height: 18
            color: "#ffffff"
            text: isOneDevice? "1":"~"
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
                    addSequWindow.currentInput = this
                    selectAll();
                    lastSelectedText = selectedText
                }
            }
        }

        TextField
        {
            id: rfChField
            x: 88
            y: 82
            width: 36
            height: 18
            color: "#ffffff"
            text: isOneDevice? "1":"~"
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
                    addSequWindow.currentInput = this
                    selectAll();
                    lastSelectedText = selectedText
                }
            }
        }

        TextField
        {
            id: heightField
            x: 128
            y: 82
            width: 36
            height: 18
            color: "#ffffff"
            text: isOneDevice? 10: "~"
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
                    addSequWindow.currentInput = this
                    selectAll();
                    lastSelectedText = selectedText
                }
            }
        }



        Text {
            y: 64
            height: 17
            color: dmxField.isActiveInput ? "#27AE60" : "#ffffff"
            text: translationsManager.translationTrigger + qsTr("DMX")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            minimumPixelSize: 10
            anchors.leftMargin: 8
            anchors.rightMargin: 256
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 64
            height: 17
            color: rfPosField.isActiveInput ? "#27AE60" : "#ffffff"
            text: translationsManager.translationTrigger + qsTr("RF pos")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 48
            anchors.rightMargin: 216
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 64
            height: 17
            color: rfChField.isActiveInput ? "#27AE60" : "#ffffff"
            text: translationsManager.translationTrigger + qsTr("RF ch")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 88
            anchors.rightMargin: 176
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 64
            height: 17
            color: heightField.isActiveInput ? "#27AE60" : "#ffffff"
            text: translationsManager.translationTrigger + qsTr("height")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 128
            anchors.rightMargin: 136
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        CalcWidget
        {
            id: calcWidget
            x: 172
            y: 34

            minusButtonText: heightField.isActiveInput ? "." : "-"
        }

        MfxButton
        {
            id: setButton
            x: 172
            y: 226
            width: 124
            color: "#2F80ED"
            text: translationsManager.translationTrigger + qsTr("Set")
            enabled:
            {
                (addSequWindow.isEditMode && !isOneDevice)?
                 true:
                        dmxField.checkValue() &&
                        rfPosField.checkValue() &&
                        rfChField.checkValue() &&
                        heightField.checkValue() &&
                        minAngField.checkValue() &&
                        maxAngField.checkValue()

            }

            onClicked:
            {
                if(addSequWindow.isEditMode)
                {
                    addSequWindow.edit()
                    project.updateCurrent();
                }

                else
                {
                    addSequWindow.add()
                }

                applicationWindow.isPatchEditorOpened = false
                addSequWindow.destroy();
            }
        }

        //--- Визуальный индикатор

        Rectangle
        {
            id: circle
            x: 16
            y: 126
            width: 140
            height: width
            radius: width / 2
            color: "black"
            clip: true
        }

        MouseArea
        {
            id: handlersMovingArea
            width: 160
            height: 100
            x: circle.x - 10
            y: circle.y - 10

            property string currentHandler: ""

            onPressed:
            {
                let minHandlerX = minPointerHandler.mapToItem(handlersMovingArea, 5, 5).x
                let minHandlerY = minPointerHandler.mapToItem(handlersMovingArea, 5, 5).y
                let distanceToMinHamdler = Math.sqrt((minHandlerX - mouseX) * (minHandlerX - mouseX) + (minHandlerY - mouseY) * (minHandlerY - mouseY))

                let maxHandlerX = maxPointerHandler.mapToItem(handlersMovingArea, 5, 5).x
                let maxHandlerY = maxPointerHandler.mapToItem(handlersMovingArea, 5, 5).y
                let distanceToMaxHamdler = Math.sqrt((maxHandlerX - mouseX) * (maxHandlerX - mouseX) + (maxHandlerY - mouseY) * (maxHandlerY - mouseY))

                let distance = distanceToMaxHamdler <= distanceToMinHamdler ? distanceToMaxHamdler : distanceToMinHamdler

                if(distance < 20)
                {
                    cursorShape = Qt.BlankCursor
                    currentHandler = distance === distanceToMaxHamdler ? "max" : "min"
                }
            }

            onReleased:
            {
                cursorShape = Qt.ArrowCursor
                currentHandler = ""
            }

            onMouseXChanged:
            {
                if(containsPress)
                {
                    let currVal = Math.round(Number(-105 + mouseX * 1.44) / 5) * 5
                    
                    if( currVal < -105 )
                        currVal = -105;
                    else if( currVal > 105 )
                        currVal = 105;

                    if(currentHandler === "min")
                    {
                        if(maxAngField.text == "~")
                            minAngField.text = currVal
                        else if(currVal <= Number(maxAngField.text))
                            minAngField.text = currVal
                    }
                    else if(currentHandler === "max")
                    {
                        if(minAngField.text == "~")
                            maxAngField.text = currVal
                        else if(currVal >= Number(minAngField.text))
                            maxAngField.text = currVal
                    }
                }
            }
        }

        Rectangle
        {
            x: 20
            y: 216
            width: 132
            height: 70
            color: "#444444"
        }

        Shape {

            x: -4
            y: 100
            width: 160
            height: 160

            layer.enabled: true
            layer.samples: 4

            ShapePath
            {
                fillColor: "#444444"
                strokeColor: "#444444"
                strokeWidth: 0
                capStyle: ShapePath.FlatCap

                startX: 10; startY: 118

                PathLine
                {
                    x: 90
                    y: 96
                }

                PathLine
                {
                    x: 162
                    y: 118
                }

            }

            ShapePath
            {
                fillColor: "#888888"
                strokeColor: "#888888"
                strokeWidth: 0
                strokeStyle: ShapePath.DashLine
                capStyle: ShapePath.FlatCap

                startX: 90; startY: 96

                PathLine
                {
                    x: 90
                    y: 25
                }
            }
        }

        Text {
            y: 211
            height: 17
            color: minAngField.isActiveInput ? "#27AE60" : "#ffffff"
            text: translationsManager.translationTrigger + qsTr("min ang")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 39
            anchors.rightMargin: 218
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 211
            height: 17
            color: maxAngField.isActiveInput ? "#27AE60" : "#ffffff"
            text: translationsManager.translationTrigger + qsTr("max ang")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 90
            anchors.rightMargin: 167
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        TextField
        {
            id: minAngField
            x: 46
            y: 227
            width: 36
            height: 18
            color: "#ffffff"
            text: isOneDevice? "-105":"~"//"-105"
            horizontalAlignment: Text.AlignHCenter
            padding: 0
            leftPadding: -2
            font.pointSize: 8

            property bool isActiveInput: false
            property string lastSelectedText

            function checkValue()
            {
                if(text === "" || text === "~")
                    return false

                return ((Number(text) >= -105 && Number(text) <= 105) && Number(text) <= Number(maxAngField.text))
            }

            maximumLength: 4

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
                    addSequWindow.currentInput = this
                    selectAll();
                    lastSelectedText = selectedText
                }
            }
        }

        TextField
        {
            id: maxAngField
            x: 90
            y: 227
            width: 36
            height: 18
            color: "#ffffff"
            text: isOneDevice? "105":"~"//"105"
            horizontalAlignment: Text.AlignHCenter
            padding: 0
            leftPadding: -2
            font.pointSize: 8

            property bool isActiveInput: false
            property string lastSelectedText

            function checkValue()
            {
                if(text === "" || text === "~")
                    return false

                return ((Number(text) >= -105 && Number(text) <= 105) && Number(text) >= Number(minAngField.text))
            }

            maximumLength: 4

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
                    addSequWindow.currentInput = this
                    selectAll();
                    lastSelectedText = selectedText
                }
            }
        }

        Text {
            y: 107
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("0")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 79
            anchors.rightMargin: 207
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 105
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("o")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 86
            anchors.rightMargin: 200
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 217
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("-105")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 4
            anchors.rightMargin: 278
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 217
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("+105")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 144
            anchors.rightMargin: 136
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 211
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("o")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 19
            anchors.rightMargin: 267
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 211
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("o")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 161
            anchors.rightMargin: 125
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Rectangle
        {
            id: minPointer
            width: 1
            height: circle.height / 2
            x: circle.x + circle. width / 2
            y: circle.y + circle. height / 2 - height
            color: "#2F80ED"

            transform: Rotation
            {
                origin.x: 0
                origin.y: minPointer.height
                angle: (Number(minAngField.text) >=-105 && Number(minAngField.text) <=105) ? Number(minAngField.text) : -105
            }
        }

        Rectangle
        {
            id: minPointerHandler
            x: circle.x + circle. width / 2 - width / 2
            y: circle.y - height / 2
            width: 10
            height: width
            radius: width / 2
            color: minAngField.text != "-"? "#2F80ED" :"#ffffff"

            transform: Rotation
            {
                origin.x: minPointerHandler.width / 2
                origin.y: minPointerHandler.height / 2 + circle.height / 2
                angle: (Number(minAngField.text) >=-105 && Number(minAngField.text) <=105) ? Number(minAngField.text) : -105
            }
        }

        Rectangle
        {
            id: maxPointer
            width: 1
            height: circle.height / 2
            x: circle.x + circle. width / 2
            y: circle.y + circle. height / 2 - height
            color: "#2F80ED"

            transform: Rotation
            {
                origin.x: 0
                origin.y: maxPointer.height
                angle: (Number(maxAngField.text) >=-105 && Number(maxAngField.text) <=105) ? Number(maxAngField.text) : 105
            }
        }

        Rectangle
        {
            id: maxPointerHandler
            x: circle.x + circle. width / 2 - width / 2
            y: circle.y - height / 2
            width: 10
            height: width
            radius: width / 2
            color: maxAngField.text != "-"? "#2F80ED" :"#ffffff"

            transform: Rotation
            {
                origin.x: maxPointerHandler.width / 2
                origin.y: maxPointerHandler.height / 2 + circle.height / 2
                angle: (Number(maxAngField.text) >=-105 && Number(maxAngField.text) <=105) ? Number(maxAngField.text) : 105
            }
        }

        Rectangle
        {
            id: centerCircle
            anchors.centerIn: circle
            width: 10
            height: width
            radius: width / 2
            color: "white"
            clip: true
        }

        Text
        {
            id: effectText
            y: 266
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("Effect type")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 200
            anchors.leftMargin: 35
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        ButtonGroup
        {
            id: colorButtons
        }

        Button
        {
            id: colorButton1
            x: 120
            y: 258
            width: 32
            height: 32
            checkable: true
            checked: colorType == addSequWindow.selColor
            onClicked: addSequWindow.selColor = colorType

            property string colorType: "red"

            background: Rectangle
            {
                color: parent.colorType
                opacity: parent.checked ? 0.6 : 0.3
                radius: 2
            }

            Image
            {
                source: parent.checked ? "qrc:/checked" : ""
                anchors.centerIn: parent
            }

            ButtonGroup.group: colorButtons
        }

        Button
        {
            id: colorButton2
            x: 156
            y: 258
            width: 32
            height: 32
            checkable: true
            checked: colorType == addSequWindow.selColor
            onClicked: addSequWindow.selColor = colorType

            property string colorType: "blue"

            background: Rectangle
            {
                color: parent.colorType
                opacity: parent.checked ? 0.6 : 0.3
                radius: 2
            }

            Image
            {
                source: parent.checked ? "qrc:/checked" : ""
                anchors.centerIn: parent
            }

            ButtonGroup.group: colorButtons
        }

        Button
        {
            id: colorButton3
            x: 192
            y: 258
            width: 32
            height: 32
            checkable: true
            checked: colorType == addSequWindow.selColor
            onClicked: addSequWindow.selColor = colorType

            property string colorType: "green"

            background: Rectangle
            {
                color: parent.colorType
                opacity: parent.checked ? 0.6 : 0.3
                radius: 2
            }

            Image
            {
                source: parent.checked ? "qrc:/checked" : ""
                anchors.centerIn: parent
            }

            ButtonGroup.group: colorButtons
        }

        Button
        {
            id: colorButton4
            x: 228
            y: 258
            width: 32
            height: 32
            checkable: true
            checked: colorType == addSequWindow.selColor
            onClicked: addSequWindow.selColor = colorType

            property string colorType: "yellow"

            background: Rectangle
            {
                color: parent.colorType
                opacity: parent.checked ? 0.8 : 0.3
                radius: 2
            }

            Image
            {
                source: parent.checked ? "qrc:/checked" : ""
                anchors.centerIn: parent
            }

            ButtonGroup.group: colorButtons
        }

        Button
        {
            id: colorButton5
            x: 264
            y: 258
            width: 32
            height: 32
            checkable: true
            checked: colorType == addSequWindow.selColor
            onClicked: addSequWindow.selColor = colorType

            property string colorType: "purple"

            background: Rectangle
            {
                color: parent.colorType
                opacity: parent.checked ? 0.6 : 0.3
                radius: 2
            }

            Image
            {
                source: parent.checked ? "qrc:/checked" : ""
                anchors.centerIn: parent
            }

            ButtonGroup.group: colorButtons
        }

    }

    states: [
        State
        {
            name: "editMode"
            when: addSequWindow.isEditMode
            PropertyChanges {target: windowTitle; text: translationsManager.translationTrigger + qsTr("Edit sequences")}
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
            dmxField.text = propValuesList[propNamesList.indexOf("DMX")];
            rfPosField.text = propValuesList[propNamesList.indexOf("RF pos")];
            rfChField.text = propValuesList[propNamesList.indexOf("RF ch")];
            heightField.text = propValuesList[propNamesList.indexOf("height")];
            minAngField.text = propValuesList[propNamesList.indexOf("min ang")];
            maxAngField.text = propValuesList[propNamesList.indexOf("max ang")];

            var colorInd = propNamesList.indexOf( "color type" )
            if( colorInd != -1 )
                addSequWindow.selColor = propValuesList[colorInd]
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:3}D{i:2}D{i:3}D{i:4}D{i:7}D{i:8}D{i:9}D{i:12}D{i:14}D{i:16}D{i:18}
D{i:21}D{i:22}D{i:23}D{i:24}D{i:25}D{i:26}D{i:27}D{i:28}D{i:29}D{i:30}D{i:36}D{i:37}
D{i:38}D{i:40}D{i:42}D{i:43}D{i:44}D{i:45}D{i:46}D{i:47}D{i:48}D{i:50}D{i:52}D{i:54}
D{i:56}D{i:57}D{i:58}D{i:59}D{i:62}D{i:65}D{i:68}D{i:71}D{i:1}D{i:79}
}
##^##*/

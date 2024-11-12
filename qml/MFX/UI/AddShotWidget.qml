import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

import MFX.UI.Components.Basic 1.0
import MFX.UI.Styles 1.0 as MFXUIS
import MFX.Enums 1.0 as MFXE

Item
{
    id: addShotWidget
    width: 324
    height: 304

    property bool isEditMode: false
    property var changedIdList: []
    property string groupName: ""
    property var currentInput: quantityField
    property string selColor: "#FFD700"

    function markAllInputsInactive()
    {
        quantityField.isActiveInput = false
        //dmxField.isActiveInput = false
        rfPosField.isActiveInput = false
        rfChField.isActiveInput = false
        dmxChField.isActiveInput = false
        heightField.isActiveInput = false
        angField.isActiveInput = false
    }

    function add()
    {
        //--- Определяем инкремент канала DMX

        let isNegative = false
        //let operatorIndex = dmxField.text.indexOf('+')
        //
        //if(operatorIndex === -1)
        //{
        //    operatorIndex = dmxField.text.indexOf('-')
        //    if(operatorIndex !== -1)
        //        isNegative = true
        //}
        //
        //
        //
        //let currentDmxValue = (operatorIndex === -1) ? Number(dmxField.text) : Number(dmxField.text.slice(0, operatorIndex))
        //
        //let dmxIncrement = 0
        //if(operatorIndex !== -1)
        //{
        //    dmxIncrement = Number(dmxField.text.slice(operatorIndex + 1))
        //    if(isNegative)
        //        dmxIncrement = -dmxIncrement
        //}

        //--- Определяем инкремент RF pos

        isNegative = false
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

        //--- Определяем инкремент Dmx ch

        isNegative = false
        operatorIndex = dmxChField.text.indexOf('+')

        if(operatorIndex === -1)
        {
            operatorIndex = dmxChField.text.indexOf('-')
            if(operatorIndex !== -1)
                isNegative = true
        }

        let currentDmxChValue = (operatorIndex === -1) ? Number(dmxChField.text) : Number(dmxChField.text.slice(0, operatorIndex))

        let dmxChIncrement = 0
        if(operatorIndex !== -1)
        {
            dmxChIncrement = Number(dmxChField.text.slice(operatorIndex + 1))
            if(isNegative)
                dmxChIncrement = -dmxChIncrement
        }

        let currentId = project.lastPatchId() + 1;

        for(let i = 0; i < Number(quantityField.text); i++)
        {
            project.addPatch( MFXE.PatternType.Shot,
                             [
                              {propName: "ID", propValue: currentId},
                              {propName: "RF pos", propValue: currentRfPosValue},
                              {propName: "RF ch", propValue: currentRfChValue},
                              {propName: "DMX ch", propValue: currentDmxChValue},
                              {propName: "angle", propValue: Number(angField.text)},
                              {propName: "height", propValue: Number(heightField.text)},
                              {propName: "color type", propValue: addShotWidget.selColor},
                              {propName: "RF mode", propValue: modeSwitch.checked}
                             ])

            deviceManager.onEditPatch(
                [
                    {propName: "ID", propValue: currentId},
                    {propName: "RF pos", propValue: currentRfPosValue},
                    {propName: "RF ch", propValue: currentRfChValue},
                    {propName: "DMX ch", propValue: currentDmxChValue},
                    {propName: "angle", propValue: Number(angField.text)},
                    {propName: "height", propValue: Number(heightField.text)},
                    {propName: "color type", propValue: addShotWidget.selColor},
                    {propName: "RF mode", propValue: modeSwitch.checked}
                ])

            if(groupName)
            {
                project.addPatchToGroup(groupName, currentId)
            }

            //currentDmxValue += dmxIncrement
            currentRfPosValue += rfPosIncrement
            currentRfChValue += rfChIncrement
            currentDmxChValue += dmxChIncrement
            currentId++
        }
    }

    function edit()
    {
        //--- Определяем инкремент канала DMX

        let isNegative = false
        //let operatorIndex = dmxField.text.indexOf('+')
        //
        //if(operatorIndex === -1)
        //{
        //    operatorIndex = dmxField.text.indexOf('-')
        //    if(operatorIndex !== -1)
        //        isNegative = true
        //}
        //
        //
        //
        //let currentDmxValue = (operatorIndex === -1) ? Number(dmxField.text) : Number(dmxField.text.slice(0, operatorIndex))
        //
        //let dmxIncrement = 0
        //if(operatorIndex !== -1)
        //{
        //    dmxIncrement = Number(dmxField.text.slice(operatorIndex + 1))
        //    if(isNegative)
        //        dmxIncrement = -dmxIncrement
        //}

        //--- Определяем инкремент RF pos

        isNegative = false
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

        //--- Определяем инкремент Dmx ch

        isNegative = false
        operatorIndex = dmxChField.text.indexOf('+')

        if(operatorIndex === -1)
        {
            operatorIndex = dmxChField.text.indexOf('-')
            if(operatorIndex !== -1)
                isNegative = true
        }

        let currentDmxChValue = (operatorIndex === -1) ? Number(dmxChField.text) : Number(dmxChField.text.slice(0, operatorIndex))

        let dmxChIncrement = 0
        if(operatorIndex !== -1)
        {
            dmxChIncrement = Number(dmxChField.text.slice(operatorIndex + 1))
            if(isNegative)
                dmxChIncrement = -dmxChIncrement
        }

        for(let i = 0; i < changedIdList.length; i++)
        {
            project.onEditPatch(
                             [
                              {propName: "ID", propValue: changedIdList[i]},
                              {propName: "angle", propValue: Number(angField.text)},
                              {propName: "RF pos", propValue: currentRfPosValue},
                              {propName: "RF ch", propValue: currentRfChValue},
                              {propName: "DMX ch", propValue: currentDmxChValue},
                              {propName: "height", propValue: Number(heightField.text)},
                              {propName: "color type", propValue: addShotWidget.selColor},
                              {propName: "RF mode", propValue: modeSwitch.checked}
                             ])

            deviceManager.onEditPatch(
                [
                    {propName: "ID", propValue: changedIdList[i]},
                    {propName: "angle", propValue: Number(angField.text)},
                    {propName: "RF pos", propValue: currentRfPosValue},
                    {propName: "RF ch", propValue: currentRfChValue},
                    {propName: "DMX ch", propValue: currentDmxChValue},
                    {propName: "height", propValue: Number(heightField.text)},
                    {propName: "color type", propValue: addShotWidget.selColor},
                    {propName: "RF mode", propValue: modeSwitch.checked}
                ])

            currentRfPosValue += rfPosIncrement
            currentRfChValue += rfChIncrement
            currentDmxChValue += dmxChIncrement
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

            drag.target: addShotWidget
            drag.axis: Drag.XandYAxis

            drag.minimumX: applicationWindow.childWidgetsArea().x
            drag.maximumX: applicationWindow.childWidgetsArea().width - addShotWidget.width
            drag.minimumY: applicationWindow.childWidgetsArea().y
            drag.maximumY: applicationWindow.childWidgetsArea().height - addShotWidget.height
        }

        Text
        {
            id: windowTitle
            color: "#ffffff"
            text: translationsManager.translationTrigger + translationsManager.translationTrigger + qsTr("Add Shot")
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
                addShotWidget.destroy()
            }
        }

        //--- Рабочая область

        Rectangle
        {
            x: 4
            y: 34
            width: 188
            height: 70
            color: "#222222"
            radius: 2

            GridLayout
            {
                anchors.fill: parent
                anchors.margins: 4
                rows: 2

                Switch
                {
                    Layout.row: 0
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24

                    id: modeSwitch

                    indicator: Rectangle
                    {
                        width: modeSwitch.width
                        height: modeSwitch.height
                        x: 0
                        y: 0

                        radius: 2
                        color: "#000000"

                        Rectangle
                        {
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom

                            width: modeSwitch.width / 2
                            x: modeSwitch.checked ? modeSwitch.width - width : 0

                            radius: 2

                            color: modeSwitch.down ? "#649ce8" : "#2F80ED"

                            Behavior on x { SmoothedAnimation { duration: 175 } }
                        }

                        Text
                        {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.width / 2

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            lineHeightMode: Text.FixedHeight
                            lineHeight: 26

                            font.family: MFXUIS.Fonts.robotoRegular.name
                            font.pixelSize: 12

                            color: !modeSwitch.checked ? "#FFFFFF" : "#80FFFFFF"

                            Behavior on color { ColorAnimation { duration : 175 } }

                            text: translationsManager.translationTrigger + qsTr("DMX")
                        }

                        Text
                        {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.width / 2

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            lineHeightMode: Text.FixedHeight
                            lineHeight: 26

                            font.family: MFXUIS.Fonts.robotoRegular.name
                            font.pixelSize: 12

                            color: modeSwitch.checked ? "#FFFFFF" : "#80FFFFFF"

                            Behavior on color { ColorAnimation { duration : 175 } }

                            text: translationsManager.translationTrigger + qsTr("RF")
                        }
                    }

                    contentItem: Item {}
                }

                GridLayout
                {
                    Layout.row: 1
                    rows: 2
                    columns: 4

                    Text
                    {
                        Layout.row: 0
                        Layout.column: 0
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        color: quantityField.isActiveInput ? "#27AE60" : "#ffffff"
                        text: translationsManager.translationTrigger + qsTr("Quantity")
                        elide: Text.ElideMiddle
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        minimumPixelSize: 10
                        font.family: MFXUIS.Fonts.robotoRegular.name
                        visible: !addShotWidget.isEditMode
                    }

                    Text
                    {
                        Layout.row: 0
                        Layout.column: 1
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        color: rfPosField.isActiveInput ? "#27AE60" : "#ffffff"
                        text: translationsManager.translationTrigger + qsTr("RF pos")
                        elide: Text.ElideMiddle
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        minimumPixelSize: 10
                        font.family: MFXUIS.Fonts.robotoRegular.name
                        visible: modeSwitch.checked
                    }

                    Text
                    {
                        Layout.row: 0
                        Layout.column: 2
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        color: modeSwitch.checked && rfChField.isActiveInput ? "#27AE60" : !modeSwitch.checked && dmxChField.isActiveInput ? "#27AE60" : "#ffffff"
                        text: translationsManager.translationTrigger + (modeSwitch.checked ? qsTr("RF ch") : qsTr("DMX ch"))
                        elide: Text.ElideMiddle
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        minimumPixelSize: 10
                        font.family: MFXUIS.Fonts.robotoRegular.name
                    }

                    Text
                    {
                        Layout.row: 0
                        Layout.column: 3
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        color: heightField.isActiveInput ? "#27AE60" : "#ffffff"
                        text: translationsManager.translationTrigger + qsTr("Height")
                        elide: Text.ElideMiddle
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        minimumPixelSize: 10
                        font.family: MFXUIS.Fonts.robotoRegular.name
                    }

                    TextField
                    {
                        Layout.row: 1
                        Layout.column: 0
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 18
                        Layout.alignment: Qt.AlignHCenter

                        id: quantityField
                        text: "1"
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        padding: 0
                        leftPadding: -2
                        font.pointSize: 8
                        visible: !addShotWidget.isEditMode

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
                                addShotWidget.currentInput = this;
                                selectAll();
                                lastSelectedText = selectedText
                            }
                        }
                    }

                    TextField
                    {
                        Layout.row: 1
                        Layout.column: 1
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 18
                        Layout.alignment: Qt.AlignHCenter

                        id: rfPosField
                        color: "#ffffff"
                        text: "1"
                        horizontalAlignment: Text.AlignHCenter
                        padding: 0
                        leftPadding: -2
                        font.pointSize: 8
                        visible: modeSwitch.checked

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
                                addShotWidget.currentInput = this
                                selectAll();
                                lastSelectedText = selectedText
                            }
                        }
                    }

                    TextField
                    {
                        Layout.row: 1
                        Layout.column: 2
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 18
                        Layout.alignment: Qt.AlignHCenter

                        id: rfChField
                        color: "#ffffff"
                        text: "1"
                        horizontalAlignment: Text.AlignHCenter
                        padding: 0
                        leftPadding: -2
                        font.pointSize: 8
                        visible: modeSwitch.checked

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
                                addShotWidget.currentInput = this
                                selectAll();
                                lastSelectedText = selectedText
                            }
                        }
                    }

                    TextField
                    {
                        Layout.row: 1
                        Layout.column: 2
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 18
                        Layout.alignment: Qt.AlignHCenter

                        id: dmxChField
                        color: "#ffffff"
                        text: "1"
                        horizontalAlignment: Text.AlignHCenter
                        padding: 0
                        leftPadding: -2
                        font.pointSize: 8
                        visible: !modeSwitch.checked

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
                                addShotWidget.currentInput = this
                                selectAll();
                                lastSelectedText = selectedText
                            }
                        }
                    }

                    TextField
                    {
                        Layout.row: 1
                        Layout.column: 3
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 18
                        Layout.alignment: Qt.AlignHCenter

                        id: heightField
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
                                addShotWidget.currentInput = this
                                selectAll();
                                lastSelectedText = selectedText
                            }
                        }
                    }
                }
            }
        }

        CalcWidget
        {
            id: calcWidget
            x: 196
            y: 34

            minusButtonText: heightField.isActiveInput ? "." : "-"
        }

        MfxButton
        {
            id: setButton
            x: 196
            y: 236
            width: 124
            color: "#2F80ED"
            text: translationsManager.translationTrigger + qsTr("Set")
            enabled:
            {
                //dmxField.checkValue() &&
                        rfPosField.checkValue() &&
                        rfChField.checkValue() &&
                        dmxChField.checkValue() &&
                        heightField.checkValue() &&
                        angField.checkValue()

            }

            onClicked:
            {
                if(addShotWidget.isEditMode)
                {
                    addShotWidget.edit()
                }

                else
                {
                    addShotWidget.add()
                }

                applicationWindow.isPatchEditorOpened = false
                addShotWidget.destroy();
            }
        }

        //--- Визуальный индикатор

        Rectangle
        {
            id: circle
            x: 21
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
            height: 160
            x: circle.x - 10
            y: circle.y - 10

            property bool handled: false
            property int startX: 0

            onPressed:
            {
                let handlerX = pointerHandler.mapToItem(handlersMovingArea, 5, 5).x
                let handlerY = pointerHandler.mapToItem(handlersMovingArea, 5, 5).y
                let distanceToHandler = Math.sqrt((handlerX - mouseX) * (handlerX - mouseX) + (handlerY - mouseY) * (handlerY - mouseY))

                if(distanceToHandler < 20)
                {
                    cursorShape = Qt.BlankCursor
                    handled = true
                    startX = handlerX
                }
            }

            onReleased:
            {
                cursorShape = Qt.ArrowCursor
                handled = false
            }

            onMouseXChanged:
            {
                if(containsPress && handled)
                {
                    var ang = Math.round(((mouseX - startX) * 3) / 5) * 5
                    if( ang != 0 )
                        startX = mouseX

                    ang += Number(angField.text)

                    if( ang < -180 )
                       ang = -180
                    else if( ang > 180 )
                       ang = 180

                    angField.text = ang
                }
            }
        }

        Shape {

            x: -4
            y: 100
            width: 180
            height: 180

            layer.enabled: true
            layer.samples: 4

            ShapePath
            {
                fillColor: "#888888"
                strokeColor: "#888888"
                strokeWidth: 0
                strokeStyle: ShapePath.DashLine
                capStyle: ShapePath.FlatCap

                startX: 95; startY: 165

                PathLine
                {
                    x: 95
                    y: 27
                }
            }

            ShapePath
            {
                fillColor: "#888888"
                strokeColor: "#888888"
                strokeWidth: 0
                strokeStyle: ShapePath.DashLine
                capStyle: ShapePath.FlatCap

                startX: 25; startY: 96

                PathLine
                {
                    x: 165
                    y: 96
                }
            }
        }

        Text {
            y: 105
            x: 142
            height: 17
            color: angField.isActiveInput ? "#27AE60" : "#ffffff"
            text: translationsManager.translationTrigger + qsTr("angle")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 4
            anchors.leftMargin: -4
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        TextField
        {
            id: angField
            x: 132
            y: 120
            width: 36
            height: 18
            color: "#ffffff"
            text: "0"
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

                return (Number(text) >= -180 && Number(text) <= 180)
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
                    addShotWidget.currentInput = this
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
            y: 185
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("-90")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: -6
            anchors.rightMargin: 288
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 185
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("90")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 154
            anchors.rightMargin: 126
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 182
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("o")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 5
            anchors.rightMargin: 281
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 182
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("o")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 165
            anchors.rightMargin: 120
            minimumPixelSize: 10
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 259
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("o")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            minimumPixelSize: 10
            anchors.rightMargin: 199
            anchors.leftMargin: 87
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Text {
            y: 263
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("180")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            minimumPixelSize: 10
            anchors.rightMargin: 208
            anchors.leftMargin: 74
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        Rectangle
        {
            id: pointer
            width: 1
            height: circle.height / 2
            x: circle.x + circle. width / 2
            y: circle.y + circle. height / 2 - height
            color: "#2F80ED"

            transform: Rotation
            {
                origin.x: 0
                origin.y: pointer.height
                angle: (Number(angField.text) >= -180 && Number(angField.text) <= 180) ? Number(angField.text) : 0
            }
        }

        Rectangle
        {
            id: pointerHandler
            x: circle.x + circle. width / 2 - width / 2
            y: circle.y - height / 2
            width: 10
            height: width
            radius: width / 2
            color: "#2F80ED"

            transform: Rotation
            {
                origin.x: pointerHandler.width / 2
                origin.y: pointerHandler.height / 2 + circle.height / 2
                angle: (Number(angField.text) >=-180 && Number(angField.text) <= 180) ? Number(angField.text) : 0
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
            x: 50
            y: 276
            height: 17
            color: "#ffffff"
            text: translationsManager.translationTrigger + qsTr("Effect type")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideMiddle
            font.family: MFXUIS.Fonts.robotoRegular.name
        }

        ButtonGroup
        {
            id: colorButtons
        }

        Button
        {
            id: colorButton1
            x: 144
            y: 268
            width: 32
            height: 32
            checkable: true
            checked: colorType == addShotWidget.selColor
            onClicked: addShotWidget.selColor = colorType

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
            x: 180
            y: 268
            width: 32
            height: 32
            checkable: true
            checked: colorType == addShotWidget.selColor
            onClicked: addShotWidget.selColor = colorType

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
            x: 216
            y: 268
            width: 32
            height: 32
            checkable: true
            checked: colorType == addShotWidget.selColor
            onClicked: addShotWidget.selColor = colorType

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
            x: 252
            y: 268
            width: 32
            height: 32
            checkable: true
            checked: colorType == addShotWidget.selColor
            onClicked: addShotWidget.selColor = colorType

            property string colorType: "#FFD700"

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
            x: 288
            y: 268
            width: 32
            height: 32
            checkable: true
            checked: colorType == addShotWidget.selColor
            onClicked: addShotWidget.selColor = colorType

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
            when: addShotWidget.isEditMode
            PropertyChanges {target: windowTitle; text: translationsManager.translationTrigger + qsTr("Edit Shot")}
            PropertyChanges {target: setButton; text: translationsManager.translationTrigger + qsTr("Apply")}
            //PropertyChanges {target: quantityText; text: translationsManager.translationTrigger + qsTr("Patch ID")}
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

            rfPosField.text = propValuesList[propNamesList.indexOf("RF pos")];
            rfChField.text = propValuesList[propNamesList.indexOf("RF ch")];
            heightField.text = propValuesList[propNamesList.indexOf("height")];
            angField.text = propValuesList[propNamesList.indexOf("angle")];

            var ind = propNamesList.indexOf( "color type" )
            if( ind != -1 )
                addShotWidget.selColor = propValuesList[ind]

            ind = propNamesList.indexOf( "DMX ch" )
            if( ind != -1 )
                dmxChField.text = propValuesList[ind];

            ind = propNamesList.indexOf( "RF mode" )
            if( ind != -1 )
                modeSwitch.checked = propValuesList[ind];
        }
    }
}
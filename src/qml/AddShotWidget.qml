import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

Item
{
    id: addShotWidget
    width: 310
    height: 304

    property bool isEditMode: false
    property var changedIdList: []
    property string groupName: ""
    property var currentInput: quantityField

    function markAllInputsInactive()
    {
        quantityField.isActiveInput = false
        dmxField.isActiveInput = false
        rfPosField.isActiveInput = false
        rfChField.isActiveInput = false
        heightField.isActiveInput = false
        angField.isActiveInput = false
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

        for(let i = 0; i < Number(quantityField.text); i++)
        {
            project.addPatch( "Shot",
                             [
                              {propName: "ID", propValue: currentId},
                              {propName: "DMX", propValue: currentDmxValue},
                              {propName: "angle", propValue: Number(angField.text)},
                              {propName: "RF pos", propValue: currentRfPosValue},
                              {propName: "RF ch", propValue: currentRfChValue},
                              {propName: "height", propValue: Number(heightField.text)}
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

        for(let i = 0; i < changedIdList.length; i++)
        {
            project.editPatch(
                             [
                              {propName: "ID", propValue: changedIdList[i]},
                              {propName: "DMX", propValue: currentDmxValue},
                              {propName: "angle", propValue: Number(angField.text)},
                              {propName: "RF pos", propValue: currentRfPosValue},
                              {propName: "RF ch", propValue: currentRfChValue},
                              {propName: "height", propValue: Number(heightField.text)}
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
            text: qsTr("Add Shot")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: "Roboto"
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
            text: qsTr("Quantity")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 199
            anchors.leftMargin: 30
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: "Roboto"

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
                    addShotWidget.currentInput = this;
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
            text: "1"
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
                    addShotWidget.currentInput = this
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
                    addShotWidget.currentInput = this
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
                    addShotWidget.currentInput = this
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



        Text {
            y: 64
            height: 17
            color: dmxField.isActiveInput ? "#27AE60" : "#ffffff"
            text: qsTr("DMX")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            minimumPixelSize: 10
            anchors.leftMargin: 3
            anchors.rightMargin: 261
            font.family: "Roboto"
        }

        Text {
            y: 64
            height: 17
            color: rfPosField.isActiveInput ? "#27AE60" : "#ffffff"
            text: qsTr("RF pos")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 43
            anchors.rightMargin: 221
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Text {
            y: 64
            height: 17
            color: rfChField.isActiveInput ? "#27AE60" : "#ffffff"
            text: qsTr("RF ch")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 83
            anchors.rightMargin: 181
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Text {
            y: 64
            height: 17
            color: heightField.isActiveInput ? "#27AE60" : "#ffffff"
            text: qsTr("height")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 124
            anchors.rightMargin: 140
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        CalcWidget
        {
            id: calcWidget
            x: 182
            y: 34

            minusButtonText: heightField.isActiveInput ? "." : "-"
        }

        Button
        {
            id: setButton
            x: 182
            y: 221
            width: 124
            height: 24
            text: qsTr("Set")
            enabled:
            {
                dmxField.checkValue() &&
                        rfPosField.checkValue() &&
                        rfChField.checkValue() &&
                        heightField.checkValue() &&
                        angField.checkValue()

            }

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#888888" : "#2F80ED"
                    else
                        "#222222"
                }
                radius: 2
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: "Roboto"
                font.pixelSize: 12
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

            onPressed:
            {
                let handlerX = pointerHandler.mapToItem(handlersMovingArea, 5, 5).x
                let handlerY = pointerHandler.mapToItem(handlersMovingArea, 5, 5).y
                let distanceToHandler = Math.sqrt((handlerX - mouseX) * (handlerX - mouseX) + (handlerY - mouseY) * (handlerY - mouseY))

                if(distanceToHandler < 20)
                {
                    cursorShape = Qt.BlankCursor
                    handled = true
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
                        angField.text = Math.round(Number(-179 + mouseX * 3) / 5) * 5
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
            text: qsTr("angle")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 4
            anchors.leftMargin: -4
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        TextField
        {
            id: angField
            x: 132
            y: 120
            width: 36
            height: 18
            color: "#ffffff"
            text: "-115"
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

                return (Number(text) >= -179 && Number(text) < 181)
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
            text: qsTr("0")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 79
            anchors.rightMargin: 207
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Text {
            y: 105
            height: 17
            color: "#ffffff"
            text: qsTr("o")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 86
            anchors.rightMargin: 200
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Text {
            y: 185
            height: 17
            color: "#ffffff"
            text: qsTr("-90")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: -6
            anchors.rightMargin: 288
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Text {
            y: 185
            height: 17
            color: "#ffffff"
            text: qsTr("90")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 154
            anchors.rightMargin: 126
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Text {
            y: 182
            height: 17
            color: "#ffffff"
            text: qsTr("o")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 5
            anchors.rightMargin: 281
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Text {
            y: 182
            height: 17
            color: "#ffffff"
            text: qsTr("o")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 165
            anchors.rightMargin: 120
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Text {
            y: 259
            height: 17
            color: "#ffffff"
            text: qsTr("o")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            minimumPixelSize: 10
            anchors.rightMargin: 199
            anchors.leftMargin: 87
            font.family: "Roboto"
        }

        Text {
            y: 263
            height: 17
            color: "#ffffff"
            text: qsTr("180")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            minimumPixelSize: 10
            anchors.rightMargin: 208
            anchors.leftMargin: 74
            font.family: "Roboto"
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
                angle: (Number(angField.text) >=-179 && Number(angField.text) <=180) ? Number(angField.text) : 0
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
                angle: (Number(angField.text) >=-179 && Number(angField.text) <=180) ? Number(angField.text) : 0
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
            text: qsTr("Effect type")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideMiddle
            font.family: "Roboto"
        }

        ButtonGroup
        {
            id: colorButtons
        }

        Button
        {
            id: colorButton1
            x: 130
            y: 268
            width: 32
            height: 32
            checkable: true

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
            x: 166
            y: 268
            width: 32
            height: 32
            checkable: true

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
            x: 202
            y: 268
            width: 32
            height: 32
            checkable: true

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
            x: 238
            y: 268
            width: 32
            height: 32
            checkable: true

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
            x: 274
            y: 268
            width: 32
            height: 32
            checkable: true

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
            PropertyChanges {target: windowTitle; text: qsTr("Edit Shot")}
            PropertyChanges {target: setButton; text: qsTr("Apply")}
            PropertyChanges {target: quantityText; text: qsTr("Patch ID")}
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
            angField.text = propValuesList[propNamesList.indexOf("angle")];
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:3}
}
##^##*/

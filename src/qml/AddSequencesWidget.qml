import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

Item
{
    id: addSequWindow
    width: 300
    height: 250

    property var currentInput: quantityField

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
            color: "#ffffff"
            text: qsTr("Add Sequences")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: "Roboto"
            topPadding: 4
        }

        Button
        {
            id: closeButton
            width: 25
            height: 25
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

            onClicked: addSequWindow.destroy()
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
            y: 40
            height: 17
            color: quantityField.isActiveInput ? "#27AE60" : "#ffffff"
            text: qsTr("Quantity")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 194
            anchors.leftMargin: 35
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: "Roboto"
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

            property bool isActiveInput: true

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
                    isActiveInput = true
                    addSequWindow.currentInput = this
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
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            padding: 0
            font.pointSize: 8

            property bool isActiveInput: false

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
            horizontalAlignment: Text.AlignHCenter
            padding: 0
            font.pointSize: 8

            property bool isActiveInput: false

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
            horizontalAlignment: Text.AlignHCenter
            padding: 0
            font.pointSize: 8

            property bool isActiveInput: false

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
            horizontalAlignment: Text.AlignHCenter
            padding: 0
            font.pointSize: 8

            property bool isActiveInput: false

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
                    isActiveInput = true
                    addSequWindow.currentInput = this
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
            anchors.leftMargin: 8
            anchors.rightMargin: 256
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
            anchors.leftMargin: 48
            anchors.rightMargin: 216
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
            anchors.leftMargin: 88
            anchors.rightMargin: 176
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
            anchors.leftMargin: 128
            anchors.rightMargin: 136
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        CalcWidget
        {
            id: calcWidget
            x: 172
            y: 34
        }

        Button
        {
            id: setButton
            x: 172
            y: 221
            width: 124
            height: 24
            text: qsTr("Set")

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#888888" : "#2F80ED"
                    else
                        "#444444"
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
                project.addPatch( "Sequences",
                                 [{propName: "DMX", propValue: Number(dmxField.text)},
                                  {propName: "min ang", propValue: Number(minAngField.text)},
                                  {propName: "max ang", propValue: Number(maxAngField.text)},
                                  {propName: "RF pos", propValue: Number(rfPosField.text)},
                                  {propName: "RF ch", propValue: Number(rfChField.text)},
                                  {propName: "height", propValue: Number(heightField.text)}
                                 ])

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

        Rectangle
        {
            x: 16
            y: 210
            width: 140
            height: 80
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

                startX: 20; startY: 110

                PathLine
                {
                    x: 90
                    y: 96
                }

                PathLine
                {
                    x: 160
                    y: 110
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
            text: qsTr("min ang")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 39
            anchors.rightMargin: 218
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Text {
            y: 211
            height: 17
            color: maxAngField.isActiveInput ? "#27AE60" : "#ffffff"
            text: qsTr("max ang")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 90
            anchors.rightMargin: 167
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        TextField
        {
            id: minAngField
            x: 46
            y: 227
            width: 36
            height: 18
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            padding: 0
            font.pointSize: 8

            property bool isActiveInput: false

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
            horizontalAlignment: Text.AlignHCenter
            padding: 0
            font.pointSize: 8

            property bool isActiveInput: false

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
            y: 207
            height: 17
            color: "#ffffff"
            text: qsTr("-115")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 4
            anchors.rightMargin: 278
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Text {
            y: 207
            height: 17
            color: "#ffffff"
            text: qsTr("+115")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 144
            anchors.rightMargin: 136
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Text {
            y: 201
            height: 17
            color: "#ffffff"
            text: qsTr("o")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 19
            anchors.rightMargin: 267
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Text {
            y: 201
            height: 17
            color: "#ffffff"
            text: qsTr("o")
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.pixelSize: 8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 161
            anchors.rightMargin: 125
            minimumPixelSize: 10
            font.family: "Roboto"
        }

        Rectangle
        {
            id: minPointer
            width: circle.width / 2
            height: 1
            x: circle.x + circle. width / 2
            y: circle.y + circle. height / 2
            transform: Rotation { origin.x: 0; origin.y: 0; angle: 90}
            color: "#2F80ED"
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
    }



    Connections
    {
        target: calcWidget
        function onDigitClicked(digit) {currentInput.text = currentInput.text + digit}
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:3}D{i:24}D{i:25}D{i:36}D{i:42}D{i:43}D{i:44}D{i:45}D{i:46}D{i:47}
}
##^##*/

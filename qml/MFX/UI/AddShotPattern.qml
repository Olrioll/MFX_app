import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: addShotPatternWidget
    width: 164
    height: 284

    property var currentInput
    property bool isEditMode: false
    property string patternName

    function markAllInputsInactive()
    {
        prefireField.isActiveInput = false
        timeField.isActiveInput = false
    }

    Rectangle
    {
        id: blockingMouseInput
        color: "black"
        opacity: 0.5
        x: -addShotPatternWidget.x
        y: -addShotPatternWidget.y
        width: applicationWindow.width
        height: applicationWindow.height

        MouseArea
        {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        }
    }

    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        radius: 2
        color: "#444444"

        ColumnLayout
        {
            anchors.fill: parent
            anchors.leftMargin: 2
            anchors.rightMargin: 2
            anchors.bottomMargin: 4

            Item
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 28

                Text
                {
                    color: "#ffffff"
                    text: "Add shot pattern"
                    elide: Text.ElideMiddle
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: MFXUIS.Fonts.robotoRegular.name
                    font.pixelSize: 12
                }

                MouseArea
                {
                    id: mouseArea
                    anchors.fill: parent
                
                    drag.target: addShotPatternWidget
                    drag.axis: Drag.XandYAxis
                
                    drag.minimumX: applicationWindow.childWidgetsArea().x
                    drag.maximumX: applicationWindow.childWidgetsArea().width - addShotPatternWidget.width
                    drag.minimumY: applicationWindow.childWidgetsArea().y
                    drag.maximumY: applicationWindow.childWidgetsArea().height - addShotPatternWidget.height
                }

                Button
                {
                    id: closeButton
                    width: 25
                    height: 25
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    background: Rectangle
                    {
                        color: "#444444"
                        opacity: 0
                    }
                
                    Image
                    {
                        source: "qrc:/utilityCloseButton"
                    }
                
                    onClicked:
                    {
                        applicationWindow.contentItem.focus = true
                        addShotPatternWidget.destroy()
                    }
                }
            }

            Rectangle
            {
                Layout.fillWidth: true
                Layout.preferredHeight: 48

                radius: 2
                color: "#222222"

                GridLayout
                {
                    anchors.fill: parent
                    anchors.margins:4
                    rows: 2
                    columns: 2
                
                    Text
                    {
                        Layout.row: 0
                        Layout.column: 0
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                
                        color: prefireField.isActiveInput ? "#27AE60" : "#ffffff"
                        text: translationsManager.translationTrigger + qsTr("Prefire")
                        elide: Text.ElideMiddle
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        minimumPixelSize: 10
                        font.family: MFXUIS.Fonts.robotoRegular.name
                    }
                
                    Text
                    {
                        Layout.row: 0
                        Layout.column: 1
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                
                        color: timeField.isActiveInput ? "#27AE60" : "#ffffff"
                        text: translationsManager.translationTrigger + qsTr("Time")
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
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 18
                
                        id: prefireField
                        text: "1"
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        padding: 0
                        leftPadding: -2
                        font.pointSize: 8
                        anchors.leftMargin: 2
                        anchors.bottomMargin: 2

                        property bool isActiveInput: false
                        property string lastSelectedText

                        function checkValue()
                        {
                            if(text === "")
                                return false

                            return (Number(text) >= 0 && Number(text) < 1000)
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
                                isActiveInput = true;
                                addShotPatternWidget.currentInput = this;
                                selectAll();
                                lastSelectedText = selectedText
                            }
                        }
                    }
                
                    TextField
                    {
                        Layout.row: 1
                        Layout.column: 1
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 18
                
                        id: timeField
                        text: "1"
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        padding: 0
                        leftPadding: -2
                        font.pointSize: 8
                        anchors.rightMargin: 2
                        anchors.bottomMargin: 2

                        property bool isActiveInput: false
                        property string lastSelectedText

                        function checkValue()
                        {
                            if(text === "")
                                return false

                            return (Number(text) >= 0 && Number(text) < 1000)
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
                                isActiveInput = true;
                                addShotPatternWidget.currentInput = this;
                                selectAll();
                                lastSelectedText = selectedText
                            }
                        }
                    }
                }
            }

            Item
            {
                Layout.fillHeight: true
            }

            CalcWidget
            {
                Layout.alignment: Qt.AlignHCenter

                id: calcWidget
            }

            MfxButton
            {
                Layout.fillWidth: true

                id: acceptButton
                text: translationsManager.translationTrigger + qsTr("Apply")
                color: "#2F80ED"
                enabled: prefireField.checkValue() && timeField.checkValue()

                onClicked:
                {
                    if( isEditMode )
                        patternManager.editShotPattern( patternName, Number(prefireField.text), Number(timeField.text) );
                    else
                        patternManager.addShotPattern( Number(prefireField.text), Number(timeField.text) );

                    applicationWindow.contentItem.focus = true
                    addShotPatternWidget.destroy()
                }
            }
        }
    }

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
        if( isEditMode )
        {
            var pattern = patternManager.patternByName( patternManager.selectedShotPatternName )

            patternName = pattern.name
            prefireField.text = pattern.prefireDuration
            timeField.text = pattern.getProperties()["shotTime"]
        }
    }
}
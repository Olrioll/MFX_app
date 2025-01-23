import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

import MFX.UI.Styles 1.0 as MFXUIS
import MFX.UI.Components.Basic 1.0
import MFX.UI.Components.Templates 1.0 as MFXUICT
import MFX.UI.Components.Templates.TimeInput 1.0

Item
{
    id: addShotPatternWidget
    width: 184
    height: 290

    property var currentInput
    property bool isEditMode: false
    property string patternName

    function markAllInputsInactive()
    {
        timeField.isActiveInput = false
        displayNameField.isActiveInput = false
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

            GridLayout
            {
                Layout.fillWidth: true
                Layout.leftMargin: 4
                Layout.rightMargin: 4

                columns: 2

                Text
                {
                    text: translationsManager.translationTrigger + qsTr("Name")
                    color: displayNameField.isActiveInput ? "#27AE60" : "#ffffff"
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    minimumPixelSize: 10
                    font.family: MFXUIS.Fonts.robotoRegular.name
                }

                TextField
                {
                    id: displayNameField
                    property bool isActiveInput: false
                    property string lastSelectedText

                    Layout.fillWidth: true
                    Layout.preferredHeight: 22

                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 8
                    maximumLength: 10

                    background: Rectangle
                    {
                        color: "#000000"
                        radius: 2
                    }

                    onFocusChanged:
                    {
                        if( focus )
                        {
                            selectAll()

                            lastSelectedText = selectedText

                            markAllInputsInactive();
                            isActiveInput = true;
                            addShotPatternWidget.currentInput = this;
                        }
                    }
                }

                Text
                {
                    color: timeField.isActiveInput ? "#27AE60" : "#ffffff"
                    text: translationsManager.translationTrigger + qsTr("Time")
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    minimumPixelSize: 10
                    font.family: MFXUIS.Fonts.robotoRegular.name
                }

                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24

                    radius: 2
                    color: "#222222"

                    TimeInput
                    {
                        id: timeField

                        anchors.fill: parent

                        onChangeActiveField:
                        {
                            markAllInputsInactive();
                            isActiveInput = true;
                            addShotPatternWidget.currentInput = field;
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
                Layout.leftMargin: 2
                Layout.rightMargin: 2
                Layout.bottomMargin: 2

                id: acceptButton
                text: translationsManager.translationTrigger + qsTr("Apply")
                color: "#2F80ED"
                enabled: timeField.checkValue()

                onClicked:
                {
                    if( isEditMode )
                        patternManager.editShotPattern( patternName, displayNameField.text, timeField.getTimeMs() );
                    else
                        patternManager.addShotPattern( displayNameField.text, timeField.getTimeMs() );

                    applicationWindow.contentItem.focus = true
                    addShotPatternWidget.destroy()
                }
            }
        }
    }

    Connections
    {
        target: calcWidget

        function onDigitClicked( digit )
        {
            if( currentInput.lastSelectedText === currentInput.text )
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
            displayNameField.text = pattern.getProperties()["displayName"]
            timeField.setTimeMs( Number( pattern.getProperties()["shotTime"] ) )
        }
    }
}
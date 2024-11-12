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
                Layout.preferredHeight: 42

                radius: 2
                color: "#222222"

                GridLayout
                {
                    anchors.fill: parent
                    anchors.margins: 4
                    columns: 2

                    Item
                    {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text
                        {
                            color: prefireField.isActiveInput ? "#27AE60" : "#ffffff"
                            text: translationsManager.translationTrigger + qsTr("Prefire")
                            elide: Text.ElideMiddle
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            minimumPixelSize: 10
                            font.family: MFXUIS.Fonts.robotoRegular.name
                        }
                    }

                    Item
                    {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text
                        {
                            color: timeField.isActiveInput ? "#27AE60" : "#ffffff"
                            text: translationsManager.translationTrigger + qsTr("Time")
                            elide: Text.ElideMiddle
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            minimumPixelSize: 10
                            font.family: MFXUIS.Fonts.robotoRegular.name
                        }
                    }

                    Item
                    {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        TimeInput
                        {
                            id: prefireField

                            onChangeActiveField:
                            {
                                markAllInputsInactive();
                                isActiveInput = true;
                                addShotPatternWidget.currentInput = field;
                            }
                        }
                    }

                    Item
                    {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        TimeInput
                        {
                            id: timeField

                            onChangeActiveField:
                            {
                                markAllInputsInactive();
                                isActiveInput = true;
                                addShotPatternWidget.currentInput = field;
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
                        patternManager.editShotPattern( patternName, prefireField.getTimeMs(), timeField.getTimeMs() );
                    else
                        patternManager.addShotPattern( prefireField.getTimeMs(), timeField.getTimeMs() );

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
            prefireField.setTimeMs( pattern.prefireDuration )
            timeField.setTimeMs( Number( pattern.getProperties()["shotTime"] ) )
        }
    }
}
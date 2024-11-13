import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI.Components.Basic 1.0
import MFX.UI.Components.Templates 1.0
import MFX.UI.Components.MainScreen 1.0
import MFX.Enums 1.0
import MFX.UI.Styles 1.0

FocusScope
{
    id: mainScreen

    property var sceneWidget: null
    property alias playerWidget: playerWidget
    property string cueName

    focus: true

    Shortcut
    {
        sequence: "Space" //Qt.Key_Space
        onActivated: playerWidget.tooglePlay()
    }

    function setupSceneWidget(widget)
    {
        sceneWidget = widget

        if(!sceneWidget)
            return

        sceneWidget.parent = sceneWidgetContainer
        sceneWidget.anchors.fill = sceneWidgetContainer
        sceneWidget.anchors.topMargin = 5
        sceneWidget.anchors.rightMargin = 5
        sceneWidget.anchors.leftMargin = 5
        sceneWidget.anchors.bottomMargin = 5
        sceneWidget.visible = true// Временно закомментировали - сцена всегда должна быть видима = visualizationButton.checked
    }

    function adjustBackgroundImageOnX()
    {
        console.log( "MainScreen.adjustBackgroundImageOnX" )
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

    SplitView
    {
        anchors.fill: parent
        orientation: Qt.Vertical

        handle: Rectangle
        {
            implicitHeight: 4

            color: SplitHandle.pressed ? Qt.lighter("#6F6F6F", 1.5)
                : (SplitHandle.hovered ? Qt.lighter("#6F6F6F", 1.1) : "#6F6F6F")
        }

        Item
        {
            SplitView.fillHeight: true
            SplitView.fillWidth: true

            ColumnLayout
            {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.right: rightPanel.left
                anchors.bottom: parent.bottom

                Rectangle
                {
                    id: mainScreenMenu

                    Layout.fillWidth: true
                    Layout.preferredHeight: 28
                    Layout.maximumHeight: 28
                    Layout.minimumHeight: 28

                    Layout.alignment: Qt.AlignTop

                    color: "black"

                    RowLayout
                    {
                        anchors.fill: parent
                        anchors.margins: 2
                        anchors.rightMargin: 6

                        spacing: 2

                        Item
                        {
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

                        Item
                        {
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

                        Item
                        {
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

                        LayoutSpacer {}

                        Item
                        {
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

                        Item
                        {
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
                }

                Item
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    CalculatorComponent
                    {
                        id: calculatorComponent
                    }

                    CueContentComponent
                    {
                        id: cueContentComponent
                    }

                    DevicesListComponent
                    {
                        id: devicesListComponent
                    }

                    CueListComponent
                    {
                        id: cueListComponent
                    }

                    Loader
                    {
                        id: leftPanelLoader

                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        anchors.margins: 2

                        property int minWidth: 130
                        property int maxWidth: minWidth * 3

                        states:
                        [
                            State
                            {
                                name: "hidden"
                                when: !leftDeviceListButton.checked && !cueListButton.checked
                                PropertyChanges
                                {
                                    target: leftPanelLoader
                                    width: 0
                                    sourceComponent: undefined
                                }

                                AnchorChanges
                                {
                                    target: leftPanelResizeArea
                                    anchors.top: undefined
                                    anchors.right: undefined
                                    anchors.bottom: undefined
                                }
                            },
                            State
                            {
                                name: "cue"
                                when: cueListButton.checked
                                PropertyChanges
                                {
                                    target: leftPanelLoader
                                    width: 200
                                    minWidth: 180
                                    maxWidth: minWidth * 2
                                    sourceComponent: cueListComponent
                                }

                                AnchorChanges
                                {
                                    target: leftPanelResizeArea
                                    anchors.top: parent.top
                                    anchors.left: parent.right
                                    anchors.bottom: parent.bottom
                                }
                            },
                            State
                            {
                                name: "devices"
                                when: leftDeviceListButton.checked
                                PropertyChanges
                                {
                                    target: leftPanelLoader
                                    width: 200
                                    sourceComponent: devicesListComponent
                                }

                                AnchorChanges
                                {
                                    target: leftPanelResizeArea
                                    anchors.top: parent.top
                                    anchors.left: parent.right
                                    anchors.bottom: parent.bottom
                                }
                            }
                        ]

                        MfxMouseArea
                        {
                            id: leftPanelResizeArea
                            width: 4
                    
                            property int previousX
                    
                            cursor: Qt.SizeHorCursor
                    
                            onPressed:
                            {
                                previousX = mouseX
                            }
                    
                            onMouseXChanged:
                            {
                                var dx = previousX - mouseX
                    
                                if( (leftPanelLoader.width - dx) < leftPanelLoader.minWidth )
                                    leftPanelLoader.width = leftPanelLoader.minWidth
                                else if( (leftPanelLoader.width - dx) > leftPanelLoader.maxWidth )
                                    leftPanelLoader.width = leftPanelLoader.maxWidth
                                else
                                    leftPanelLoader.width = leftPanelLoader.width - dx
                            }
                        }
                    }

                    Item
                    {
                        id: sceneWidgetContainer

                        anchors.left: leftPanelLoader.right
                        anchors.top: parent.top
                        anchors.right: calculatorLoader.left
                        anchors.bottom: parent.bottom
                    }

                    Loader
                    {
                        id: calculatorLoader

                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: rightPanelLoader.left

                        anchors.topMargin: 2

                        states:
                        [
                            State
                            {
                                name: "visible"
                                when: actionstButton.checked
                                PropertyChanges
                                {
                                    target: calculatorLoader
                                    width: 176
                                    sourceComponent: calculatorComponent
                                }

                                AnchorChanges
                                {
                                    target: calculatorResizeArea
                                    anchors.top: calculatorLoader.top
                                    anchors.right: calculatorLoader.left
                                    anchors.bottom: calculatorLoader.bottom
                                }
                            },
                            State
                            {
                                name: "hidden"
                                when: !actionstButton.checked
                                PropertyChanges
                                {
                                    target: calculatorLoader
                                    width: 0
                                    sourceComponent: undefined
                                }

                                PropertyChanges
                                {
                                    target: calculatorResizeArea
                                    enabled: false
                                }

                                AnchorChanges
                                {
                                    target: calculatorResizeArea
                                    anchors.top: undefined
                                    anchors.right: undefined
                                    anchors.bottom: undefined
                                }
                            }
                        ]

                        MfxMouseArea
                        {
                            id: calculatorResizeArea
                            width: 4

                            property int previousX

                            cursor: Qt.SizeHorCursor

                            onPressed:
                            {
                                previousX = mouseX
                            }

                            onMouseXChanged:
                            {
                                var dx = mouseX - previousX

                                if( (rightPanelLoader.width - dx) < rightPanelLoader.minWidth )
                                    rightPanelLoader.width = rightPanelLoader.minWidth
                                else if( (rightPanelLoader.width - dx) > rightPanelLoader.maxWidth )
                                    rightPanelLoader.width = rightPanelLoader.maxWidth
                                else
                                    rightPanelLoader.width = rightPanelLoader.width - dx
                            }
                        }
                    }

                    Loader
                    {
                        id: rightPanelLoader

                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom

                        anchors.topMargin: 2
                        anchors.rightMargin: 6

                        property int minWidth: 130
                        property int maxWidth: minWidth * 3

                        states:
                        [
                            State
                            {
                                name: "hidden"
                                when: !rightDeviceListButton.checked && !actionstButton.checked
                                PropertyChanges
                                {
                                    target: rightPanelLoader
                                    width: 0
                                    sourceComponent: undefined
                                }

                                PropertyChanges
                                {
                                    target: rightPanelResizeArea
                                    enabled: false
                                }

                                AnchorChanges
                                {
                                    target: rightPanelResizeArea
                                    anchors.top: undefined
                                    anchors.right: undefined
                                    anchors.bottom: undefined
                                }
                            },
                            State
                            {
                                name: "actions"
                                when: actionstButton.checked
                                PropertyChanges
                                {
                                    target: rightPanelLoader
                                    width: 330
                                    minWidth: 300
                                    maxWidth:  minWidth * 2
                                    sourceComponent: cueContentComponent
                                }

                                AnchorChanges
                                {
                                    target: rightPanelResizeArea
                                    anchors.top: rightPanelLoader.top
                                    anchors.right: rightPanelLoader.left
                                    anchors.bottom: rightPanelLoader.bottom
                                }
                            },
                            State
                            {
                                name: "devices"
                                when: rightDeviceListButton.checked
                                PropertyChanges
                                {
                                    target: rightPanelLoader
                                    width: 200
                                    sourceComponent: devicesListComponent
                                }

                                AnchorChanges
                                {
                                    target: rightPanelResizeArea
                                    anchors.top: rightPanelLoader.top
                                    anchors.right: rightPanelLoader.left
                                    anchors.bottom: rightPanelLoader.bottom
                                }
                            }
                        ]

                        MfxMouseArea
                        {
                            id: rightPanelResizeArea
                            width: 4

                            property int previousX

                            cursor: Qt.SizeHorCursor

                            onPressed:
                            {
                            console.log("!!!!")
                                previousX = mouseX
                            }

                            onMouseXChanged:
                            {
                                var dx = mouseX - previousX

                                if( (parent.width - dx) < parent.minWidth )
                                    parent.width = parent.minWidth
                                else if( (parent.width - dx) > parent.maxWidth )
                                    parent.width = parent.maxWidth
                                else
                                    parent.width = parent.width - dx
                            }
                        }
                    }
                }
            }

            RightPanel
            {
                id: rightPanel

                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                anchors.topMargin: 2
                anchors.bottomMargin: 2
            }
        }

        Player
        {
            SplitView.fillHeight: true
            SplitView.fillWidth: true
            SplitView.preferredHeight: playerWidget.minHeight
            SplitView.minimumHeight: playerWidget.minHeight
            SplitView.maximumHeight: playerWidget.maxHeight
            Layout.leftMargin: 2
            Layout.rightMargin: 2

            id: playerWidget
        }
    }
}
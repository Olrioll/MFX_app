import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import MFX.UI.Components.Basic 1.0
import MFX.UI.Components.Templates 1.0
import MFX.UI.Components.MainScreen 1.0
import MFX.Enums 1.0
import MFX.UI.Styles 1.0

import "qrc:/"

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
        //context: Qt.ApplicationShortcut
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

                        property int minWidth: 80

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
                                    sourceComponent: cueListComponent
                                }

                                AnchorChanges
                                {
                                    target: leftPanelResizeArea
                                    anchors.top: leftPanelLoader.top
                                    anchors.right: leftPanelLoader.right
                                    anchors.bottom: leftPanelLoader.bottom
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
                                    anchors.top: leftPanelLoader.top
                                    anchors.right: leftPanelLoader.right
                                    anchors.bottom: leftPanelLoader.bottom
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
                                var dx = mouseX - previousX
                    
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

                        anchors.margins: 2
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
                            }
                        ]
                    }

                    Loader
                    {
                        id: rightPanelLoader

                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom

                        anchors.topMargin: 2
                        anchors.rightMargin: 6

                        property int minWidth: 120

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
                                    width: 200
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

            SideDockedWindow
            {
                id: rightPanel

                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                anchors.topMargin: 2
                anchors.bottomMargin: 2

                caption: translationsManager.translationTrigger + qsTr("Actions")
                minWidth: 200
                isExpanded: true
                curInd: 1

                contentItem : Item
                {
                    width: 372

                    Rectangle
                    {
                        id: rightPanelBackground
                        anchors.fill: parent
                        color: "#222222"
                    }

                    RowLayout
                    {
                        id: rightPanelButtons

                        MfxButton
                        {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 68

                            id: sequencesButton
                            checkable: true
                            text: translationsManager.translationTrigger + qsTr("Sequences")
                            textSize: 10
                            color: "#2F80ED"

                            ButtonGroup.group: rightButtonsGroup

                            visible: true
                        }

                        MfxButton
                        {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 68

                            id: dimmerButton
                            checkable: true
                            text: translationsManager.translationTrigger + qsTr("Dimmer")
                            textSize: 10
                            color: "#2F80ED"

                            ButtonGroup.group: rightButtonsGroup

                            //TODO-DEVICES-TYPES пока не используем другие типы устройств - только Sequences, поэтому комментируем
                            //                   Когда понадобится восстановить, делаем поиск по TODO-DEVICES-TYPES
                            visible: false
                        }

                        MfxButton
                        {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 68

                            id: shotButton
                            checkable: true
                            text: translationsManager.translationTrigger + qsTr("Shot")
                            textSize: 10
                            color: "#2F80ED"

                            ButtonGroup.group: rightButtonsGroup

                            visible: true
                        }

                        MfxButton
                        {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 68

                            id: pyroButton
                            checkable: true
                            text: translationsManager.translationTrigger + qsTr("Pyro")
                            textSize: 10
                            color: "#2F80ED"

                            ButtonGroup.group: rightButtonsGroup

                            //TODO-DEVICES-TYPES пока не используем другие типы устройств - только Sequences, поэтому комментируем
                            //                   Когда понадобится восстановить, делаем поиск по TODO-DEVICES-TYPES
                            visible: false
                        }

                        MfxButton
                        {
                            Layout.fillWidth: true
                            Layout.preferredWidth: 68

                            id: cueButton
                            checkable: true
                            text: translationsManager.translationTrigger + qsTr("Cue")
                            textSize: 10

                            ButtonGroup.group: rightButtonsGroup

                            //TODO-DEVICES-TYPES пока не используем другие типы устройств - только Sequences, поэтому комментируем
                            //                   Когда понадобится восстановить, делаем поиск по TODO-DEVICES-TYPES
                            visible: false
                        }

                        ButtonGroup
                        {
                            id: rightButtonsGroup
                            checkedButton: sequencesButton
                        }

                        MfxButton
                        {
                            id: addButton
                            text: translationsManager.translationTrigger + qsTr("+")

                            //TODO-DEVICES-TYPES пока не используем другие типы устройств - только Sequences, поэтому комментируем
                            //                   Когда понадобится восстановить, делаем поиск по TODO-DEVICES-TYPES
                            visible: false
                        }
                    }

                    Item
                    {
                        id: actionViewWidget

                        anchors.topMargin: 2
                        anchors.top: rightPanelButtons.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom

                        Rectangle
                        {
                            id: actionViewBackground
                            anchors.fill: parent
                            color: "#333333"
                            radius: 2
                        }

                        //TODO пока что тип данных для паттерна скрыт, а соответственно, скрыты кнопки фильтрации по типу паттерна
                        //     а также убран отступ для панели с паттернами. После того, как фича будет реализована - достаточно убрать
                        //     эту переменную в местах, где она используется, вернув правильные значения
                        property bool patternTypesFeatureHidden: true

                        MfxButton
                        {
                            id: lingericButton
                            checkable: true
                            width: 72
                            height: 26
                            text: translationsManager.translationTrigger + qsTr("Lingeric")
                            textSize: 10

                            anchors.top: parent.top
                            anchors.left: parent.left

                            ButtonGroup.group: actionTypesGroup

                            visible: !actionViewWidget.patternTypesFeatureHidden

                            onClicked: {
                                patternManager.patternsFiltered.patternFilteringTypeChangeRequest(PatternType.Sequences)
                            }
                        }

                        MfxButton
                        {
                            id: dynamicButton
                            checkable: true
                            width: 72
                            height: 26
                            text: translationsManager.translationTrigger + qsTr("Dynamic")
                            textSize: 10

                            anchors.top: parent.top
                            anchors.left: lingericButton.right

                            ButtonGroup.group: actionTypesGroup

                            visible: !actionViewWidget.patternTypesFeatureHidden

                            onClicked: {
                                patternManager.patternsFiltered.patternFilteringTypeChangeRequest(PatternType.Dynamic)
                            }
                        }

                        MfxButton
                        {
                            id: staticButton
                            checkable: true
                            width: 72
                            height: 26
                            text: translationsManager.translationTrigger + qsTr("Static")
                            textSize: 10

                            anchors.top: parent.top
                            anchors.left: dynamicButton.right

                            ButtonGroup.group: actionTypesGroup

                            visible: !actionViewWidget.patternTypesFeatureHidden

                            onClicked: {
                                patternManager.patternsFiltered.patternFilteringTypeChangeRequest(PatternType.Static)
                            }
                        }

                        ButtonGroup
                        {
                            id: actionTypesGroup
                            checkedButton: lingericButton

                        }

                        Rectangle
                        {
                            id: actionViewBackground2
                            color: "#4f4f4f"
                            radius: 2

                            anchors.fill: parent
                            anchors.topMargin: !actionViewWidget.patternTypesFeatureHidden ? 24 : 0

                            Rectangle
                            {
                                id: actionViewBackground3
                                color: "black"

                                anchors.fill: parent
                                anchors.margins: 2
                            }

                            SplitView
                            {
                                property var selPattern: null

                                id: actionSplit
                                anchors.fill: parent
                                anchors.margins: 2
                                orientation: Qt.Vertical

                                handle: Rectangle
                                {
                                    implicitHeight: 4

                                    color: SplitHandle.pressed ? Qt.lighter("#6F6F6F", 1.5)
                                        : (SplitHandle.hovered ? Qt.lighter("#6F6F6F", 1.1) : "#6F6F6F")
                                }

                                states:
                                [
                                    State
                                    {
                                        name: "seq"; when: sequencesButton.checked
                                        PropertyChanges { target: actionStack; currentIndex: 0 }
                                        PropertyChanges { target: previewStack; currentIndex: 0 }
                                    },
                                    State
                                    {
                                        name: "shot"; when: shotButton.checked
                                        PropertyChanges { target: actionStack; currentIndex: 1 }
                                        PropertyChanges { target: previewStack; currentIndex: 1 }
                                    }
                                ]

                                StackLayout
                                {
                                    id: actionStack
                                    SplitView.fillHeight: true
                                    SplitView.fillWidth: true
                                    currentIndex: 0

                                    function changeAction( type, name )
                                    {
                                        console.log( "changeAction", type, name );
                                        patternManager.currentPatternChangeRequest( type, name )
                                        let checkedPatches = project.checkedPatchesList()
                                
                                        checkedPatches.forEach( function( patchId )
                                        {
                                            if( project.patchType( patchId ) == type )
                                                project.setPatchProperty( patchId, "act", name );
                                        })

                                        let selectedCue = cueContentManager.onGetSelectedDeviseList();
                                        selectedCue.forEach( function( idDevice )
                                        {
                                            project.changeAction( cueName, idDevice, name )
                                        })

                                        cueContentManager.onSelectedChangeAction( name )
                                    }

                                    GridView
                                    {
                                        id: actionView
                                        interactive: true;//!held
                                        onFlickStarted: { applicationWindow.isMouseCursorVisible = true}
                                        onMovementStarted: { applicationWindow.isMouseCursorVisible = true}
                                        onMovementEnded: {/*console.log("movement");*/applicationWindow.isMouseCursorVisible = true}
                                        onFlickEnded: {/*console.log("flickEnded");*/applicationWindow.isMouseCursorVisible = true}
                                        property bool held: false
                                        clip: true

                                        cellWidth: 60
                                        cellHeight: 52

                                        ScrollBar.vertical: ScrollBar {policy: ScrollBar.AlwaysOn}

                                        model: patternManager.patternsFiltered
                                        property var pressedItem: null

                                        delegate: Item
                                        {
                                            id: actionPlate

                                            property bool isActionPlate: true
                                            property string name: model.name
                                            property var type: model.type
                                            property bool checked: name === patternManager.selectedPatternName
                                
                                            width: actionView.cellWidth
                                            height: actionView.cellHeight
                                            Drag.active: actionView.held
                                            Drag.source: actionView.pressedItem
                                            Drag.hotSpot.x: this.width / 2
                                            Drag.hotSpot.y: this.height / 2
                                            states:
                                            [
                                                State
                                                {
                                                    name: "inDrag"
                                                    when: actionPlate.checked && actionView.held
                                                    PropertyChanges { target: actionView.pressedItem; parent: mainScreen }
                                                    PropertyChanges { target: actionView.pressedItem; anchors.centerIn: undefined }
                                                    PropertyChanges { target: actionView.pressedItem; x: coords.currentMouseX }
                                                    PropertyChanges { target: actionView.pressedItem; y: coords.currentMouseY }
                                                }
                                            ]
                                
                                            Item
                                            {
                                
                                                anchors.fill: parent
                                
                                                Rectangle
                                                {
                                                    width: actionView.cellWidth - 4
                                                    height: actionView.cellHeight - 4
                                                    id: actionPlateBackground
                                                    anchors.centerIn: parent
                                                    color: "#666666"
                                                    radius: 2
                                
                                                    Rectangle
                                                    {
                                                        color: "black"
                                                        radius: 2
                                
                                                        anchors.topMargin: 2
                                                        anchors.bottomMargin: 13
                                                        anchors.leftMargin: 2
                                                        anchors.rightMargin: 2
                                                        anchors.fill: parent
                                
                                                        Image
                                                        {
                                                            source: "qrc:/imagePlaceholder"
                                                            anchors.centerIn: parent
                                                        }
                                                    }
                                
                                                    Text
                                                    {
                                                        id: actionPlateName
                                                        text: actionPlate.name
                                
                                                        horizontalAlignment: Text.AlignHCenter
                                                        verticalAlignment: Text.AlignVCenter
                                                        elide: Text.ElideMiddle
                                                        color: "#ffffff"
                                                        font.family: Fonts.robotoRegular.name
                                                        font.pixelSize: 10
                                
                                                        anchors.bottom: parent.bottom
                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                    }
                                                }
                                
                                                Rectangle
                                                {
                                                    width: actionView.cellWidth - 4
                                                    height: actionView.cellHeight - 4
                                                    id: actionPlateBorder
                                                    anchors.centerIn: parent
                                                    color: "transparent"
                                                    radius: 2
                                
                                                    border.width: 2
                                                    border.color: "#27AE60"
                                
                                                    visible: actionPlate.checked
                                                }
                                            }
                                
                                            MfxMouseArea
                                            {
                                                id:coords
                                                anchors.fill: parent
                                                property bool wasDragged: false
                                                property int currentMouseX
                                                property int currentMouseY
                                                allwaysHide: true
                                
                                                onPositionChanged:
                                                {
                                
                                                    if(Math.abs(dx) > 5)
                                                    {
                                                        if(!actionView.held)
                                                        {
                                                            if(actionPlate.checked)
                                                                patternManager.cleanPatternSelectionRequest()
                                
                                                            console.log(actionPlate.name, type)
                                                            patternManager.currentPatternChangeRequest( actionPlate.type, actionPlate.name )
                                                            cueContentManager.onSelectedChangeAction( actionPlate.name )
                                                            actionView.pressedItem = actionPlate
                                                            if(actionView.pressedItem)
                                                            {
                                                                actionView.draggedItemIndex = index;
                                                                currentMouseX = mainScreen.mapFromItem(coords, 0, 0).x;
                                                                currentMouseY = mainScreen.mapFromItem(coords, 0, 0).y
                                                                actionView.held = true
                                                            }
                                                        }
                                                    }
                                                }
                                
                                                onClicked:
                                                {
                                                    if(actionPlate.checked)
                                                    {
                                                        patternManager.cleanPatternSelectionRequest( actionPlate.type )
                                                    }
                                                    else
                                                    {
                                                        deviceManager.runPreviewPattern( actionPlate.name )
                                
                                                        //TODO if(patchPanelFocused) {
                                                        currentMouseX = mainScreen.mapFromItem(coords, 0, 0).x;
                                                        currentMouseY = mainScreen.mapFromItem(coords, 0, 0).y

                                                        actionStack.changeAction( actionPlate.type, actionPlate.name )
                                                        //TODO }
                                                    }
                                                }
                                
                                                drag.target: actionView.held ? actionView.pressedItem : undefined
                                                drag.axis: Drag.XAndYAxis
                                                drag.minimumX: 0
                                                drag.maximumX: mainScreen.width - actionView.cellWidth
                                                drag.minimumY: 0
                                                drag.maximumY: mainScreen.height - actionView.cellHeight
                                
                                                onReleased:
                                                {
                                                    if(drag.target)
                                                    {
                                                        drag.target.Drag.drop()
                                                        if (actionView.draggedItemIndex !== -1)
                                                        {
                                                            var draggedIndex = actionView.draggedItemIndex
                                                            actionView.draggedItemIndex = -1
                                                        }
                                                    }
                                                    actionView.held = false;
                                                }
                                
                                                onPressed:
                                                {
                                                    if(actionPlate.checked)
                                                    {
                                                        actionView.pressedItem = actionPlate
                                                        actionView.draggedItemIndex = index;
                                                        actionView.held = true

                                                        currentMouseX = mainScreen.mapFromItem(coords, 0, 0).x;
                                                        currentMouseY = mainScreen.mapFromItem(coords, 0, 0).y
                                                    }
                                                }
                                            }
                                        }
                            
                                        Item
                                        {
                                            id: topShotShadow
                                            height: 20
                                            width: parent.width
                                            anchors.left: parent.left
                                            anchors.top: parent.top

                                            visible: actionView.contentY > 0

                                            LinearGradient
                                            {
                                                anchors.fill: parent
                                                start: Qt.point(0, 0)
                                                end: Qt.point(0, parent.height)
                                                gradient: Gradient
                                                {
                                                    GradientStop { position: 1.0; color: "#00000000" }
                                                    GradientStop { position: 0.0; color: "#FF000000" }
                                                }
                                            }
                                        }

                                        Item
                                        {
                                            id: bottomShotShadow
                                            height: 20
                                            width: parent.width
                                            anchors.left: parent.left
                                            anchors.bottom: parent.bottom

                                            LinearGradient
                                            {
                                                anchors.fill: parent
                                                start: Qt.point(0, parent.height)
                                                end: Qt.point(0, 0)
                                                gradient: Gradient
                                                {
                                                    GradientStop { position: 1.0; color: "#00000000" }
                                                    GradientStop { position: 0.0; color: "#FF000000" }
                                                }
                                            }
                                        }
                                        property int draggedItemIndex: -1

                                        Item
                                        {
                                            id: dndShotContainer
                                            anchors.fill: parent
                                        }
                                    }

                                    ColumnLayout
                                    {
                                        GridView
                                        {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true

                                            id: actionShotView
                                            interactive: true;//!held
                                            onFlickStarted: { applicationWindow.isMouseCursorVisible = true}
                                            onMovementStarted: { applicationWindow.isMouseCursorVisible = true}
                                            onMovementEnded: {/*console.log("movement");*/applicationWindow.isMouseCursorVisible = true}
                                            onFlickEnded: {/*console.log("flickEnded");*/applicationWindow.isMouseCursorVisible = true}
                                            property bool held: false
                                            clip: true

                                            cellWidth: 60
                                            cellHeight: 52

                                            ScrollBar.vertical: ScrollBar {policy: ScrollBar.AlwaysOn}

                                            model: patternManager.patternsShotFiltered
                                            property var pressedItem: null

                                            delegate: Item
                                            {
                                                id: actionShotPlate

                                                property bool isActionPlate: true
                                                property string name: model.name
                                                property var type: model.type
                                                property var prefireDuration: model.prefireDuration
                                                property var shotTime: model.getProperties["shotTime"]
                                                property bool checked: name === patternManager.selectedShotPatternName
                                
                                                width: actionShotView.cellWidth
                                                height: actionShotView.cellHeight
                                                Drag.active: actionShotView.held
                                                Drag.source: actionShotView.pressedItem
                                                Drag.hotSpot.x: this.width / 2
                                                Drag.hotSpot.y: this.height / 2
                                
                                                states:
                                                [
                                                    State
                                                    {
                                                        name: "inDrag"
                                                        when: actionShotPlate.checked && actionShotView.held
                                                        PropertyChanges { target: actionShotView.pressedItem; parent: mainScreen }
                                                        PropertyChanges { target: actionShotView.pressedItem; anchors.centerIn: undefined }
                                                        PropertyChanges { target: actionShotView.pressedItem; x: coordsShot.currentMouseX }
                                                        PropertyChanges { target: actionShotView.pressedItem; y: coordsShot.currentMouseY }
                                                    }
                                                ]
                                
                                                Item
                                                {
                                                    anchors.fill: parent
                                
                                                    Rectangle
                                                    {
                                                        width: actionShotView.cellWidth - 4
                                                        height: actionShotView.cellHeight - 4
                                                        id: actionShotPlateBackground
                                                        anchors.centerIn: parent
                                                        color: "#666666"
                                                        radius: 2
                                
                                                        Rectangle
                                                        {
                                                            color: "black"
                                                            radius: 2
                                
                                                            anchors.topMargin: 2
                                                            anchors.bottomMargin: 13
                                                            anchors.leftMargin: 2
                                                            anchors.rightMargin: 2
                                                            anchors.fill: parent
                                
                                                            Image
                                                            {
                                                                source: "qrc:/imagePlaceholder"
                                                                anchors.centerIn: parent
                                                            }
                                                        }
                                
                                                        Text
                                                        {
                                                            text: actionShotPlate.name
                                
                                                            horizontalAlignment: Text.AlignHCenter
                                                            verticalAlignment: Text.AlignVCenter
                                                            elide: Text.ElideMiddle
                                                            color: "#ffffff"
                                                            font.family: Fonts.robotoRegular.name
                                                            font.pixelSize: 10
                                
                                                            anchors.bottom: parent.bottom
                                                            anchors.horizontalCenter: parent.horizontalCenter
                                                        }
                                                    }
                                
                                                    Rectangle
                                                    {
                                                        width: actionShotView.cellWidth - 4
                                                        height: actionShotView.cellHeight - 4
                                                        anchors.centerIn: parent
                                                        color: "transparent"
                                                        radius: 2
                                
                                                        border.width: 2
                                                        border.color: "#27AE60"
                                
                                                        visible: actionShotPlate.checked
                                                    }
                                                }
                                
                                                MfxMouseArea
                                                {
                                                    id: coordsShot
                                                    anchors.fill: parent
                                                    property bool wasDragged: false
                                                    property int currentMouseX
                                                    property int currentMouseY
                                                    allwaysHide: true
                                
                                                    onPositionChanged:
                                                    {
                                
                                                        if(Math.abs(dx) > 5)
                                                        {
                                                            if(!actionShotView.held)
                                                            {
                                                                if(actionShotPlate.checked)
                                                                    patternManager.cleanShotPatternSelectionRequest( actionShotPlate.type )
                                
                                                                patternManager.currentPatternChangeRequest( actionShotPlate.type, actionShotPlate.name )
                                                                cueContentManager.onSelectedChangeAction( actionShotPlate.name )

                                                                actionShotView.pressedItem = actionShotPlate
                                                                actionShotView.draggedItemIndex = index;
                                                                actionShotView.held = true

                                                                currentMouseX = mainScreen.mapFromItem(coordsShot, 0, 0).x;
                                                                currentMouseY = mainScreen.mapFromItem(coordsShot, 0, 0).y
                                                            }
                                                        }
                                                    }
                                
                                                    onClicked:
                                                    {
                                                        if(actionShotPlate.checked)
                                                        {
                                                            patternManager.cleanPatternSelectionRequest( actionShotPlate.type )
                                                            actionSplit.selPattern = null
                                                        }
                                                        else
                                                        {
                                                            //deviceManager.runPreviewPattern( actionShotPlate.name )
                                
                                                            //TODO if(patchPanelFocused) {
                                                            currentMouseX = mainScreen.mapFromItem(coordsShot, 0, 0).x;
                                                            currentMouseY = mainScreen.mapFromItem(coordsShot, 0, 0).y

                                                            actionStack.changeAction( actionShotPlate.type, actionShotPlate.name )
                                                            //TODO }
                                                            actionSplit.selPattern = actionShotPlate
                                                        }
                                                    }

                                                    onDoubleClicked:
                                                    {
                                                        currentMouseX = mainScreen.mapFromItem(coordsShot, 0, 0).x;
                                                        currentMouseY = mainScreen.mapFromItem(coordsShot, 0, 0).y

                                                        actionStack.changeAction( actionShotPlate.type, actionShotPlate.name )
                                                        actionSplit.selPattern = actionShotPlate

                                                        var addWindow = Qt.createComponent( "AddShotPattern.qml" ).createObject( applicationWindow, {isEditMode: true} );
                                                        addWindow.x = applicationWindow.width / 2 - addWindow.width / 2
                                                        addWindow.y = applicationWindow.height / 2 - addWindow.height / 2
                                                    }
                                
                                                    drag.target: actionShotView.held ? actionShotView.pressedItem : undefined
                                                    drag.axis: Drag.XAndYAxis
                                                    drag.minimumX: 0
                                                    drag.maximumX: mainScreen.width - actionShotView.cellWidth
                                                    drag.minimumY: 0
                                                    drag.maximumY: mainScreen.height - actionShotView.cellHeight
                                
                                                    onReleased:
                                                    {
                                                        if(drag.target)
                                                        {
                                                            drag.target.Drag.drop()
                                                            if (actionShotView.draggedItemIndex !== -1)
                                                            {
                                                                var draggedIndex = actionView.draggedItemIndex
                                                                actionShotView.draggedItemIndex = -1
                                                            }
                                                        }
                                                        actionShotView.held = false;
                                                    }
                                
                                                    onPressed:
                                                    {
                                                        if(actionShotPlate.checked)
                                                        {
                                                            actionShotView.pressedItem = actionShotPlate
                                                            actionShotView.draggedItemIndex = index;
                                                            actionShotView.held = true

                                                            currentMouseX = mainScreen.mapFromItem(coordsShot, 0, 0).x;
                                                            currentMouseY = mainScreen.mapFromItem(coordsShot, 0, 0).y
                                                        }
                                                    }
                                                }
                                            }

                                            Item
                                            {
                                                id: topShadow
                                                height: 20
                                                width: parent.width
                                                anchors.left: parent.left
                                                anchors.top: parent.top

                                                visible: actionShotView.contentY > 0

                                                LinearGradient
                                                {
                                                    anchors.fill: parent
                                                    start: Qt.point(0, 0)
                                                    end: Qt.point(0, parent.height)
                                                    gradient: Gradient
                                                    {
                                                        GradientStop { position: 1.0; color: "#00000000" }
                                                        GradientStop { position: 0.0; color: "#FF000000" }
                                                    }
                                                }
                                            }

                                            Item
                                            {
                                                id: bottomShadow
                                                height: 20
                                                width: parent.width
                                                anchors.left: parent.left
                                                anchors.bottom: parent.bottom

                                                LinearGradient
                                                {
                                                    anchors.fill: parent
                                                    start: Qt.point(0, parent.height)
                                                    end: Qt.point(0, 0)
                                                    gradient: Gradient
                                                    {
                                                        GradientStop { position: 1.0; color: "#00000000" }
                                                        GradientStop { position: 0.0; color: "#FF000000" }
                                                    }
                                                }
                                            }

                                            property int draggedItemIndex: -1

                                            Item
                                            {
                                                id: dndContainer
                                                anchors.fill: parent
                                            }
                                        }

                                        RowLayout
                                        {
                                            Layout.leftMargin: 4
                                            Layout.rightMargin: 4
                                            Layout.bottomMargin: 2
    
                                            MfxHilightedButton
                                            {
                                                Layout.fillWidth: true
    
                                                id: addShotPattern
                                                text: translationsManager.translationTrigger + qsTr( "Add" )
                                                color: "#2F80ED"
    
                                                onClicked:
                                                {
                                                    var addWindow = Qt.createComponent( "AddShotPattern.qml" ).createObject( applicationWindow );
                                                    addWindow.x = applicationWindow.width / 2 - addWindow.width / 2
                                                    addWindow.y = applicationWindow.height / 2 - addWindow.height / 2
                                                }
                                            }
    
                                            MfxHilightedButton
                                            {
                                                Layout.fillWidth: true
    
                                                id: editShotPattern
                                                text: translationsManager.translationTrigger + qsTr( "Edit" )
                                                color: "#2F80ED"
    
                                                onClicked:
                                                {
                                                    if( patternManager.selectedShotPatternName === "" )
                                                        return
    
                                                    var addWindow = Qt.createComponent( "AddShotPattern.qml" ).createObject( applicationWindow, {isEditMode: true} );
                                                    addWindow.x = applicationWindow.width / 2 - addWindow.width / 2
                                                    addWindow.y = applicationWindow.height / 2 - addWindow.height / 2
                                                }
                                            }
    
                                            MfxHilightedButton
                                            {
                                                Layout.fillWidth: true
    
                                                id: delShotPattern
                                                text: translationsManager.translationTrigger + qsTr( "Delele" )
                                                color: "#EB5757"
    
                                                onClicked:
                                                {
                                                    if( patternManager.selectedShotPatternName === "" )
                                                        return
    
                                                    patternManager.deletePattern( patternManager.selectedShotPatternName );
                                                    patternManager.cleanPatternSelectionRequest( PatternType.Shot );
                                                }
                                            }
                                        }
                                    }
                                }
    
                                StackLayout
                                {
                                    id: previewStack
                                    SplitView.preferredHeight: 120
                                    SplitView.maximumHeight: 200
                                    SplitView.minimumHeight: 100
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    currentIndex: 0
    
                                    Rectangle
                                    {
                                        id: previewWidget
                                        color: "black"
                                        clip: true
    
                                        PreviewIcon
                                        {
                                            id: previewIcon
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 20
                                        }
                                    }
    
                                    Rectangle
                                    {
                                        id: previewShotWidget
                                        color: "black"
                                        clip: true
    
                                        function formatTimeMs( time_ms )
                                        {
                                            const min = Math.floor( time_ms / 60000 )
                                            const sec = Math.floor( (time_ms % 60000) / 1000 )
                                            const msec = time_ms % 1000
    
                                            return "%1:%2.%3".arg( String( min ).padStart( 2, '0' ) ).arg( String( sec ).padStart( 2, '0' ) ).arg( String( msec ).padStart( 3, '0' ) )
                                        }
    
                                        ColumnLayout
                                        {
                                            anchors.fill: parent
                                            anchors.leftMargin: 4
    
                                            Item
                                            {
                                                Layout.fillHeight: true
                                            }
    
                                            RowLayout
                                            {
                                                Text
                                                {
                                                    verticalAlignment: Text.AlignVCenter
    
                                                    font.family: Fonts.robotoRegular.name
                                                    font.pixelSize: 12
    
                                                    color: "white"
                                                    text: "Prefire: "
                                                }
    
                                                Text
                                                {
                                                    verticalAlignment: Text.AlignVCenter
    
                                                    font.family: Fonts.robotoRegular.name
                                                    font.pixelSize: 12
    
                                                    color: "white"
                                                    text: actionSplit.selPattern ? previewShotWidget.formatTimeMs( actionSplit.selPattern.prefireDuration ) : ""
                                                }
                                            }
    
                                            RowLayout
                                            {
                                                Text
                                                {
                                                    verticalAlignment: Text.AlignVCenter
    
                                                    font.family: Fonts.robotoRegular.name
                                                    font.pixelSize: 12
    
                                                    color: "white"
                                                    text: "Time: "
                                                }
    
                                                Text
                                                {
                                                    verticalAlignment: Text.AlignVCenter
    
                                                    font.family: Fonts.robotoRegular.name
                                                    font.pixelSize: 12
    
                                                    color: "white"
                                                    text: actionSplit.selPattern ? previewShotWidget.formatTimeMs( actionSplit.selPattern.shotTime ) : ""
                                                }
                                            }
    
                                            Item
                                            {
                                                Layout.fillHeight: true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } // right panel
        }

        Item
        {
            SplitView.fillHeight: true
            SplitView.fillWidth: true
            SplitView.preferredHeight: playerWidget.minHeight
            SplitView.minimumHeight: playerWidget.minHeight
            SplitView.maximumHeight: playerWidget.maxHeight

            Player
            {
                id: playerWidget
                anchors.fill: parent
            }
        }
    }
}
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0

import "qrc:/"

Item
{
    id: mainScreen

    property var sceneWidget: null
    property alias playerWidget: playerWidget

    function setupSceneWidget(widget)
    {
        sceneWidget = widget

        if(!sceneWidget)
            return

        sceneWidget.parent = leftPanel
        sceneWidget.anchors.fill = leftPanel
        sceneWidget.visible = visualizationButton.checked
    }

    Item
    {
        id: leftPanel
//        width: parent.width * 0.67
        anchors.margins: 2
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: rightPanel.left
        anchors.bottom: playerWidget.top

        MfxButton
        {
            id: visualizationButton
            checkable: true
            width: 100
            z: 1
            text: qsTr("Visualization")

            anchors.topMargin: 6
            anchors.leftMargin: 6
            anchors.top: parent.top
            anchors.left: parent.left

            onCheckedChanged:
            {
                if(sceneWidget)
                    checked ? sceneWidget.visible = true : sceneWidget.visible = false
            }

            ButtonGroup.group: leftButtonsGroup
        }

        MfxButton
        {
            id: cueListButton
            checkable: true
            width: 100
            z: 1
            text: qsTr("Cue List")

            anchors.topMargin: 6
            anchors.leftMargin: 2
            anchors.top: parent.top
            anchors.left: visualizationButton.right

            ButtonGroup.group: leftButtonsGroup
        }

        MfxButton
        {
            id: deviceListButton1
            checkable: true
            width: 100
            z: 1
            text: qsTr("Device List")

            anchors.topMargin: 6
            anchors.leftMargin: 2
            anchors.top: parent.top
            anchors.left: cueListButton.right

            ButtonGroup.group: leftButtonsGroup
        }

        ButtonGroup
        {
            id: leftButtonsGroup
            checkedButton: visualizationButton

        }

        MfxButton
        {
            id: cueContentButton
            checkable: true
            width: 100
            z: 1
            text: qsTr("Cue Content")

            anchors.topMargin: 6
            anchors.rightMargin: 2
            anchors.top: parent.top
            anchors.right: deviceListButton2.left
        }

        MfxButton
        {
            id: deviceListButton2
            checkable: true
            width: 100
            z: 1
            text: qsTr("Device List")

            anchors.topMargin: 6
            anchors.rightMargin: 6
            anchors.top: parent.top
            anchors.right: parent.right
        }
    }

//    MfxMouseArea
//    {
//        id: panelsResizeArea
//        width: 4
//        anchors.top: parent.top
//        anchors.bottom: playerWidget.top
//        anchors.left: leftPanel.right

//        property int previousX

//        cursor: Qt.SizeHorCursor

//        onPressed:
//        {
//            previousX = mouseX
//        }

//        onMouseXChanged:
//        {
//            var dx = mouseX - previousX

//            leftPanel.width += dx
//        }
//    }

    Item
    {
        id: rightPanel

        width: 372
        anchors.top: parent.top
        anchors.bottomMargin: 2
        anchors.bottom: playerWidget.top
        anchors.right: parent.right

        Rectangle
        {
            id: rightPanelBackground
            anchors.fill: parent
            color: "#222222"
        }

        MfxButton
        {
            id: sequencesButton
            checkable: true
            width: 68
            text: qsTr("Sequences")
            textSize: 10

            anchors.top: parent.top
            anchors.left: parent.left

            ButtonGroup.group: rightButtonsGroup
        }

        MfxButton
        {
            id: dimmerButton
            checkable: true
            width: 68
            text: qsTr("Dimmer")
            textSize: 10

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: sequencesButton.right

            ButtonGroup.group: rightButtonsGroup
        }

        MfxButton
        {
            id: shotButton
            checkable: true
            width: 68
            text: qsTr("Shot")
            textSize: 10

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: dimmerButton.right

            ButtonGroup.group: rightButtonsGroup
        }

        MfxButton
        {
            id: pyroButton
            checkable: true
            width: 68
            text: qsTr("Pyro")
            textSize: 10

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: shotButton.right

            ButtonGroup.group: rightButtonsGroup
        }

        MfxButton
        {
            id: cueButton
            checkable: true
            width: 60
            text: qsTr("Cue")
            textSize: 10

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: pyroButton.right

            ButtonGroup.group: rightButtonsGroup
        }

        ButtonGroup
        {
            id: rightButtonsGroup
            checkedButton: sequencesButton

        }

        MfxButton
        {
            id: addButton
            text: qsTr("+")

            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.left: cueButton.right
            anchors.right: parent.right

        }

        Item
        {
            id: actionViewWidget

            anchors.topMargin: 2
            anchors.top: sequencesButton.bottom
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


            MfxButton
            {
                id: lingericButton
                checkable: true
                width: 72
                height: 26
                text: qsTr("Lingeric")
                textSize: 10

                anchors.top: parent.top
                anchors.left: parent.left

                ButtonGroup.group: actionTypesGroup
            }

            MfxButton
            {
                id: dynamicButton
                checkable: true
                width: 72
                height: 26
                text: qsTr("Dynamic")
                textSize: 10

                anchors.top: parent.top
                anchors.left: lingericButton.right

                ButtonGroup.group: actionTypesGroup
            }

            MfxButton
            {
                id: staticButton
                checkable: true
                width: 72
                height: 26
                text: qsTr("Static")
                textSize: 10

                anchors.top: parent.top
                anchors.left: dynamicButton.right

                ButtonGroup.group: actionTypesGroup
            }

            ButtonGroup
            {
                id: actionTypesGroup
                checkedButton: lingericButton

            }

            Rectangle
            {
                id: actionViewBackground2
                anchors.fill: parent
                color: "#4f4f4f"
                radius: 2

                anchors.topMargin: 24
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                Rectangle
                {
                    id: actionViewBackground3
                    color: "black"

                    anchors.margins: 2
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }

                GridView
                {
                    id: actionView

                    anchors.margins: 2
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    clip: true

                    cellWidth: 60
                    cellHeight: 52

                    model: ListModel
                    {
                        id: actionListModel
                    }

                    delegate: Component
                    {
                        Item
                        {
                            id: actionPlate
                            width: actionView.cellWidth
                            height: actionView.cellHeight

                            property string name: actionName

                            Rectangle
                            {
                                width: actionView.cellWidth - 4
                                height: actionView.cellHeight - 4
                                id: actionPlateBAckground
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
                                    font.family: "Roboto"
                                    font.pixelSize: 10

                                    anchors.bottom: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {policy: ScrollBar.AlwaysOn}

                    Item
                    {
                        id: topShadow
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

                    Component.onCompleted:
                    {
                        for (let i = 1; i < 81; i++)
                        {
                            actionListModel.insert(i - 1, {actionName: "name" + i})
                        }
                    }
                }
            }
        }
    }

    Player
    {
        id: playerWidget
        height: minHeight
        anchors.margins: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}

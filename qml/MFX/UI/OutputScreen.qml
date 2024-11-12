import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI.Components.Templates 1.0 as MFXUICT
import MFX.UI.Components.Basic 1.0
import MFX.UI.Styles 1.0 as MFXUIS

//NOTE I do not use components or any modular structures here since we need the MVP as fast as possible
Item
{
    id: outputScreen

    //TODO тип элемента облачной файловой системы для правой панели. Перенести в C++ часть
    enum CloudFSItemType {
        Folder,
        File
    }

    // TODO тип экшена для создаваемого лейера. Перенести в C++ часть
    enum LayerActionType {
        Shot,
        Hold
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 2

        spacing: 2

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            spacing: 2

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 108
                Layout.maximumHeight: 108
                Layout.minimumHeight: 108

                radius: 2

                color: "#444444"

                RowLayout {
                    anchors.fill: parent

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 7
                            anchors.bottomMargin: 8

                            spacing: 0

                            Text {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 28
                                Layout.maximumHeight: 28
                                Layout.minimumHeight: 28

                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter

                                lineHeightMode: Text.FixedHeight
                                lineHeight: 12

                                elide: Text.ElideRight

                                font.family: MFXUIS.Fonts.robotoMedium.name
                                font.pixelSize: 12

                                color: "#FFFFFF"

                                text: translationsManager.translationTrigger + qsTr("Project: ") + project.property("projectName")
                            }

                            MFXUICT.LayoutSpacer {
                                fixedHeight: 2
                            }

                            Text {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 20
                                Layout.maximumHeight: 20
                                Layout.minimumHeight: 20

                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter

                                lineHeightMode: Text.FixedHeight
                                lineHeight: 10

                                elide: Text.ElideRight

                                font.family: MFXUIS.Fonts.robotoRegular.name
                                font.pixelSize: 12

                                color: "#FFFFFF"

                                text: translationsManager.translationTrigger + qsTr("Total time: ") + project.currentProjectAudioTrackDuration
                            }

                            MFXUICT.LayoutSpacer {
                                fixedHeight: 2
                            }

                            Text {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 20
                                Layout.maximumHeight: 20
                                Layout.minimumHeight: 20

                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter

                                lineHeightMode: Text.FixedHeight
                                lineHeight: 10

                                elide: Text.ElideRight

                                font.family: MFXUIS.Fonts.robotoRegular.name
                                font.pixelSize: 12

                                color: "#FFFFFF"

                                text: translationsManager.translationTrigger + qsTr("Track: ") + project.currentProjectAudioTrack
                            }

                            MFXUICT.LayoutSpacer { }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 24
                                Layout.maximumHeight: 24
                                Layout.minimumHeight: 24

                                spacing: 8

                                Item {
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 120
                                    Layout.maximumWidth: 120
                                    Layout.minimumWidth: 120

                                    MfxButton {
                                        anchors.fill: parent

                                        checkable: false

                                        font.family: MFXUIS.Fonts.robotoMedium.name
                                        textSize: 8
                                        color: "#2F80ED"
                                        pressedColor: "#649ce8"
                                        enableShadow: true

                                        text: translationsManager.translationTrigger + qsTr("Save Audio as")

                                        onClicked:
                                        {
                                             project.exportOutputJson(true);
                                        }
                                    }
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 120
                                    Layout.maximumWidth: 120
                                    Layout.minimumWidth: 120

                                    MfxButton {
                                        anchors.fill: parent

                                        checkable: false

                                        font.family: MFXUIS.Fonts.robotoMedium.name
                                        textSize: 8
                                        color: "#2F80ED"
                                        pressedColor: "#649ce8"
                                        enableShadow: true

                                        text: translationsManager.translationTrigger + qsTr("Mount device list")

                                        onClicked: {

                                        }
                                    }
                                }

                                MFXUICT.LayoutSpacer { }
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 108
                        Layout.maximumWidth: 108
                        Layout.minimumWidth: 108

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4

                            radius: 2

                            color: "#222222"

                            Item {
                                anchors.centerIn: parent

                                width: 64
                                height: 64

                                //TODO восстановить, когда будет готова модель
                                //visible: project.currentProjectFile.lenth > 0

                                MFXUICT.ColoredIcon {
                                    anchors.top: parent.top
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    width: 38
                                    height: 48

                                    source: "qrc:/icons/output_screen/output_screen_file_icon.svg"
                                }

                                Text {
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right

                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignBottom

                                    lineHeightMode: Text.FixedHeight
                                    lineHeight: 12

                                    font.family: MFXUIS.Fonts.robotoRegular.name
                                    font.pixelSize: 10

                                    color: "#FFFFFF"

                                    text: project.currentProjectFile
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true

                radius: 2

                color: "#333333"

                ColumnLayout {
                    anchors.fill: parent

                    spacing: 0

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 24
                        Layout.maximumHeight: 24
                        Layout.minimumHeight: 24

                        ButtonGroup {
                            id: deviceTypeSelectionTabBarButtonGroup

                            exclusive: true
                        }

                        RowLayout {
                            anchors.fill: parent

                            spacing: 0

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Button {
                                    id: deviceTypeSequencesButton

                                    anchors.fill: parent

                                    checkable: true

                                    checked: true

                                    background: MFXUICT.RoundedRectangleShape {
                                        anchors.rightMargin: visible ? -1 : 0

                                        topLeftRadius: 2
                                        topRightRadius: 2

                                        fillColor: "#444444"
                                        borderColor: "#444444"

                                        visible: deviceTypeSequencesButton.checked
                                    }

                                    contentItem: Text {
                                        anchors.fill: parent

                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: 12

                                        font.family: deviceTypeSequencesButton.checked ? MFXUIS.Fonts.robotoMedium.name
                                                                                       : MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 10

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        color: deviceTypeSequencesButton.checked ? "#FFFFFF"
                                                                                 : "#80FFFFFF"

                                        text: deviceTypeSequencesButton.text
                                    }

                                    text: translationsManager.translationTrigger + qsTr("Sequences")

                                    ButtonGroup.group: deviceTypeSelectionTabBarButtonGroup
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.preferredWidth: 1
                                Layout.maximumWidth: 1
                                Layout.minimumWidth: 1

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.topMargin: 2
                                    anchors.bottomMargin: 2

                                    color: "#222222"

                                    radius: 1

                                    visible: !deviceTypeDimmerButton.checked && !deviceTypeSequencesButton.checked
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Button {
                                    id: deviceTypeDimmerButton

                                    anchors.fill: parent

                                    checkable: true

                                    background: MFXUICT.RoundedRectangleShape {
                                        anchors.leftMargin: visible ? -1 : 0
                                        anchors.rightMargin: visible ? -1 : 0

                                        topLeftRadius: 2
                                        topRightRadius: 2

                                        fillColor: "#444444"
                                        borderColor: "#444444"

                                        visible: deviceTypeDimmerButton.checked
                                    }

                                    contentItem: Text {
                                        anchors.fill: parent

                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: 12

                                        font.family: deviceTypeDimmerButton.checked ? MFXUIS.Fonts.robotoMedium.name
                                                                                    : MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 10

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        color: deviceTypeDimmerButton.checked ? "#FFFFFF"
                                                                              : "#80FFFFFF"

                                        text: deviceTypeDimmerButton.text
                                    }

                                    text: translationsManager.translationTrigger + qsTr("Dimmer")

                                    ButtonGroup.group: deviceTypeSelectionTabBarButtonGroup
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.preferredWidth: 1
                                Layout.maximumWidth: 1
                                Layout.minimumWidth: 1

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.topMargin: 2
                                    anchors.bottomMargin: 2

                                    color: "#222222"

                                    radius: 1

                                    visible: !deviceTypeShotButton.checked && !deviceTypeDimmerButton.checked
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Button {
                                    id: deviceTypeShotButton

                                    anchors.fill: parent

                                    checkable: true

                                    background: MFXUICT.RoundedRectangleShape {
                                        anchors.leftMargin: visible ? -1 : 0
                                        anchors.rightMargin: visible ? -1 : 0

                                        topLeftRadius: 2
                                        topRightRadius: 2

                                        fillColor: "#444444"
                                        borderColor: "#444444"

                                        visible: deviceTypeShotButton.checked
                                    }

                                    contentItem: Text {
                                        anchors.fill: parent

                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: 12

                                        font.family: deviceTypeShotButton.checked ? MFXUIS.Fonts.robotoMedium.name
                                                                                  : MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 10

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        color: deviceTypeShotButton.checked ? "#FFFFFF"
                                                                            : "#80FFFFFF"

                                        text: deviceTypeShotButton.text
                                    }

                                    text: translationsManager.translationTrigger + qsTr("Shot")

                                    ButtonGroup.group: deviceTypeSelectionTabBarButtonGroup
                                }

                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.preferredWidth: 1
                                Layout.maximumWidth: 1
                                Layout.minimumWidth: 1

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.topMargin: 2
                                    anchors.bottomMargin: 2

                                    color: "#222222"

                                    radius: 1

                                    visible: !deviceTypePyroButton.checked && !deviceTypeShotButton.checked
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Button {
                                    id: deviceTypePyroButton

                                    anchors.fill: parent

                                    checkable: true

                                    background: MFXUICT.RoundedRectangleShape {
                                        anchors.leftMargin: visible ? -1 : 0

                                        topLeftRadius: 2
                                        topRightRadius: 2

                                        fillColor: "#444444"
                                        borderColor: "#444444"

                                        visible: deviceTypePyroButton.checked
                                    }

                                    contentItem: Text {
                                        anchors.fill: parent

                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: 12

                                        font.family: deviceTypePyroButton.checked ? MFXUIS.Fonts.robotoMedium.name
                                                                                  : MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 10

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        color: deviceTypePyroButton.checked ? "#FFFFFF"
                                                                            : "#80FFFFFF"

                                        text: deviceTypePyroButton.text
                                    }

                                    text: translationsManager.translationTrigger + qsTr("Pyro")

                                    ButtonGroup.group: deviceTypeSelectionTabBarButtonGroup
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 2

                            radius: 2

                            color: "#000000"

                            GridView {
                                anchors.fill: parent
                                anchors.margins: 8

                                //TODOMODEL добавить sequences model, тип получаемых данных брать относительно нажатой
                                model: ListModel {
                                    Component.onCompleted: {
                                        for(var i = 0; i < 10; i++) {
                                            append({"name":"Name"})
                                        }
                                    }
                                }

                                ScrollBar.vertical: ScrollBar {
                                    background: Rectangle {
                                        id: _background

                                        width: 6
                                        implicitWidth: 6

                                        radius: 3

                                        color: "#1AFFFFFF"
                                    }

                                    contentItem: Rectangle {
                                        id: _indicator

                                        width: 6
                                        implicitWidth: 6

                                        radius: 3

                                        color: "#80C4C4C4"
                                    }
                                }

                                clip: true

                                cellWidth: 68
                                cellHeight: 68

                                delegate: Item {
                                    width: 64
                                    height: 64

                                    MFXUICT.ColoredIcon {
                                        anchors.top: parent.top
                                        anchors.horizontalCenter: parent.horizontalCenter

                                        width: 38
                                        height: 48

                                        source: "qrc:/icons/output_screen/output_screen_file_icon.svg"
                                    }

                                    Text {
                                        anchors.bottom: parent.bottom
                                        anchors.left: parent.left
                                        anchors.right: parent.right

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignBottom

                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: 12

                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 10

                                        color: "#FFFFFF"

                                        text: model.name
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 442
            Layout.maximumWidth: 442
            Layout.minimumWidth: 442
            Layout.fillHeight: true

            radius: 2

            color: "#444444"

            ColumnLayout {
                anchors.fill: parent

                spacing: 0

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24
                    Layout.maximumHeight: 24
                    Layout.minimumHeight: 24

                    Item {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.leftMargin: 3
                        anchors.topMargin: 3

                        width: 16
                        height: 16

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 5

                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter

                            lineHeightMode: Text.FixedHeight
                            lineHeight: 10

                            font.family: MFXUIS.Fonts.robotoMedium.name
                            font.pixelSize: 12

                            color: "#FFFFFF"

                            text: translationsManager.translationTrigger + qsTr("Edit Layers")
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.margins: 2

                    color: "#222222"

                    radius: 2

                    ColumnLayout {
                        anchors.fill: parent

                        spacing: 0

                        Text {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 24
                            Layout.maximumHeight: 24
                            Layout.minimumHeight: 24
                            Layout.topMargin: 12

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            lineHeightMode: Text.FixedHeight
                            lineHeight: 24

                            font.family: MFXUIS.Fonts.robotoRegular.name
                            font.pixelSize: 16

                            color: "#A1A1A1"

                            text: translationsManager.translationTrigger + qsTr("Select Layer")
                        }

                        MFXUICT.LayoutSpacer {
                            fixedHeight: 8
                        }

                        Flow {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 80
                            Layout.maximumHeight: 80
                            Layout.minimumHeight: 80
                            Layout.leftMargin: 11
                            Layout.rightMargin: 11

                            spacing: 4

                            ButtonGroup {
                                id: layersButtonGroup

                                exclusive: true
                            }
                            Repeater {
                                model: 20



                                Button {
                                    id: layerButton

                                    width: 38
                                    height: 38

                                    checkable: true
                                    checked: false

                                    background: Rectangle {
                                        color: layerButton.checked ? "#2F80ED" : "#444444"

                                        radius: 4
                                    }

                                    contentItem: Text {
                                        anchors.fill: parent

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        font.family: MFXUIS.Fonts.robotoMedium.name
                                        font.pixelSize: 12

                                        color: "#FFFFFF"

                                        text: model.index
                                    }


                                    ButtonGroup.group: layersButtonGroup
                                }
                            }
                        }

                        MFXUICT.LayoutSpacer {
                            fixedHeight: 12
                        }

                        Text {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 24
                            Layout.maximumHeight: 24
                            Layout.minimumHeight: 24

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            lineHeightMode: Text.FixedHeight
                            lineHeight: 24

                            font.family: MFXUIS.Fonts.robotoRegular.name
                            font.pixelSize: 16

                            color: "#A1A1A1"

                            text: translationsManager.translationTrigger + qsTr("Preview buttons")
                        }

                        MFXUICT.LayoutSpacer {
                            fixedHeight: 8
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 58
                            Layout.maximumHeight: 58
                            Layout.minimumHeight: 58
                            Layout.leftMargin: 8
                            Layout.rightMargin: 8

                            radius: 4

                            color: "#000000"

                            clip: true

                            ListView {
                                id: previewButtonsListView

                                anchors.fill: parent
                                anchors.margins: 8

                                //TODOMODEL модель отвечает за отображение лейеров
                                model: ListModel {
                                    Component.onCompleted: {
                                        append({
                                                   "name": "1"
                                                   ,"repeat": false
                                                   ,"action": OutputScreen.LayerActionType.Shot
                                                   ,"containsImage": false
                                                   ,"imageSource": ""
                                                   ,"buttonColor": "#FFFFFF"
                                               })
                                        append({
                                                   "name": "2"
                                                   ,"repeat": true
                                                   ,"action": OutputScreen.LayerActionType.Hold
                                                   ,"containsImage": true
                                                   ,"imageSource": ""
                                                   ,"buttonColor": "#FF7800"
                                               })
                                        append({
                                                   "name": "3"
                                                   ,"repeat": false
                                                   ,"action": OutputScreen.LayerActionType.Shot
                                                   ,"containsImage": false
                                                   ,"imageSource": ""
                                                   ,"buttonColor": "#05F96C"
                                               })
                                        append({
                                                   "name": "4"
                                                   ,"repeat": true
                                                   ,"action": OutputScreen.LayerActionType.Hold
                                                   ,"containsImage": true
                                                   ,"imageSource": ""
                                                   ,"buttonColor": "#000000"
                                               })
                                        append({
                                                   "name": "5"
                                                   ,"repeat": false
                                                   ,"action": OutputScreen.LayerActionType.Shot
                                                   ,"containsImage": false
                                                   ,"imageSource": ""
                                                   ,"buttonColor": "#FFFFFF"
                                               })
                                        append({
                                                   "name": "6"
                                                   ,"repeat": true
                                                   ,"action": OutputScreen.LayerActionType.Hold
                                                   ,"containsImage": true
                                                   ,"imageSource": ""
                                                   ,"buttonColor": "#FA00FF"
                                               })
                                        append({
                                                   "name": "7"
                                                   ,"repeat": true
                                                   ,"action": OutputScreen.LayerActionType.Shot
                                                   ,"containsImage": false
                                                   ,"imageSource": ""
                                                   ,"buttonColor": "#05F96C"
                                               })
                                        append({
                                                   "name": "8"
                                                   ,"repeat": false
                                                   ,"action": OutputScreen.LayerActionType.Hold
                                                   ,"containsImage": true
                                                   ,"imageSource": ""
                                                   ,"buttonColor": "#FFFFFF"
                                               })
                                        append({
                                                   "name": "9"
                                                   ,"repeat": true
                                                   ,"action": OutputScreen.LayerActionType.Shot
                                                   ,"containsImage": false
                                                   ,"imageSource": ""
                                                   ,"buttonColor": "#05F96C"
                                               })
                                        append({
                                                   "name": "10"
                                                   ,"repeat": true
                                                   ,"action": OutputScreen.LayerActionType.Hold
                                                   ,"containsImage": true
                                                   ,"imageSource": ""
                                                   ,"buttonColor": "#05F96C"
                                               })
                                        append({
                                                   "name": "11"
                                                   ,"repeat": true
                                                   ,"action": OutputScreen.LayerActionType.Shot
                                                   ,"containsImage": false
                                                   ,"imageSource": ""
                                                   ,"buttonColor": "#05F96C"
                                               })
                                        append({
                                                   "name": "12"
                                                   ,"repeat": true
                                                   ,"action": OutputScreen.LayerActionType.Hold
                                                   ,"containsImage": true
                                                   ,"imageSource": ""
                                                   ,"buttonColor": "#05F96C"
                                               })
                                    }
                                }

                                orientation: ListView.Horizontal
                                spacing: 10

                                delegate: Loader {
                                    id: previewButtonsListViewDelegate

                                    property bool selected: previewButtonsListView.currentIndex === model.index

                                    anchors.verticalCenter: parent.verticalCenter

                                    width: 42
                                    height: 42

                                    sourceComponent: model.containsImage ? lottieComponent : numberComponent

                                    onLoaded: {
                                        item.modelData = model
                                    }

                                    Rectangle {
                                        anchors.fill: parent

                                        radius: 4

                                        color: previewButtonsListViewDelegate.selected ? "#828282" : "#333333"

                                        border.width: 2
                                        border.color: previewButtonsListViewDelegate.selected ? "#80C1C1C1" : "transparent"

                                        Behavior on color { ColorAnimation { duration: 125 } }
                                        Behavior on border.color { ColorAnimation { duration: 125 } }
                                    }

                                    MouseArea {
                                        anchors.fill: parent

                                        onClicked: {
                                            previewButtonsListView.currentIndex = model.index
                                        }
                                    }

                                    //Обычный компонент с номером лейера
                                    Component {
                                        id: numberComponent

                                        Item {
                                            property var modelData

                                            Text {
                                                anchors.fill: parent

                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter

                                                lineHeightMode: Text.FixedHeight
                                                lineHeight: 20

                                                font.family: MFXUIS.Fonts.robotoBold.name
                                                font.pixelSize: 14

                                                color: modelData.buttonColor

                                                text: modelData.name
                                            }
                                        }
                                    }

                                    //Анимированный компонент
                                    Component {
                                        id: lottieComponent

                                        Item {
                                            property var modelData
                                        }
                                    }
                                }
                            }
                        }

                        MFXUICT.LayoutSpacer {
                            fixedHeight: 12
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            Layout.maximumHeight: 36
                            Layout.minimumHeight: 36
                            Layout.leftMargin: 10
                            Layout.rightMargin: 10

                            spacing: 3

                            Text {
                                Layout.fillHeight: true
                                Layout.preferredHeight: 36
                                Layout.maximumHeight: 36
                                Layout.minimumHeight: 36

                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter

                                lineHeightMode: Text.FixedHeight
                                lineHeight: 26

                                font.family: MFXUIS.Fonts.robotoRegular.name
                                font.pixelSize: 16

                                color: "#A1A1A1"

                                text: translationsManager.translationTrigger + qsTr("Layer Name")
                            }

                            MFXUICT.TextInputField {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                textSize: 16
                                //TODO
                                text: "Name"
                                placeholderText: ""
                            }
                        }

                        MFXUICT.LayoutSpacer {
                            fixedHeight: 16
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            Layout.maximumHeight: 36
                            Layout.minimumHeight: 36
                            Layout.leftMargin: 10
                            Layout.rightMargin: 10

                            spacing: 24

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                RowLayout {
                                    anchors.fill: parent

                                    spacing: 0

                                    Text {
                                        Layout.fillHeight: true
                                        Layout.preferredWidth: 36
                                        Layout.maximumWidth: 36
                                        Layout.minimumWidth: 36

                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.AlignVCenter

                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: 26

                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 16

                                        color: "#A1A1A1"

                                        text: translationsManager.translationTrigger + qsTr("Repeat")
                                    }

                                    MFXUICT.LayoutSpacer {}

                                    Switch {
                                        id: repeatSwitch

                                        Layout.fillHeight: true
                                        Layout.preferredWidth: 102
                                        Layout.maximumWidth: 102
                                        Layout.minimumWidth: 102

                                        indicator: Rectangle {
                                            width: repeatSwitch.width
                                            height: repeatSwitch.height
                                            x: 0
                                            y: 0

                                            radius: 2
                                            color: "#000000"

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom

                                                width: repeatSwitch.width / 2
                                                x: repeatSwitch.checked ? repeatSwitch.width - width : 0

                                                radius: 2

                                                color: repeatSwitch.down ? "#649ce8" : "#2F80ED"

                                                Behavior on x { SmoothedAnimation { duration: 175 } }
                                            }

                                            Text {
                                                anchors.left: parent.left
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                width: parent.width / 2

                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter

                                                lineHeightMode: Text.FixedHeight
                                                lineHeight: 26

                                                font.family: MFXUIS.Fonts.robotoRegular.name
                                                font.pixelSize: 16

                                                color: !repeatSwitch.checked ? "#FFFFFF" : "#80FFFFFF"

                                                Behavior on color { ColorAnimation { duration : 175 } }

                                                text: translationsManager.translationTrigger + qsTr("Off")
                                            }

                                            Text {
                                                anchors.right: parent.right
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                width: parent.width / 2

                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter

                                                lineHeightMode: Text.FixedHeight
                                                lineHeight: 26

                                                font.family: MFXUIS.Fonts.robotoRegular.name
                                                font.pixelSize: 16

                                                color: repeatSwitch.checked ? "#FFFFFF" : "#80FFFFFF"

                                                Behavior on color { ColorAnimation { duration : 175 } }

                                                text: translationsManager.translationTrigger + qsTr("On")
                                            }
                                        }

                                        contentItem: Item {}
                                    }
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                RowLayout {
                                    anchors.fill: parent

                                    spacing: 0

                                    Text {
                                        Layout.fillHeight: true
                                        Layout.preferredWidth: 36
                                        Layout.maximumWidth: 36
                                        Layout.minimumWidth: 36

                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.AlignVCenter

                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: 26

                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 16

                                        color: "#A1A1A1"

                                        text: translationsManager.translationTrigger + qsTr("Action")
                                    }

                                    MFXUICT.LayoutSpacer {}

                                    Switch {
                                        id: repeatSwitch2

                                        Layout.fillHeight: true
                                        Layout.preferredWidth: 102
                                        Layout.maximumWidth: 102
                                        Layout.minimumWidth: 102

                                        indicator: Rectangle {
                                            width: repeatSwitch2.width
                                            height: repeatSwitch2.height
                                            x: 0
                                            y: 0

                                            radius: 2
                                            color: "#000000"

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom

                                                width: repeatSwitch2.width / 2
                                                x: repeatSwitch2.checked ? repeatSwitch2.width - width : 0

                                                radius: 2

                                                color: repeatSwitch2.down ? "#649ce8" : "#2F80ED"

                                                Behavior on x { SmoothedAnimation { duration: 175 } }
                                            }

                                            Text {
                                                anchors.left: parent.left
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                width: parent.width / 2

                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter

                                                lineHeightMode: Text.FixedHeight
                                                lineHeight: 26

                                                font.family: MFXUIS.Fonts.robotoRegular.name
                                                font.pixelSize: 16

                                                color: !repeatSwitch2.checked ? "#FFFFFF" : "#80FFFFFF"

                                                Behavior on color { ColorAnimation { duration : 175 } }

                                                text: translationsManager.translationTrigger + qsTr("Shot")
                                            }

                                            Text {
                                                anchors.right: parent.right
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                width: parent.width / 2

                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter

                                                lineHeightMode: Text.FixedHeight
                                                lineHeight: 26

                                                font.family: MFXUIS.Fonts.robotoRegular.name
                                                font.pixelSize: 16

                                                color: repeatSwitch2.checked ? "#FFFFFF" : "#80FFFFFF"

                                                Behavior on color { ColorAnimation { duration : 175 } }

                                                text: translationsManager.translationTrigger + qsTr("Hold")
                                            }
                                        }

                                        contentItem: Item {}
                                    }
                                }
                            }
                        }

                        MFXUICT.LayoutSpacer {
                            fixedHeight: 16
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            Layout.maximumHeight: 36
                            Layout.minimumHeight: 36
                            Layout.leftMargin: 10
                            Layout.rightMargin: 10

                            spacing: 24

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                RowLayout {
                                    anchors.fill: parent

                                    spacing: 0

                                    Text {
                                        Layout.fillHeight: true
                                        Layout.preferredWidth: implicitWidth
                                        Layout.maximumWidth: implicitWidth
                                        Layout.minimumWidth: implicitWidth

                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.AlignVCenter

                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: 26

                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 16

                                        color: "#A1A1A1"

                                        text: translationsManager.translationTrigger + qsTr("Button Image")
                                    }

                                    MFXUICT.LayoutSpacer { }

                                    Rectangle {
                                        Layout.preferredWidth: 36
                                        Layout.maximumWidth: 36
                                        Layout.minimumWidth: 36
                                        Layout.preferredHeight: 36
                                        Layout.maximumHeight: 36
                                        Layout.minimumHeight: 36

                                        color: "#FFFFFF"

                                        border.color: "#000000"
                                        border.width: 5
                                    }
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                RowLayout {
                                    anchors.fill: parent

                                    spacing: 24

                                    Text {
                                        Layout.fillHeight: true
                                        Layout.preferredWidth: implicitWidth
                                        Layout.maximumWidth: implicitWidth
                                        Layout.minimumWidth: implicitWidth

                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.AlignVCenter

                                        lineHeightMode: Text.FixedHeight
                                        lineHeight: 26

                                        font.family: MFXUIS.Fonts.robotoRegular.name
                                        font.pixelSize: 16

                                        color: "#A1A1A1"

                                        text: translationsManager.translationTrigger + qsTr("Button Color")
                                    }

                                    MFXUICT.LayoutSpacer { }

                                    Rectangle {
                                        Layout.preferredWidth: 36
                                        Layout.maximumWidth: 36
                                        Layout.minimumWidth: 36
                                        Layout.preferredHeight: 36
                                        Layout.maximumHeight: 36
                                        Layout.minimumHeight: 36

                                        color: "#05F96C"

                                        border.color: "#000000"
                                        border.width: 5
                                    }
                                }
                            }
                        }

                        MFXUICT.LayoutSpacer {
                            fixedHeight: 10
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.margins: 2

                            radius: 2

                            color: "#000000"

                            ListView {
                                id: layerTemplatesListView

                                anchors.fill: parent

                                model: ListModel {
                                    id: layerTemplatesListViewModel

                                    ListElement { path: "Place / Name" }
                                    ListElement { path: "Project / Fire_1" }
                                    ListElement { path: "Cloud / Nicer Dicer" }
                                    ListElement { path: "Cloud / Viva...scene2 / Nicer Dicer" }
                                    ListElement { path: "Cloud / Viva...scene2 / Nicer Dicer" }
                                    ListElement { path: "Cloud / Viva...scene2 / Nicer Dicer" }
                                    ListElement { path: "Cloud / Viva...scene2 / Nicer Dicer" }
                                    ListElement { path: "Cloud / Viva...scene2 / Nicer Dicer" }
                                    ListElement { path: "Cloud / Viva...scene2 / Nicer Dicer" }
                                    ListElement { path: "Cloud / Viva...scene2 / Nicer Dicer" }
                                    ListElement { path: "Cloud / Viva...scene2 / Nicer Dicer" }
                                    ListElement { path: "Cloud / Viva...scene2 / Nicer Dicer" }
                                }

                                orientation: ListView.Vertical
                                clip: true

                                ScrollBar.vertical: ScrollBar {
                                    background: Rectangle {

                                        width: 6
                                        implicitWidth: 6

                                        radius: 3

                                        color: "#1AFFFFFF"
                                    }

                                    contentItem: Rectangle {

                                        width: 6
                                        implicitWidth: 6

                                        radius: 3

                                        color: "#80C4C4C4"
                                    }
                                }

                                delegate: Item {
                                    id: layerTemplatesListViewDelegate

                                    anchors.left: layerTemplatesListView.contentItem.left
                                    anchors.right: layerTemplatesListView.contentItem.right

                                    height: 40

                                    RowLayout {
                                        anchors.fill: parent

                                        spacing: 0

                                        Text {
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: 24
                                            Layout.maximumWidth: 24
                                            Layout.minimumWidth: 24

                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter

                                            lineHeightMode: Text.FixedHeight
                                            lineHeight: 24

                                            font.family: MFXUIS.Fonts.robotoRegular.name
                                            font.pixelSize: 14

                                            color: "#80FFFFFF"

                                            text: model.index + 1
                                        }

                                        MFXUICT.LayoutSpacer {
                                            fixedWidth: 3
                                        }

                                        MFXUICT.ColoredIcon {
                                            Layout.preferredWidth: 25
                                            Layout.maximumWidth: 25
                                            Layout.minimumWidth: 25
                                            Layout.preferredHeight: 30
                                            Layout.maximumHeight: 30
                                            Layout.minimumHeight: 30
                                            Layout.alignment: Qt.AlignVCenter

                                            source: "qrc:/icons/output_screen/output_screen_file_icon.svg"
                                        }

                                        MFXUICT.LayoutSpacer {
                                            fixedWidth: 3
                                        }

                                        Text {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            Layout.leftMargin: 10

                                            horizontalAlignment: Text.AlignLeft
                                            verticalAlignment: Text.AlignVCenter

                                            lineHeightMode: Text.FixedHeight
                                            lineHeight: 24

                                            elide: Text.ElideMiddle

                                            font.family: MFXUIS.Fonts.robotoRegular.name
                                            font.pixelSize: 14

                                            color: "#FFFFFF"

                                            text: model.path
                                        }

                                        Button {
                                            id: deleteButton

                                            Layout.fillHeight: true
                                            Layout.preferredWidth: implicitWidth + 8
                                            Layout.maximumWidth: implicitWidth + 8
                                            Layout.minimumWidth: implicitWidth + 8
                                            Layout.rightMargin: 10

                                            background: Item {}
                                            contentItem: Text {
                                                Layout.fillHeight: true
                                                Layout.fillWidth: true

                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter

                                                lineHeightMode: Text.FixedHeight
                                                lineHeight: 24

                                                elide: Text.ElideMiddle

                                                font.family: MFXUIS.Fonts.robotoRegular.name
                                                font.pixelSize: 10

                                                color: deleteButton.pressed ? "#e86f6f" : "#EB5757"

                                                text: translationsManager.translationTrigger + qsTr("Delete")
                                            }

                                            onClicked: {
                                                layerTemplatesListViewModel.remove(model.index)
                                            }
                                        }
                                    }

                                    Rectangle {
                                        anchors.bottom: parent.bottom
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.leftMargin: 4
                                        anchors.rightMargin: 4 + 10

                                        height: 1

                                        color: "#1FFFFFFF"
                                    }
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    Layout.maximumHeight: 40
                    Layout.minimumHeight: 40

                    Row {
                        anchors.centerIn: parent

                        spacing: 12

                        Item {
                            width: 120
                            height: 24

                            MfxButton {
                                anchors.fill: parent

                                checkable: false

                                font.family: MFXUIS.Fonts.robotoMedium.name
                                textSize: 8
                                color: "#2F80ED"
                                pressedColor: "#649ce8"
                                enableShadow: true

                                text: translationsManager.translationTrigger + qsTr("Pyro mount list")

                                onClicked: {
                                    //TODO реализовать
                                }
                            }
                        }

                        Item {
                            width: 120
                            height: 24

                            MfxButton {
                                anchors.fill: parent

                                checkable: false

                                font.family: MFXUIS.Fonts.robotoMedium.name
                                textSize: 8
                                color: "#2F80ED"
                                pressedColor: "#649ce8"
                                enableShadow: true

                                text: translationsManager.translationTrigger + qsTr("Upload to cloud")

                                onClicked: {
                                    //TODO реализовать
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true

            radius: 2

            color: "#444444"

            ColumnLayout {
                anchors.fill: parent

                spacing: 0

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24
                    Layout.maximumHeight: 24
                    Layout.minimumHeight: 24

                    Item {
                        id: cloudIconItem

                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.leftMargin: 3
                        anchors.topMargin: 3

                        width: 16
                        height: 16

                        MFXUICT.ColoredIcon {
                            anchors.centerIn: parent
                            width: 16
                            height: 16

                            source: "qrc:/icons/output_screen/output_screen_cloud_icon.svg"
                        }
                    }

                    Text {
                        anchors.left: cloudIconItem.right
                        anchors.verticalCenter: cloudIconItem.verticalCenter
                        anchors.leftMargin: 5

                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        lineHeightMode: Text.FixedHeight
                        lineHeight: 10

                        font.family: MFXUIS.Fonts.robotoMedium.name
                        font.pixelSize: 12

                        color: "#FFFFFF"

                        text: translationsManager.translationTrigger + qsTr("My Cloud")
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    color: "#222222"

                    radius: 2

                    ColumnLayout {
                        anchors.fill: parent

                        spacing: 0

                        //TODO тут сверстал пока в простом формате
                        //     правильно сделать - это разбить Path до текущей директории на подпапки, сделать из этого модель
                        //     и отображать в горизонтальном Flickable или даже имитировать ElideMiddle, отмечая для длинного пути
                        //     часть элементов тремя точками ...
                        Text {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20
                            Layout.maximumHeight: 20
                            Layout.minimumHeight: 20
                            Layout.leftMargin: 5

                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter

                            lineHeightMode: Text.FixedHeight
                            lineHeight: 10

                            elide: Text.ElideMiddle

                            font.family: MFXUIS.Fonts.robotoMedium.name
                            font.pixelSize: 12

                            color: "#FFFFFF"

                            //TODO заменить до пути до облака
                            text: translationsManager.translationTrigger + qsTr("/ Cloud")
                        }

                        MFXUICT.RoundedRectangleShape {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            bottomLeftRadius: 2
                            bottomRightRadius: 2

                            fillColor: "#000000"
                            borderColor: "#000000"

                            GridView {
                                anchors.fill: parent
                                anchors.margins: 8

                                //TODOMODEL добавить cloud file system model
                                model: ListModel {
                                    Component.onCompleted: {
                                        append({"name":"Folder Name", type: OutputScreen.CloudFSItemType.Folder})
                                        append({"name":"VivaBraslav_scene1", type: OutputScreen.CloudFSItemType.Folder})
                                        for(var i = 0; i < 23; i++) {
                                            append({"name":"Name", type: OutputScreen.CloudFSItemType.File})
                                        }
                                    }
                                }

                                ScrollBar.vertical: ScrollBar {
                                    background: Rectangle {

                                        width: 6
                                        implicitWidth: 6

                                        radius: 3

                                        color: "#1AFFFFFF"
                                    }

                                    contentItem: Rectangle {

                                        width: 6
                                        implicitWidth: 6

                                        radius: 3

                                        color: "#80C4C4C4"
                                    }
                                }

                                clip: true

                                cellWidth: 68
                                cellHeight: 68

                                delegate: Item {
                                    width: 64
                                    height: 64

                                    Loader {

                                        anchors.fill: parent

                                        sourceComponent: model.type === OutputScreen.CloudFSItemType.Folder ? folderFSComponent
                                                                                                            : fileFSComponent

                                        onLoaded: {
                                            item.modelData = model
                                        }

                                        Component {
                                            id: folderFSComponent

                                            Item {
                                                property var modelData

                                                MFXUICT.ColoredIcon {
                                                    anchors.top: parent.top
                                                    anchors.horizontalCenter: parent.horizontalCenter

                                                    width: 58
                                                    height: 48

                                                    source: "qrc:/icons/output_screen/output_screen_folder_icon.svg"
                                                }

                                                Text {
                                                    anchors.bottom: parent.bottom
                                                    anchors.left: parent.left
                                                    anchors.right: parent.right

                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignBottom

                                                    lineHeightMode: Text.FixedHeight
                                                    lineHeight: 12

                                                    elide: Text.ElideMiddle

                                                    font.family: MFXUIS.Fonts.robotoRegular.name
                                                    font.pixelSize: 10

                                                    color: "#FFFFFF"

                                                    text: modelData.name
                                                }
                                            }
                                        }

                                        Component {
                                            id: fileFSComponent

                                            Item {

                                                property var modelData

                                                MFXUICT.ColoredIcon {
                                                    anchors.top: parent.top
                                                    anchors.horizontalCenter: parent.horizontalCenter

                                                    width: 38
                                                    height: 48

                                                    source: "qrc:/icons/output_screen/output_screen_file_icon.svg"
                                                }

                                                Text {
                                                    anchors.bottom: parent.bottom
                                                    anchors.left: parent.left
                                                    anchors.right: parent.right

                                                    horizontalAlignment: Text.AlignHCenter
                                                    verticalAlignment: Text.AlignBottom

                                                    lineHeightMode: Text.FixedHeight
                                                    lineHeight: 12

                                                    elide: Text.ElideMiddle

                                                    font.family: MFXUIS.Fonts.robotoRegular.name
                                                    font.pixelSize: 10

                                                    color: "#FFFFFF"

                                                    text: modelData.name
                                                }
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent

                                            onClicked: {
                                                //TODO выделение
                                            }

                                            onDoubleClicked: {
                                                //TODO открытие папки либо выбор файла
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI.Components.Templates 1.0 as MFXUICT
import MFX.UI.Styles 1.0 as MFXUIS


Item {
    id: control

    property bool allSelected: false
    property alias currentIndex: valueStack.currentIndex
    property alias model: contentRepeater.model
    property var value
    property bool switchable: true

    signal selectRequest()
    signal sortRequest()
    signal deselectRequest()

    onCurrentIndexChanged: {
        value = contentRepeater.model.get(currentIndex).value
    }

    function setValue(value) {
        control.value = value
        for(var i = 0; i < model.count; i++) {

            var modelValue = model.get(i).value;
            if(modelValue === value) {
                currentIndex = i;
                break;
            }
        }
    }

    StackLayout {
        id: valueStack

        anchors.fill: parent

        Repeater {
            id: contentRepeater

            Text {
                id: headerText

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                lineHeightMode: Text.FixedHeight
                lineHeight: 12

                elide: Text.ElideRight

                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 10

                color: "#FFFFFF"

                text: model ? model.text : ""

                MouseArea {
                    id: headerTextMouseArea

                    anchors.fill: parent

                    //TODO лучше сделать QQuickItem, чтобы единичный клик срабатывал без задержки
                    Timer {
                        id: singleClickTimer

                        running: false
                        repeat: false
                        interval: 500 //https://en.wikipedia.org/wiki/Double-click

                        onTriggered: {
                            headerTextMouseArea.onSingleClick()
                        }
                    }

                    function onSingleClick() {
                        if(control.allSelected) {
                            control.deselectRequest()
                        } else {
                            control.selectRequest()
                        }
                        control.allSelected = !control.allSelected
                    }

                    function onDoubleClick() {
                        control.sortRequest()
                    }

                    onClicked: {
                        if(singleClickTimer.running) {
                            singleClickTimer.stop()
                            headerTextMouseArea.onDoubleClick()
                        } else {
                            singleClickTimer.restart()
                        }
                    }
                }
            }
        }
    }

    Item {
        id: controlsItem

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: 16

        visible: control.switchable && (control.model.count > 1)

        MouseArea {
            anchors.fill: parent

            propagateComposedEvents: false
            preventStealing: true
        }

        ColumnLayout {
            anchors.fill: parent

            spacing: 0

            Button {
                id: topButton

                Layout.fillWidth: true
                Layout.fillHeight: true

                contentItem: Item {
                    anchors.fill: parent

                    MFXUICT.ColoredIcon {
                        anchors.top: parent.top
                        anchors.topMargin: 4
                        anchors.horizontalCenter: parent.horizontalCenter

                        width: 6
                        height: 6

                        source: "qrc:/icons/components/table_header_switch_item_from_top_icon.svg"

                        color: pressed ? "#2F80ED"
                                       : "#80FFFFFF"

                        onClicked: {
                            topButton.clicked()
                        }
                    }
                }

                background: Item {}

                onClicked: {
                    if(control.currentIndex < control.model.count - 1) {
                        control.currentIndex += 1
                    }
                }
            }

            Button {
                id: bottomButton

                Layout.fillWidth: true
                Layout.fillHeight: true

                contentItem: Item {
                    anchors.fill: parent

                    MFXUICT.ColoredIcon {
                        id: bottomButtonIcon

                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 4
                        anchors.horizontalCenter: parent.horizontalCenter

                        width: 6
                        height: 6

                        source: "qrc:/icons/components/table_header_switch_item_from_bottom_icon.svg"

                        color: pressed ? "#2F80ED"
                                       : "#80FFFFFF"

                        onClicked: {
                            bottomButton.clicked()
                        }
                    }
                }

                background: Item {}

                onClicked: {
                    if(control.currentIndex > 0) {
                        control.currentIndex -= 1
                    }
                }
            }
        }
    }
}

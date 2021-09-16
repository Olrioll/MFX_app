import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI.Components.Templates 1.0 as MFXUICT
import MFX.UI.Styles 1.0 as MFXUIS


Item {
    id: control

    property alias currentIndex: valueStack.currentIndex
    property alias model: contentRepeater.model
    property var value

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
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                lineHeightMode: Text.FixedHeight
                lineHeight: 12

                elide: Text.ElideRight

                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 10

                color: "#FFFFFF"

                text: model ? model.text : ""
            }
        }
    }

    Item {
        id: controlsItem

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: 16

        visible: control.model.count > 1

        MFXUICT.ColoredIcon {

            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter

            width: 6
            height: 6

            source: "qrc:/icons/components/table_header_switch_item_from_top_icon.svg"

            color: "#80FFFFFF"

            MouseArea {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: -8

                width: 16
                height: 15

                onClicked: {
                    if(control.currentIndex < control.model.count - 1) {
                        control.currentIndex += 1
                    }
                }
            }
        }

        MFXUICT.ColoredIcon {

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter

            width: 6
            height: 6

            source: "qrc:/icons/components/table_header_switch_item_from_bottom_icon.svg"

            color: "#80FFFFFF"

            MouseArea {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -8

                width: 16
                height: 15

                onClicked: {
                    if(control.currentIndex > 0) {
                        control.currentIndex -= 1
                    }
                }
            }
        }
    }
}



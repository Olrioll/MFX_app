import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T

import MFX.UI.Components.Templates 1.0 as MFXUICT
import MFX.UI.Styles 1.0 as MFXUIS

T.ComboBox {
    id: _combobox

    property string indicatorIcon: "qrc:/icons/components/combobox_dropdown_indicator.svg"
    property color indicatorBackgroundColor: "#444444"
    property color indicatorColor: "#C4C4C4"
    property color backgroundColor: "#000000"
    property color dropdownBackgroundColor: "#000000"
    property color textColor: "#FFFFFF"
    property color highlightedTextColor: "#FFFFFF"

    implicitHeight: 18
    height: implicitHeight

    textRole: "text"
    valueRole: "value"

    padding: 0

    background: Rectangle {
        id: _background

        radius: 2

        color: _combobox.backgroundColor
    }

    contentItem: Text {

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 4
        anchors.rightMargin: 4 + indicator.width + 4

        color: _combobox.textColor

        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        font.family: MFXUIS.Fonts.robotoRegular.name
        font.pixelSize: 8

        text: _combobox.displayText
    }

    indicator: Rectangle {
        anchors.verticalCenter: parent.verticalCenter

        x: _combobox.width - width - 3

        width: 10
        height: 10

        radius: 2

        color: _combobox.indicatorBackgroundColor

        MFXUICT.ColoredIcon {
            anchors.centerIn: parent

            width: 6
            height: 4

            color: _combobox.indicatorColor

            source: _combobox.indicatorIcon

            rotation: _combobox.popup.opened ? 180 : 0
        }
    }

    popup: Popup {
        topMargin: 0
        bottomMargin: 10

        x: 1
        y: _combobox.height
        width: _combobox.width - 1
        height: contentItem.implicitHeight + 10
        modal: true

        Overlay.modal: Item {}

        leftInset: 0
        rightInset: 0
        rightMargin: 0
        leftMargin: 0
        rightPadding: 0
        leftPadding: 0

        contentItem: ListView {
            id: _contentListView

            implicitHeight: Math.min(contentHeight, 200)
            currentIndex: _combobox.highlightedIndex
            spacing: 4
            interactive: height < contentHeight
            model: _combobox.delegateModel

            ScrollIndicator.vertical: ScrollIndicator {
                visible: _contentListView.interactive
            }
        }

        background: MFXUICT.RoundedRectangleShape {
            fillColor: _combobox.dropdownBackgroundColor
            bottomLeftRadius: 2
            bottomRightRadius: 2
        }

    }

    delegate: Text {
        x: 4
        width: ListView.view.width - 8
        height: 10
        color: _combobox.highlightedIndex === index ? _combobox.highlightedTextColor :  _combobox.textColor

        font.family: MFXUIS.Fonts.robotoRegular.name
        font.pixelSize: 8

        text: model["text"]

        MouseArea {
            anchors.fill: parent

            onClicked: {
                _combobox.currentIndex = index
                _combobox.popup.close()
            }
        }
    }
}

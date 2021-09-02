import QtQuick 2.15
import QtQuick.Controls 2.15

import MFX.UI.Styles 1.0 as MFXUIS

FocusScope {
    id: _textfield

    property color textColor: "#FFFFFF"
    property color backgroundColor: "#000000"
    property alias text: _text.text
    property alias placeholderText: _placeholder.text
    property color placeholderColor: "#80FFFFFF"
    property bool errorState: false
    property color errorStateColor: "#EB5757"
    property int textSize: 8

    implicitHeight: 18

    height: implicitHeight

    clip: true

    Rectangle {
        anchors.fill: parent

        radius: 2

        color: _textfield.backgroundColor

        border.width: errorState ? 1 : 0
        border.color: _textfield.errorStateColor
    }

    Text {
        id: _placeholder

        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        anchors.topMargin: 5
        anchors.bottomMargin: 5

        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        font.family: MFXUIS.Fonts.robotoRegular.name
        font.pixelSize: _textfield.textSize

        color: _textfield.placeholderColor

        visible: _text.text.length === 0
    }

    TextInput {
        id: _text

        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        anchors.topMargin: 5
        anchors.bottomMargin: 5

        focus: true
        color: _textfield.errorState ? _textfield.errorStateColor : _textfield.textColor
        font.family: MFXUIS.Fonts.robotoRegular.name
        font.pixelSize: _textfield.textSize

        verticalAlignment: TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignLeft
    }
}

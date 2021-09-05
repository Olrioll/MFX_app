import QtQuick 2.15
import QtQuick.Controls 2.15

import MFX.UI.Styles 1.0 as MFXUIS

FocusScope {
    id: _textfield

    property alias text: _text.text
    property int textSize: 8
    property color textColor: "#FFFFFF"

    property color backgroundColor: "#000000"

    property alias placeholderText: _placeholder.text
    property color placeholderColor: "#80FFFFFF"

    property bool errorState: false
    property color errorStateColor: "#EB5757"

    property alias inputMask: _text.inputMask
    property alias acceptableInput: _text.acceptableInput
    property alias validator: _text.validator

    property alias horizontalAlignment: _text.horizontalAlignment
    property alias verticalAlignment: _text.verticalAlignment

    property alias _textItem: _text

    signal accepted()
    signal editingFinished()
    signal textEdited()

    function forceFocus() {
        _text.forceActiveFocus()
    }

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

        mouseSelectionMode: TextInput.SelectCharacters
        persistentSelection: false
        wrapMode: TextInput.NoWrap
        selectionColor: "#444444"

        focus: true
        color: _textfield.errorState ? _textfield.errorStateColor : _textfield.textColor
        font.family: MFXUIS.Fonts.robotoRegular.name
        font.pixelSize: _textfield.textSize

        verticalAlignment: TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignLeft

        onAccepted: () => { _textfield.accepted(); }
        onEditingFinished: () => { _textfield.editingFinished(); }
        onTextEdited: () => { _textfield.textEdited(); }
    }
}

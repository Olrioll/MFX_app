import QtQuick 2.15
import QtQuick.Templates 2.15

import MFX.UI.Styles 1.0

TextField
{
    id: _textField

    font.family: Fonts.robotoRegular.name
    font.pixelSize: 14

    color: "#FFFFFF"
    placeholderTextColor : "#80FFFFFF"

    property color backgroundColor: "#000000"
    property int borderWidth: 1
    property color borderColor: "#000000"

    property bool errorState: false
    property color errorStateColor: "#EB5757"

    property bool activeStateOnFocus: false
    property bool activeState: false
    property color activeStateColor: "#2F80ED"

    //signal activeStateChanged()

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter

    background: Rectangle
    {
        id: _background

        radius: 2

        color: _textField.backgroundColor

        border.width: _textField.borderWidth
        border.color: _textField.errorState ? _textField.errorStateColor
                                            : (_textField.activeStateOnFocus && _textField.activeState) ? _textField.activeStateColor
                                                                                                        : _textField.borderColor
    }

    onFocusChanged:
    {
        if(_textField.activeStateOnFocus)
        {
            _textField.activeState = activeFocus
            //activeStateChanged()
        }
    }
}

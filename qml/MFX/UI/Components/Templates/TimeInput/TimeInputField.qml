import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

TextField
{
    property string lastSelectedText
    property int maximumValue: 59

    text: "00"
    color: "#ffffff"
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    padding: 0
    leftPadding: -2
    rightPadding: -1
    font.pointSize: 8
    maximumLength: 2

    validator: RegExpValidator { regExp: /[0-9]+/ }

    background: Rectangle
    {
        color: "transparent"
    }

    onFocusChanged:
    {
        if( focus )
        {
            selectAll()

            lastSelectedText = selectedText

            activateField( this )
        }
    }

    function checkValue()
    {
        if( text === "" )
            return false

        return Number( text ) >= 0 && Number( text ) <= maximumValue
    }
}
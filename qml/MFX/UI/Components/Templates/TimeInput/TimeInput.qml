import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout
{
    property bool isActiveInput: false
    property var activeField

    signal changeActiveField( var control, var field )

    function activateField( field )
    {
        activeField = field

        changeActiveField( this, field )
    }

    anchors.fill: parent

    Item
    {
        Layout.fillWidth: true
    }

    TimeInputField
    {
        id: timeMin
    }
    
    TimeInputDelimeter
    {
        text: ":"
    }
    
    TimeInputField
    {
        id: timeSec
    }
    
    TimeInputDelimeter
    {
        text: "."
    }
    
    TimeInputFieldMSec
    {
        id: timeMSec
    }

    Item
    {
        Layout.fillWidth: true
    }
}
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

    function checkValue()
    {
        return timeMin.checkValue() && timeSec.checkValue() && timeMSec.checkValue()
    }

    function setTimeMs( time_ms )
    {
        const min = Math.floor( time_ms / 60000 )
        const sec = Math.floor( (time_ms % 60000) / 1000 )
        const msec = time_ms % 1000 / 10

        timeMin.text = String( min ).padStart( 2, '0' )
        timeSec.text = String( sec ).padStart( 2, '0' )
        timeMSec.text = String( msec ).padStart( 2, '0' )
    }

    function getTimeMs()
    {
        return Number( timeMin.text ) * 60000 + Number( timeSec.text ) * 1000 + Number( timeMSec.text ) * 10
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
import QtQuick 2.12
import QtQuick.Controls 2.12

Button
{
    id: button
    height: 24

    property string color: "#ffffff"

    background: Rectangle
    {
        color:
        {
            if(button.checkable)
            {
                if(parent.enabled)
                    parent.checked ? button.color : "#888888"
                else
                    "#222222"
            }

            else
            {
                if(parent.enabled)
                    parent.pressed ? "#888888" : button.color
                else
                    "#222222"
            }
        }
        radius: 2
    }

    contentItem: Text
    {
        color: parent.enabled ? "#ffffff" : "#777777"
        text: parent.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.family: "Roboto"
        font.pixelSize: 12
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12

Button
{
    id: button
    height: 24

    property string color: "#4f4f4f"

    background: Rectangle
    {
        color:
        {
            if(button.checkable)
            {
                if(parent.enabled)
                    parent.checked ? button.color : "#333333"
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
        color:
        {
            if(button.checkable)
            {
                if(parent.enabled)
                    parent.checked ? "#ffffff" : "#777777"
                else
                    "#222222"
            }

            else
                parent.enabled ? "#ffffff" : "#777777"
        }

        text: parent.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.family: "Roboto"
        font.pixelSize: 12
    }
}

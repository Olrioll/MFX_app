import QtQuick 2.12
import QtQuick.Controls 2.12

import MFX.UI.Styles 1.0 as MFXUIS

Button
{
    id: button
    height: 24
    hoverEnabled: true

    property string color: "#4f4f4f"
    property string pressedColor: "#888888"
    property int textSize: 12

    background: Rectangle
    {
        color:
        {
            if(parent.enabled)
                parent.hovered ? button.color : "#4f4f4f"
            else
                "#222222"
        }
        radius: 2
    }

    contentItem: Text
    {
        color:
        {
            parent.enabled ? "#ffffff" : "#777777"
        }

        text: parent.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.family: MFXUIS.Fonts.robotoRegular.name
        font.pixelSize: button.textSize
    }
}

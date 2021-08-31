import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import MFX.UI.Styles 1.0 as MFXUIS

Button
{
    id: button
    height: 24

    property string color: "#4f4f4f"
    property string pressedColor: "#888888"
    property int textSize: 12
    property alias fontFamilyName: contentItem.font.family
    property bool enableShadow: false
    property color disabledColor: "#222222"
    property color disabledTextColor: "#777777"

    background: Rectangle
    {
        color:
        {
            if(button.checkable)
            {
                if(parent.enabled)
                    parent.checked ? button.color : "#333333"
                else
                    button.disabledColor
            }

            else
            {
                if(parent.enabled)
                    parent.pressed ? button.pressedColor : button.color
                else
                    button.disabledColor
            }
        }
        radius: 2

        layer.enabled: button.enableShadow
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 1
            radius: 4
            samples: 9
            spread: 0
            color: "#40000000"
        }
    }

    contentItem: Text
    {
        id: contentItem

        color:
        {
            if(button.checkable)
            {
                if(parent.enabled)
                    parent.checked ? "#ffffff" : button.disabledTextColor
                else
                    "#222222"
            }

            else
                parent.enabled ? "#ffffff" : button.disabledTextColor
        }

        text: parent.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.family: MFXUIS.Fonts.robotoRegular.name
        font.pixelSize: button.textSize
    }
}

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: calcWidget
    width: 124
    height: 164

    property string minusButtonText: "-"

    signal digitClicked(string digit)

    Rectangle
    {
        id: rectangle
        color: "#222222"
        radius: 2
        border.color: "#222222"
        border.width: 0
        anchors.fill: parent
        antialiasing: false

        Button
        {
            id: button7
            x: 4
            y: 4
            width: 36
            height: 36
            text: translationsManager.translationTrigger + qsTr("7")

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#444444" : "#888888"
                    else
                        "#444444"
                }
                radius: 4
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 12
            }

            onClicked: digitClicked("7")
        }

        Button
        {
            id: button8
            x: 44
            y: 4
            width: 36
            height: 36
            text: translationsManager.translationTrigger + qsTr("8")

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#444444" : "#888888"
                    else
                        "#444444"
                }
                radius: 4
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 12
            }

            onClicked: digitClicked("8")
        }

        Button
        {
            id: button9
            x: 84
            y: 4
            width: 36
            height: 36
            text: translationsManager.translationTrigger + qsTr("9")

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#444444" : "#888888"
                    else
                        "#444444"
                }
                radius: 4
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 12
            }

            onClicked: digitClicked("8")
        }

        Button
        {
            id: button4
            x: 4
            y: 44
            width: 36
            height: 36
            text: translationsManager.translationTrigger + qsTr("4")

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#444444" : "#888888"
                    else
                        "#444444"
                }
                radius: 4
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 12
            }

            onClicked: digitClicked("4")
        }

        Button
        {
            id: button5
            x: 44
            y: 44
            width: 36
            height: 36
            text: translationsManager.translationTrigger + qsTr("5")

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#444444" : "#888888"
                    else
                        "#444444"
                }
                radius: 4
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 12
            }

            onClicked: digitClicked("5")
        }

        Button
        {
            id: button6
            x: 84
            y: 44
            width: 36
            height: 36
            text: translationsManager.translationTrigger + qsTr("6")

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#444444" : "#888888"
                    else
                        "#444444"
                }
                radius: 4
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 12
            }

            onClicked: digitClicked("6")
        }

        Button
        {
            id: button1
            x: 4
            y: 84
            width: 36
            height: 36
            text: translationsManager.translationTrigger + qsTr("1")

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#444444" : "#888888"
                    else
                        "#444444"
                }
                radius: 4
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 12
            }

            onClicked: digitClicked("1")
        }

        Button
        {
            id: button2
            x: 44
            y: 84
            width: 36
            height: 36
            text: translationsManager.translationTrigger + qsTr("2")

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#444444" : "#888888"
                    else
                        "#444444"
                }
                radius: 4
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 12
            }

            onClicked: digitClicked("2")
        }

        Button
        {
            id: button3
            x: 84
            y: 84
            width: 36
            height: 36
            text: translationsManager.translationTrigger + qsTr("3")

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#444444" : "#888888"
                    else
                        "#444444"
                }
                radius: 4
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 12
            }

            onClicked: digitClicked("3")
        }

        Button
        {
            id: button_minus
            x: 4
            y: 124
            width: 36
            height: 36
            text: calcWidget.minusButtonText

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#444444" : "#666666"
                    else
                        "#444444"
                }
                radius: 4
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 12
            }

            onClicked: digitClicked(button_minus.text)
        }

        Button
        {
            id: button0
            x: 44
            y: 124
            width: 36
            height: 36
            text: translationsManager.translationTrigger + qsTr("0")

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#444444" : "#888888"
                    else
                        "#444444"
                }
                radius: 4
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 12
            }

            onClicked: digitClicked("0")
        }

        Button
        {
            id: button_plus
            x: 84
            y: 124
            width: 36
            height: 36
            text: translationsManager.translationTrigger + qsTr("+")

            background: Rectangle
            {
                color:
                {
                    if(parent.enabled)
                        parent.pressed ? "#444444" : "#666666"
                    else
                        "#444444"
                }
                radius: 4
            }

            contentItem: Text
            {
                color: parent.enabled ? "#ffffff" : "#777777"
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 12
            }

            onClicked: digitClicked("+")
        }
    }

}

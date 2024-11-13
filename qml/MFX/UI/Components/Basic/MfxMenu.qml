import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Menu
{
    width: 100

    background: Rectangle
    {
        color: "#222222"
        radius: 2
    }

    delegate: MenuItem
    {
        id: menuItem
        implicitWidth: 100
        implicitHeight: 28

        arrow: Canvas
        {
            x: parent.width - width + 6
            y: -5
            implicitWidth: 38
            implicitHeight: 38
            visible: menuItem.subMenu
            onPaint: {
                var ctx = getContext("2d")
                ctx.fillStyle = menuItem.highlighted ? "#ffffff" : "#777777"
                ctx.moveTo(15, 15)
                ctx.lineTo(width - 15, height / 2)
                ctx.lineTo(15, height - 15)
                ctx.closePath()
                ctx.fill()
            }
        }

        contentItem: Text
        {
            text: menuItem.text
            font: menuItem.font
            opacity: enabled ? 1.0 : 0.3
            color: menuItem.highlighted ? "#ffffff" : "#777777"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle
        {
            implicitWidth: 200
            implicitHeight: 40
            opacity: enabled ? 1 : 0.3
            color: menuItem.highlighted ? "#333333" : "transparent"
        }
    }
}

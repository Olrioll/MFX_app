import QtQuick 2.0

MouseArea
{
    property string image: "qrc:/zoom"
    property alias cursorImage: cursorImage
    property int pressedX
    property int pressedY
    property bool oddEvent
    property bool isPressed

    signal movedOnX(int dx)
    signal movedOnY(int dy)

    Image
    {
        id: cursorImage
        source: image
        x: mouseX
        y: mouseY
        visible: false
    }

    onEntered:
    {
        cursorShape = Qt.BlankCursor
        cursorImage.visible = true
    }

    onExited:
    {
        if(!isPressed)
        {
            cursorImage.visible = false
            cursorShape = Qt.ArrowCursor
        }
    }

    onPressed:
    {
        isPressed = true
        pressedX = mouseX
        pressedY = mouseY
        oddEvent = true
    }

    onPositionChanged:
    {
        if(mouse.buttons)
        {
            applicationWindow.isMouseCursorVisible = false

            if(mouse.buttons === Qt.LeftButton)
            {
                let dx = mouseX - pressedX
                let dy = mouseY - pressedY
                if(oddEvent)
                {
                    oddEvent = false
                    cursorManager.moveCursor(-dx, -dy)
                    if(dx)
                        movedOnX(dx)
                    if(dy)
                        movedOnY(dy)
                }

                else
                    oddEvent = true
            }
        }

        else
        {
            cursorImage.x = mouseX
            cursorImage.y = mouseY
        }
    }

    onReleased:
    {
        isPressed = false
        applicationWindow.isMouseCursorVisible = true
    }
}

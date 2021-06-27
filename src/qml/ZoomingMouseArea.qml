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
    signal moved(int dx, int dy)

    Image
    {
        id: cursorImage
        source: image
        x: mouseX - 8
        y: mouseY - 8
        visible: false
    }

    onEntered:
    {
        if(!isPressed)
        {
            applicationWindow.isMouseCursorVisible = false
            cursorShape = Qt.BlankCursor
            cursorImage.x = mouseX
            cursorImage.y = mouseY
            cursorImage.visible = true
        }
    }

    onExited:
    {
        if(!isPressed)
        {
            cursorImage.visible = false
            applicationWindow.isMouseCursorVisible = true
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

            cursorShape = Qt.BlankCursor
            if(mouse.buttons === Qt.LeftButton)
            {
                let dx = mouseX - pressedX
                let dy = mouseY - pressedY
                if(oddEvent)
                {
                    oddEvent = false
                    cursorManager.moveCursor(-dx, -dy)

                    moved(dx, dy)

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

import QtQuick 2.0

MouseArea
{
    property var cursor: Qt.ArrowCursor
    property int pressedX
    property int pressedY
    property int dx
    property int dX
    property int dy
    property int dY
    property bool wasPressedAndMoved: false

    cursorShape: applicationWindow.isMouseCursorVisible ? cursor : Qt.BlankCursor

    onPressed:
    {
        pressedX = mouseX
        pressedY = mouseY
        cursorManager.saveLastPos()
    }

    onPositionChanged:
    {
        dx = mouseX - pressedX
        dy = mouseY - pressedY
        dX = cursorManager.dx()
        dY = cursorManager.dy()

        if(mouse.buttons)
        {
            wasPressedAndMoved = true
        }
    }

    onReleased:
    {
        dX = 0
        wasPressedAndMoved = false
    }
}

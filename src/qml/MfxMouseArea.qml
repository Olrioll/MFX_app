import QtQuick 2.0

MouseArea
{
    property var cursor: Qt.ArrowCursor
    property int pressedX
    property int pressedY
    property int dx
    property int dy
    property int dX: 0
    property int dY: 0
    property int xAcc: 0
    property int yAcc: 0
    property bool wasPressedAndMoved: false

    cursorShape: applicationWindow.isMouseCursorVisible ? cursor : Qt.BlankCursor

    onPressed:
    {
        wasPressedAndMoved = false
        pressedX = mouseX
        pressedY = mouseY
        xAcc = 0
        yAcc = 0
        cursorManager.saveLastPos()
    }

    onPositionChanged:
    {
        dx = mouseX - pressedX
        dy = mouseY - pressedY
        dX = cursorManager.dx()
        dY = cursorManager.dy()
        xAcc += dX
        yAcc += dY

        cursorManager.saveLastPos()

        if(mouse.buttons && !wasPressedAndMoved)
        {
            wasPressedAndMoved = true
        }
    }

    onReleased:
    {
        dX = 0
        dY = 0
    }
}

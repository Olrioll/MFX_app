import QtQuick 2.15

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
    property bool allwaysHide: true
    acceptedButtons:Qt.AllButtons

    cursorShape: applicationWindow.isMouseCursorVisible ? cursor : Qt.BlankCursor

    onPressed:
    {
        if(allwaysHide){  applicationWindow.isMouseCursorVisible = false}

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
        if(allwaysHide){  applicationWindow.isMouseCursorVisible = true}

        dX = 0
        dY = 0
    }
}

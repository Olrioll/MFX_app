import QtQuick 2.0

MouseArea
{
    property var cursor: Qt.ArrowCursor
    property int pressedX
    property int pressedY
    property bool wasPressedAndMoved: false

    cursorShape: applicationWindow.isMouseCursorVisible ? cursor : Qt.BlankCursor

    onPressed:
    {
        pressedX = mouseX
        pressedY = mouseY
    }

    onPositionChanged:
    {
        if(mouse.buttons)
        {
            wasPressedAndMoved = true
        }
    }

    onReleased:
    {
        wasPressedAndMoved = false
    }
}

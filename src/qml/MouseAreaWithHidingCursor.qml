import QtQuick 2.0

MouseArea
{
    property var cursor: Qt.ArrowCursor

    cursorShape: applicationWindow.isMouseCursorVisible ? cursor : Qt.BlankCursor

    onPositionChanged:
    {
        if(mouse.buttons)
            applicationWindow.isMouseCursorVisible = false
    }

    onReleased:
    {
        applicationWindow.isMouseCursorVisible = true
    }
}

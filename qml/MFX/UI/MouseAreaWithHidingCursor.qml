import QtQuick 2.15

MouseArea
{
    property var cursor: Qt.ArrowCursor

    cursorShape: applicationWindow.isMouseCursorVisible ? cursor : Qt.BlankCursor

    onPositionChanged:
    {
        if(mouse.buttons)
//            cursorManager.hideCursor()
            applicationWindow.isMouseCursorVisible = false
    }

    onReleased:
    {
//        cursorManager.showCursor()
        applicationWindow.isMouseCursorVisible = true
    }
}

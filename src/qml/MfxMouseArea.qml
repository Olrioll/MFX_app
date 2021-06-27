import QtQuick 2.0

MouseArea
{
    property var cursor: Qt.ArrowCursor
    property int pressedX
    property int pressedY
    property bool wasPressedAndMoved: false

    property var draggedItem: null
    property bool dragOnX: false
    property bool dragOnY: false
    property int draggedItemMinX
    property int draggedItemMaxX
    property int draggedItemMinY
    property int draggedItemMaxY

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

            if(draggedItem)
            {
                if(dragOnX)
                {
                    let currX = draggedItem.x + (mouseX - pressedX)

                    if(currX < draggedItemMinX)
                        draggedItem.x = draggedItemMinX

                    else if(currX + draggedItem.width > draggedItemMaxX)
                        draggedItem.x = draggedItemMaxX - draggedItem.width

                    else
                        draggedItem.x = currX
                }

                if(dragOnY)
                {
                    let currY = draggedItem.y + (mouseY - pressedY)

                    if(currY < draggedItemMinY)
                        draggedItem.y = draggedItemMinY

                    else if(currY + draggedItem.height > draggedItemMaxY)
                        draggedItem.y = draggedItemMaxY - draggedItem.height

                    else
                        draggedItem.y = currY
                }
            }
        }
    }

    onReleased:
    {
        wasPressedAndMoved = false
    }
}

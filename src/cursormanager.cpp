#include "cursormanager.h"

CursorManager::CursorManager(QObject *parent) : QObject(parent)
{

}

void CursorManager::moveCursor(int dx, int dy)
{
    auto pos = QCursor::pos();
    QCursor::setPos(pos.x() + dx, pos.y() + dy);
}

#include "cursormanager.h"
#include <QApplication>
#include <QDebug>

CursorManager::CursorManager(QObject *parent) : QObject(parent)
{

}

void CursorManager::moveCursor(int dx, int dy)
{
    auto pos = QCursor::pos();
    QCursor::setPos(pos.x() + dx, pos.y() + dy);
}

void CursorManager::hideCursor()
{
    qApp->setOverrideCursor(Qt::BlankCursor);

}

void CursorManager::showCursor()
{
    qApp->restoreOverrideCursor();
}

QPoint CursorManager::cursorPos() const
{
    return QCursor::pos();
}

void CursorManager::saveLastPos()
{
    _lastPos = QCursor::pos();
}

void CursorManager::moveToLastPos()
{
    QCursor::setPos(_lastPos);
}

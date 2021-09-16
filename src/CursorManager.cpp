#include "CursorManager.h"

#include <QApplication>

CursorManager::CursorManager(QObject* parent) : QObject(parent)
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

int CursorManager::dx() const
{
    return QCursor::pos().x() - _lastPos.x();
}

int CursorManager::dy() const
{
    return QCursor::pos().y() - _lastPos.y();
}

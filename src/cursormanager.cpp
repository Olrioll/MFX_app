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

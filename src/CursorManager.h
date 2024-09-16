#ifndef CURSORMANAGER_H
#define CURSORMANAGER_H

#include <QObject>
#include <QCursor>

class CursorManager : public QObject
{
    Q_OBJECT

public:
    explicit CursorManager(QObject *parent = nullptr);

public slots:

    void moveCursor(int dx, int dy);
    void hideCursor();
    void showCursor();
    void setCursorPosX(QPoint pos);
    void setCursorPosXY(int x, int y);

    QPoint cursorPos() const;
    void saveLastPos();
    void moveToLastPos();
    int dx() const;
    int dy() const;

signals:

private:

    QPoint _lastPos;

};

#endif // CURSORMANAGER_H

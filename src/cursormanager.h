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

    QPoint cursorPos() const;
    void saveLastPos();
    void moveToLastPos();

signals:

private:

    QPoint _lastPos;

};

#endif // CURSORMANAGER_H

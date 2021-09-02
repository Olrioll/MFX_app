#ifndef PATCHPOSITIONCONTROLLER_H
#define PATCHPOSITIONCONTROLLER_H

#include <QDebug>

class PatchPositionController : public QObject
{
    Q_OBJECT
public:
    explicit PatchPositionController(QObject *parent = nullptr);
    Q_PROPERTY(int playerPosition MEMBER _playerPosition WRITE setPlayerPosition)

public slots:
    void onSetPatch(QString cue, int num, int pos);

private:
    void setPlayerPosition(int playerPosition);
    int _playerPosition;
    QList<int> _positions;
};

#endif // PATCHPOSITIONCONTROLLER_H

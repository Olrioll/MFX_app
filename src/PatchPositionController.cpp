#include "PatchPositionController.h"

PatchPositionController::PatchPositionController(QObject *parent) : QObject(parent)
{
}

void PatchPositionController::onSetPatch(QString cue, int num, int pos)
{
    static QMap<QString, int> positions;
    positions.insert(QString("%1-%2").arg(cue).arg(num), pos);
    _positions = positions.values();
}

void PatchPositionController::setPlayerPosition(int playerPosition)
{
    foreach(int pos, _positions) {
        if(pos == playerPosition) {
            qDebug() << "fire!";
        }
    }
}

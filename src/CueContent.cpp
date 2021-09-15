#include "CueContent.h"

CueContent::CueContent(QObject *parent) : QObject(parent)
{
    connect(this, &CueContent::activeChanged, this, &CueContent::onActiveChanged);
}

void CueContent::onActiveChanged(bool active)
{
    qDebug() << "CueContent::onActiveChanged:" << m_device << active;
}

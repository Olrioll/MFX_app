#include "Pattern.h"

Pattern::Pattern(QObject* parent)
    : QObject(parent)
{
    m_operations = new QQmlObjectListModel<Operation>(this);
    setUuid(QUuid::createUuid());
}

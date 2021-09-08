#include "Pattern.h"

Pattern::Pattern(QObject* parent)
    : QObject(parent)
{
    setUuid(QUuid::createUuid());
}

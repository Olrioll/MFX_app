#include "ShotPattern.h"

ShotPattern::ShotPattern( QObject* parent /*= nullptr*/ )
    : Pattern( parent )
{
}

ShotPattern::ShotPattern( const QVariantMap& properties, QObject* parent /*= nullptr*/ )
    : Pattern( parent )
{
    setProperties( properties );
}

void ShotPattern::makeName()
{
    QString name = "C";
    name.append( QString::number( seq() ) );

    setName( name );
}

QVariantMap ShotPattern::getProperties() const
{
    QVariantMap properties = Pattern::getProperties();
    properties["shotTime"] = shotTime();

    return properties;
}

void ShotPattern::setProperties( const QVariantMap& properties )
{
    Pattern::setProperties( properties );

    setShotTime( properties.value( "shotTime" ).toULongLong() );
}
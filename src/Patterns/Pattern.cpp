#include "Pattern.h"

Pattern::Pattern(QObject* parent)
    : QObject(parent)
{
    m_operations = new QQmlObjectListModel<Operation>(this);
}

Pattern::Pattern( const QVariantMap& properties, QObject* parent /*= nullptr*/ )
    : QObject( parent )
{
    m_operations = new QQmlObjectListModel<Operation>( this );
    setProperties( properties );
}

void Pattern::makeName()
{
    QString name = "?";

    if( type() == PatternType::Shot )
        name = "C";

    name.append( QString::number( seq() ) );

    setName( name );
}

QVariantMap Pattern::getProperties() const
{
    QVariantMap properties;
    properties["seq"] = seq();
    properties["name"] = name();
    properties["type"] = PatternType::toString( type() );
    properties["prefireDuration"] = prefireDuration();

    return properties;
}

void Pattern::setProperties( const QVariantMap& properties )
{
    setSeq( properties.value( "seq" ).toInt() );
    setName( properties.value( "name" ).toString() );
    setPrefireDuration( properties.value( "prefireDuration" ).toULongLong() );
    setType( typeFromString( properties.value( "type" ).toString() ) );
}

PatternType::Type Pattern::typeFromString( const QString& str )
{
    if( str == "Sequences" )
        return PatternType::Sequences;
    else if( str == "Shot" )
        return PatternType::Shot;

    return PatternType::Unknown;
}
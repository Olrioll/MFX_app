#include "Pattern.h"

Pattern::Pattern(QObject* parent)
    : QObject(parent)
{
    m_operations = new QQmlObjectListModel<Operation>(this);
    //setUuid(QUuid::createUuid());
    auto s = name();
}

Pattern::Pattern( const QVariantMap& properties, QObject* parent /*= nullptr*/ )
    : QObject( parent )
{
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

    const QString type = properties.value( "type" ).toString();

    if( type == "Shot" )
        setType( PatternType::Shot );
    else
        setType( PatternType::Unknown );
}
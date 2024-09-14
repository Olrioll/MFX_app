#include <QJsonDocument>

#include "CustomPatternStore.h"

constexpr char CUSTOM_PATTERNS[] = "custom_patterns.txt";
constexpr char CUSTOM_PATTERNS_VER[] = "1";

CustomPatternStore::CustomPatternStore( SettingsManager& settngs, QObject* parent ) : mSettings( settngs ), QObject( parent )
{
    m_Patterns.reset( new PatternSourceModel() );
}

void CustomPatternStore::load()
{
    clear();

    QFile jsonFile = QDir( mSettings.workDirectory() ).filePath( CUSTOM_PATTERNS );

    if( !jsonFile.open( QIODevice::ReadOnly | QIODevice::Text ) )
    {
        qWarning() << "file " << jsonFile << " not found";
        return;
    }

    fromJsonObject( QJsonDocument::fromJson( jsonFile.readAll() ).object() );

    QString ver = JsonSerializable::property( "version" ).toString();

    if( ver != CUSTOM_PATTERNS_VER )
    {
        qWarning() << "Wrong version:" << ver;
        clear();
        return;
    }

    for( const auto& child : getChild( "Patterns" )->namedChildren() )
    {
        Pattern* pattern = new Pattern( child->properties(), this );

        if( pattern->type() == PatternType::Unknown )
            continue;

        for( const auto& oper : child->getChild( "Operations" )->listedChildren() )
        {
            Operation* op = new Operation( this );
            op->setProperties( oper->properties() );

            pattern->operations()->append( op );
        }

        m_Patterns->append( pattern );
    }
}

void CustomPatternStore::save()
{
    QFile jsonFile = QDir( mSettings.workDirectory() ).filePath( CUSTOM_PATTERNS );

    if( !jsonFile.open( QIODevice::WriteOnly | QIODevice::Truncate ) )
    {
        qWarning() << "file " << jsonFile << " not found";
        return;
    }

    JsonSerializable::setProperty( "version", CUSTOM_PATTERNS_VER );

    QJsonDocument doc;
    doc.setObject( toJsonObject() );

    jsonFile.write( doc.toJson() );
}

void CustomPatternStore::clear()
{
    JsonSerializable::clear();
    m_Patterns->clear();
}

Pattern* CustomPatternStore::getPattern( const QString& name ) const
{
    for( const auto pattern : m_Patterns->toList() )
        if( pattern->name() == name )
            return pattern;

    return nullptr;
}

void CustomPatternStore::addPattern( Pattern* pattern )
{
    m_Patterns->append( pattern );

    if( getChild( "Patterns" ) == nullptr )
        addChild( "Patterns" );

    auto patterns = getChild( "Patterns" );

    patterns->addChild( pattern->name() );
    patterns->getChild( pattern->name() )->setProperties( pattern->getProperties() );
    patterns->getChild( pattern->name() )->addChild( "Operations" );

    auto operations = patterns->getChild( pattern->name() )->getChild( "Operations" );

    for( const Operation* op : pattern->operations()->toList() )
    {
        operations->addChild();
        operations->listedChildren().last()->setProperties( op->getProperties() );
    }

    save();
}

void CustomPatternStore::deletePattern( const QString& name )
{
    for( auto pattern : m_Patterns->toList() )
    {
        if( pattern->name() == name )
        {
            m_Patterns->remove( pattern );
            break;
        }
    }

    getChild( "Patterns" )->removeChild( name );
    save();
}

ulong CustomPatternStore::getMaxSeq( PatternType::Type type ) const
{
    ulong max_seq = 0;

    for( const auto pattern : m_Patterns->toList() )
        if( pattern->type() == type && pattern->seq() > max_seq )
            max_seq = pattern->seq();

    return max_seq;
}
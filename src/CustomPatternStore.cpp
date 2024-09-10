#include <QJsonDocument>

#include "CustomPatternStore.h"

constexpr char CUSTOM_PATTERNS[] = "custom_patterns.txt";
constexpr char CUSTOM_PATTERNS_VER[] = "1";

CustomPatternStore::CustomPatternStore( SettingsManager& settngs ) : mSettings( settngs )
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

    QString ver = property( "version" ).toString();

    if( ver != CUSTOM_PATTERNS_VER )
    {
        qWarning() << "Wrong version:" << ver;
        clear();
        return;
    }

    for( const auto& child : getChild( "Patterns" )->namedChildren() )
    {
        std::unique_ptr<Pattern> pattern = std::make_unique<Pattern>( child->properties() );

        if( pattern->type() != PatternType::Unknown )
            m_Patterns->append( pattern.release() );
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

    setProperty( "version", CUSTOM_PATTERNS_VER );

    QJsonDocument doc;
    doc.setObject( toJsonObject() );

    jsonFile.write( doc.toJson() );
}

void CustomPatternStore::clear()
{
    JsonSerializable::clear();
    m_Patterns->clear();
}

const Pattern* CustomPatternStore::getPattern( const QString& name ) const
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

    getChild( "Patterns" )->addChild( pattern->name() );
    getChild( "Patterns" )->getChild( pattern->name() )->setProperties( pattern->getProperties() );
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
#include <QtCore/QDir>
#include <QtCore/QFile>
#include <QtCore/QRandomGenerator>

#include "PatternManager.h"
#include "PatternFilteringModel.h"
#include "CustomPatternStore.h"

namespace
{
    constexpr char patternsFileNameTemplate[] = "pattern*.txt";
}

PatternManager::PatternManager(SettingsManager& settingsManager, QObject* parent)
    : QObject(parent)
    , m_settingsManager(settingsManager)
{
    m_patterns = new QQmlObjectListModel<Pattern>(this);
    m_CustomPatterns = new CustomPatternStore( m_settingsManager, this );

    m_patternsFiltered = new PatternFilteringModel(*m_patterns, PatternType::Sequences, this);
    m_patternsShotFiltered = new PatternFilteringModel( *m_CustomPatterns->getSourceModel(), PatternType::Shot, this );

    reloadPatterns();
}

PatternManager::~PatternManager()
{
    m_patterns->clear();
    m_patterns->deleteLater();
    m_patternsFiltered->deleteLater();
}

void PatternManager::qmlRegister()
{
    PatternType::registerToQml( "MFX.Enums", 1, 0 );
    qRegisterMetaType<Pattern*>( "Pattern*" );
}

void PatternManager::currentPatternChangeRequest( PatternType::Type type, const QString& patternName )
{
    qDebug() << PatternType::toString( type ) << patternName;

    if( type == PatternType::Sequences )
        setSelectedPatternName( patternName );
    else if( type == PatternType::Shot )
        setSelectedShotPatternName( patternName );
}

void PatternManager::cleanPatternSelectionRequest( PatternType::Type type )
{
    currentPatternChangeRequest( type, "" );
}

void PatternManager::reloadPatterns()
{
    qDebug();

    m_patterns->clear();
    m_prefire.clear();

    initPatterns();
    initCustomPatterns();
}

void PatternManager::initPatterns()
{
    QDir workDir(m_settingsManager.workDirectory());
    auto fileNamesList = workDir.entryList({ ::patternsFileNameTemplate }, QDir::Files);

    for (auto& fileName : fileNamesList)
    {
        QFile file(m_settingsManager.workDirectory() + "/" + fileName);

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
            return;

        QStringList actionLines;

        while (!file.atEnd())
        {
            auto currLine = file.readLine();

            if (!currLine.startsWith("#"))
                actionLines.push_back(currLine);
        }

        QList<QStringList> rawActions;

        QStringList currRawAction;
        for (auto& line : actionLines)
        {
            if (line.startsWith("A"))
            {
                if (currRawAction.size())
                    rawActions.push_back(currRawAction);

                currRawAction.clear();
            }

            currRawAction.push_back(line);
        }

        if (currRawAction.size())
            rawActions.push_back(currRawAction);

        auto setOperationData = []( const QStringList& actions, Operation* operation )
        {
            const QString& durationStr = actions.at( 0 );
            int duration = durationStr.right( 2 ).toInt() * 10;
            bool skipIfOutOfAngles = durationStr.length() < 3 || durationStr[0] != "1";

            operation->setDuration( duration );
            operation->setSkipOutOfAngles( skipIfOutOfAngles );
            operation->setAngle( actions.at( 1 ).toInt() );
            operation->setVelocity( actions.at( 2 ).toInt() );

            int activeCode = actions.at( 3 ).toInt();
            operation->setActive( activeCode == 255 ? true : false );
        };

        for (const auto& rawAction : rawActions)
        {
            QString name = rawAction.at( 0 );
            name.remove( ',' ).chop( 1 );

            auto pattern = new Pattern(this);
            pattern->setName( name );

            auto actions = rawAction.at( 1 ).split( ',' );

            auto operation = new Operation( this );
            setOperationData( actions, operation );

            pattern->operations()->append(operation);

            int prefire = operation->duration();

            for (int i = 2; i < rawAction.size(); i++)
            {
                actions = rawAction.at( i ).split( ',' );

                operation = new Operation( this );
                setOperationData( actions, operation );

                pattern->operations()->append(operation);
            }

            pattern->setType(PatternType::Sequences);
            pattern->setPrefireDuration(prefire);
            m_prefire.insert(name, prefire);
            m_patterns->append(pattern);
        }
    }
}

void PatternManager::initCustomPatterns()
{
    m_CustomPatterns->load();
}

PatternFilteringModel* PatternManager::patternsFiltered() const
{
    return m_patternsFiltered;
}

PatternFilteringModel* PatternManager::patternsShotFiltered() const
{
    return m_patternsShotFiltered;
}

Pattern* PatternManager::patternByName(const QString &name) const
{
    //qDebug() << name;

    for(auto * pattern : m_patterns->toList())
        if(name.compare(pattern->name(), Qt::CaseInsensitive) == 0)
            return pattern;

    return m_CustomPatterns->getPattern( name );
}

void PatternManager::addPattern( Pattern* pattern, PatternType::Type type, qulonglong prefire, std::list<Operation*> operations )
{
    pattern->setType( type );
    pattern->setSeq( m_CustomPatterns->getMaxSeq( type ) + 1 );
    pattern->setPrefireDuration( prefire );
    pattern->makeName();

    for( Operation* op : operations )
        pattern->operations()->append( op );

    m_CustomPatterns->addPattern( pattern );
}

void PatternManager::addShotPattern( qulonglong prefire, qulonglong time )
{
    ShotPattern* pattern = new ShotPattern();
    pattern->setShotTime( time );

    addPattern( pattern, PatternType::Shot, prefire, {} );
}

void PatternManager::editShotPattern( const QString& name, qulonglong prefire, qulonglong time )
{
    Pattern* pattern = patternByName( name );
    if( !pattern )
        return;

    QVariantMap properties = pattern->getProperties();
    properties["prefireDuration"] = prefire;
    properties["shotTime"] = time;

    pattern->setProperties( properties );
    m_CustomPatterns->editPattern( pattern );
}

void PatternManager::deletePattern( const QString& name )
{
    if( name.isEmpty() )
        return;

    PatternType::Type type = PatternType::Unknown;

    const Pattern* pattern = m_CustomPatterns->getPattern( name );
    if( pattern )
        type = pattern->type();

    m_CustomPatterns->deletePattern( name );
}
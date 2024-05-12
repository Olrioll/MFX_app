#include "PatternManager.h"

#include <QtCore/QDir>
#include <QtCore/QFile>
#include <QtCore/QRandomGenerator>

#include "PatternFilteringModel.h"

namespace {
static constexpr char patternsFileNameTemplate[] = "pattern*.txt";
}

PatternManager::PatternManager(SettingsManager& settingsManager, QObject* parent)
    : QObject(parent)
    , m_settingsManager(settingsManager)
{
    setSelectedPatternUuid(QUuid::createUuid());
    m_patterns = new QQmlObjectListModel<Pattern>(this);
    m_patternsFiltered = new PatternFilteringModel(*m_patterns, this);

    initConnections();
}

PatternManager::~PatternManager()
{
    m_patterns->clear();
    m_patterns->deleteLater();
    m_patternsFiltered->deleteLater();
}

void PatternManager::initConnections()
{
}

void PatternManager::qmlRegister()
{
    PatternType::registerToQml("MFX.Models", 1, 0);
    qRegisterMetaType<Pattern*>("Pattern*");
}

const QMap<QString, int>& PatternManager::getPrefire()
{
    return m_prefire;
}

void PatternManager::currentPatternChangeRequest(const QUuid &patternUuid)
{
    setSelectedPatternUuid(patternUuid);
}

void PatternManager::cleanPatternSelectionRequest()
{
    //TODO переделать на указатель на Pattern
    setSelectedPatternUuid(QUuid::createUuid());
}

void PatternManager::initPatterns()
{
    QDir workDir(m_settingsManager.workDirectory());
    auto fileNamesList = workDir.entryList({ ::patternsFileNameTemplate }, QDir::Files);
    m_prefire.clear();
    for (auto& fileName : fileNamesList) {
        QFile file(m_settingsManager.workDirectory() + "/" + fileName);

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            return;
        }

        QStringList actionLines;
        QStringList controlLines;

        while (!file.atEnd()) {
            auto currLine = file.readLine();

            if (currLine.startsWith("#")) {
                controlLines.push_back(currLine);
            } else {
                actionLines.push_back(currLine);
            }
        }

        QList<QStringList> rawActions;

        QStringList currRawAction;
        for (auto& line : actionLines) {
            if (line.startsWith("A")) {
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

        m_patterns->clear();
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
            //int duration = prefire;

            for (int i = 2; i < rawAction.size(); i++)
            {
                actions = rawAction.at( i ).split( ',' );

                operation = new Operation( this );
                setOperationData( actions, operation );

                pattern->operations()->append(operation);
                //duration += operation->duration();
            }

            //TODO типы паттернов пока не реализованы, поэтому для всех делаем общий стандарт - Sequential
            pattern->setType(PatternType::Sequential);
            //pattern->setDuration(duration);
            pattern->setPrefireDurarion(prefire);
            m_prefire.insert(name, prefire);
            m_patterns->append(pattern);
        }
    }
}

PatternFilteringModel* PatternManager::patternsFiltered() const
{
    return m_patternsFiltered;
}

Pattern *PatternManager::patternById(const QUuid &id) const
{
    for(auto * pattern : m_patterns->toList()) {
        if(id == pattern->uuid()) {
            return pattern;
        }
    }

    return nullptr;
}

/*
qulonglong PatternManager::maxPatternDuration(const QStringList &list) const
{
    qulonglong out = 0;
    for(auto * pattern : m_patterns->toList()) {
        for(auto &name: list)
            if(name.compare(pattern->name(), Qt::CaseInsensitive) == 0) {
                out = qMax<qulonglong>(pattern->duration() + pattern->prefireDuration(),out);
            }
    }
    return out;
}*/

Pattern *PatternManager::patternByName(const QString &name) const
{
    for(auto * pattern : m_patterns->toList())
        if(name.compare(pattern->name(), Qt::CaseInsensitive) == 0)
            return pattern;

    return nullptr;
}

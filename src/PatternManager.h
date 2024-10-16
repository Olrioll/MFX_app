#pragma once

#include <QtCore/QObject>

#include "QQmlObjectListModel.h"

#include "Patterns/Pattern.h"
#include "Patterns/ShotPattern.h"
#include "SettingsManager.h"


class PatternFilteringModel;
class ShotPatternFilteringModel;
class CustomPatternStore;

class PatternManager : public QObject
{
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(Pattern, patterns)
    QSM_WRITABLE_CSTREF_PROPERTY(QString, selectedPatternName, SelectedPatternName)
    QSM_WRITABLE_CSTREF_PROPERTY(QString, selectedShotPatternName, SelectedShotPatternName)
    Q_PROPERTY(PatternFilteringModel* patternsFiltered READ patternsFiltered CONSTANT)
    Q_PROPERTY(PatternFilteringModel* patternsShotFiltered READ patternsShotFiltered CONSTANT)
public:
    explicit PatternManager(SettingsManager& settingsManager, QObject* parent = nullptr);
    ~PatternManager();

    static void qmlRegister();

    Q_INVOKABLE void currentPatternChangeRequest( PatternType::Type type, const QString& patternName);
    Q_INVOKABLE void cleanPatternSelectionRequest( PatternType::Type type );

    void reloadPatterns();

    PatternFilteringModel* patternsFiltered() const;
    PatternFilteringModel* patternsShotFiltered() const;

    Q_INVOKABLE /*гадский qml не понимает const*/ Pattern* patternByName(const QString& name) const;
    Q_INVOKABLE void addShotPattern( qulonglong prefire, qulonglong time );
    Q_INVOKABLE void editShotPattern( const QString& name, qulonglong prefire, qulonglong time );
    Q_INVOKABLE void deletePattern( const QString& name );

private:
    void initPatterns();
    void initCustomPatterns();
    void addPattern( Pattern* pattern, PatternType::Type type, qulonglong prefire, std::list<Operation*> operations );

private:
    PatternFilteringModel* m_patternsFiltered = nullptr;
    PatternFilteringModel* m_patternsShotFiltered = nullptr;
    SettingsManager& m_settingsManager;
    QMap<QString, int> m_prefire;
    CustomPatternStore* m_CustomPatterns;
};

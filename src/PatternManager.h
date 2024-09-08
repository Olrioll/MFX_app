#pragma once

#include <QtCore/QObject>

#include "QQmlObjectListModel.h"

#include "Pattern.h"
#include "SettingsManager.h"


class PatternFilteringModel;
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

    void initConnections();
    static void qmlRegister();
    const QMap<QString, int>& getPrefire();

    Q_INVOKABLE void currentPatternChangeRequest(const QString& patternName);
    Q_INVOKABLE void cleanPatternSelectionRequest();

    Q_INVOKABLE void currentShotPatternChangeRequest( const QString& patternName );
    Q_INVOKABLE void cleanShotPatternSelectionRequest();

    void reloadPatterns();

    PatternFilteringModel* patternsFiltered() const;
    PatternFilteringModel* patternsShotFiltered() const;
    //Pattern *patternById(const QUuid& id) const;
    //Q_INVOKABLE qulonglong maxPatternDuration(const QStringList &list) const;
    //TODO запрашивается из QML - избавиться впоследствии
    Q_INVOKABLE const Pattern* patternByName(const QString& name) const;
    Q_INVOKABLE void addPattern( PatternType::Type type );
    Q_INVOKABLE void deletePattern( const QString& name );

private:
    void initPatterns();
    void initCustomPatterns();

private:
    PatternFilteringModel* m_patternsFiltered = nullptr;
    PatternFilteringModel* m_patternsShotFiltered = nullptr;
    SettingsManager& m_settingsManager;
    QMap<QString, int> m_prefire;
    std::unique_ptr<CustomPatternStore> m_CustomPatterns;
};

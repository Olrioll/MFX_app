#pragma once

#include <QtCore/QObject>

#include "QQmlObjectListModel.h"

#include "Pattern.h"
#include "SettingsManager.h"

class PatternFilteringModel;

class PatternManager : public QObject {
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(Pattern, patterns)
    QSM_WRITABLE_CSTREF_PROPERTY(QUuid, selectedPatternUuid, SelectedPatternUuid)
    Q_PROPERTY(PatternFilteringModel* patternsFiltered READ patternsFiltered CONSTANT)
public:
    explicit PatternManager(SettingsManager& settingsManager, QObject* parent = nullptr);
    ~PatternManager();

    void initConnections();
    static void qmlRegister();
    const QMap<QString, int>& getPrefire();

    Q_INVOKABLE void currentPatternChangeRequest(const QUuid& patternUuid);
    Q_INVOKABLE void cleanPatternSelectionRequest();

    void initPatterns();
    PatternFilteringModel * patternsFiltered() const;
    Pattern *patternById(const QUuid& id) const;
    //Q_INVOKABLE qulonglong maxPatternDuration(const QStringList &list) const;
    //TODO запрашивается из QML - избавиться впоследствии
    Q_INVOKABLE Pattern *patternByName(const QString& name) const;
private:
    PatternFilteringModel* m_patternsFiltered = nullptr;
    SettingsManager& m_settingsManager;
    QMap<QString,int> m_prefire;
};

#pragma once

#include "JsonSerializable.h"
#include "SettingsManager.h"
#include "Pattern.h"

using PatternSourceModel = QQmlObjectListModel<Pattern>;

class CustomPatternStore : public QObject
                         , public JsonSerializable
{
    Q_OBJECT

public:
    CustomPatternStore( SettingsManager& settngs, QObject* parent );

    void load();
    void save();
    void clear();

    Pattern* getPattern( const QString& name ) const;
    void addPattern( Pattern* pattern );
    void deletePattern( const QString& name );
    ulong getMaxSeq( PatternType::Type type ) const;

    const std::shared_ptr<PatternSourceModel>& getSourceModel() { return m_Patterns; }

private:
    SettingsManager& mSettings;
    std::shared_ptr<PatternSourceModel> m_Patterns;
};
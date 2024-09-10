#pragma once

#include "JsonSerializable.h"
#include "SettingsManager.h"
#include "Pattern.h"

using PatternSourceModel = QQmlObjectListModel<Pattern>;

class CustomPatternStore : public JsonSerializable
{
public:
    CustomPatternStore( SettingsManager& settngs );

    void load();
    void save();
    void clear();

    const Pattern* getPattern( const QString& name ) const;
    void addPattern( Pattern* pattern );
    void deletePattern( const QString& name );
    ulong getMaxSeq( PatternType::Type type ) const;

    const std::shared_ptr<PatternSourceModel>& getSourceModel() { return m_Patterns; }

private:
    SettingsManager& mSettings;
    std::shared_ptr<PatternSourceModel> m_Patterns;
};
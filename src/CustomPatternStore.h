#pragma once

#include "JsonSerializable.h"
#include "SettingsManager.h"
#include "Patterns/Pattern.h"

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
    void editPattern( Pattern* pattern );
    void deletePattern( const QString& name );
    ulong getMaxSeq( PatternType::Type type ) const;

    PatternSourceModel* getSourceModel() { return m_Patterns; }

private:
    SettingsManager& mSettings;
    PatternSourceModel* m_Patterns;
};
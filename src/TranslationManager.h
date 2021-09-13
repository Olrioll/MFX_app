#pragma once

#include <QtCore/QObject>
#include <QtCore/QTranslator>

#include "QQmlObjectListModel.h"
#include <QQmlConstRefPropertyHelpers.h>
#include <QSuperMacros.h>

#include "SettingsManager.h"

class Language;

class TranslationManager : public QObject {
    Q_OBJECT
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, translationTrigger, TranslationTrigger, "")
    QML_OBJMODEL_PROPERTY(Language, languages);
    QSM_READONLY_CSTREF_PROPERTY(QString, currentLocale, CurrentLocale)
public:
    explicit TranslationManager(SettingsManager& settings, QObject* parent = nullptr);

    Q_INVOKABLE void setLanguage(const QString& locale);

    void initLanguages();
private:
    void initConnections();
    bool checkLocaleExists(const QString& locale) const;
    QString systemLocale() const;
    void updateSelected(const QString& locale);
private:
    QTranslator m_translator;
    SettingsManager& m_settings;
    QHash<QString, Language*> m_languageDictionary;
};

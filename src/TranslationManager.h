#pragma once

#include <QtCore/QObject>
#include <QtCore/QTranslator>

#include "QQmlObjectListModel.h"
#include <QQmlConstRefPropertyHelpers.h>
#include <QQmlPtrPropertyHelpers.h>
#include <QSuperMacros.h>

class Language : public QObject {
    Q_OBJECT
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, locale, Locale, "")
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, name, Name, "")
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, icon, Icon, "")
};

class TranslationManager : public QObject {
    Q_OBJECT
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, translationTrigger, TranslationTrigger, "")
    QML_OBJMODEL_PROPERTY(Language, languages);
public:
    explicit TranslationManager(QObject* parent = nullptr);

    Q_INVOKABLE void setLanguage(const QString& locale);

    void initLanguages();

private:
    QTranslator m_translator;

    QHash<QString, Language*> languageDictionary;
};

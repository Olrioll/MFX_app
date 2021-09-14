#include "TranslationManager.h"

#include <QtCore/QDir>
#include <QtCore/QFileInfo>
#include <QtGui/QGuiApplication>

#include "Language.h"

namespace {
static const QString translationFileNamePattern = QStringLiteral("lang_");
static const QString defaultLocale = QStringLiteral("ru");
static const QString localeSettingKey = QStringLiteral("locale");
}

TranslationManager::TranslationManager(SettingsManager& settings, QObject* parent)
    : QObject(parent)
    , m_languages(new QQmlObjectListModel<Language>(this))
    , m_settings(settings)
{
    auto* english = new Language();
    english->setName("English");
    english->setLocale("en");
    english->setIcon("qrc:/icons/preferences/preferences_language_settings_english_flag_icon.svg");
    m_languageDictionary.insert("en", english);
    auto* russian = new Language();
    russian->setName("Русский");
    russian->setLocale("ru");
    russian->setIcon("qrc:/icons/preferences/preferences_language_settings_russian_flag_icon.svg");
    m_languageDictionary.insert("ru", russian);

    initLanguages();
    initConnections();

    const QString savedLocale = m_settings.value(localeSettingKey).toString();

    if(savedLocale.length() > 0 && checkLocaleExists(savedLocale)) {
        setLanguage(savedLocale);
    } else {
        setLanguage(defaultLocale);
    }
}

void TranslationManager::initConnections()
{
    connect(this, &TranslationManager::currentLocaleChanged, [=](const QString& newLocale){
        m_settings.setValue(localeSettingKey, newLocale);
    });

    connect(this, &TranslationManager::currentLocaleChanged, this, &TranslationManager::updateSelected);
}

bool TranslationManager::checkLocaleExists(const QString &locale) const
{
    bool languageLocaleExists = false;

    for (auto* language : m_languages->toList()) {
        if (language->locale().compare(locale) == 0) {
            languageLocaleExists = true;
            break;
        }
    }

    return languageLocaleExists;
}

QString TranslationManager::systemLocale() const
{
    auto defaultLocale = QLocale::system().name();
    defaultLocale.truncate(defaultLocale.lastIndexOf('_'));
    return defaultLocale;
}

void TranslationManager::updateSelected(const QString &locale)
{
    for(auto * language : m_languages->toList()) {
        language->setSelected(language->locale().compare(locale) == 0);
    }
}

void TranslationManager::setLanguage(const QString& locale)
{
    if (checkLocaleExists(locale)) {
        const QString localePath = QString(":/translations/lang_%1.qm").arg(locale);
        bool translationLoaded = m_translator.load(localePath);
        if (translationLoaded) {
            qApp->installTranslator(&m_translator);

            setCurrentLocale(locale);

            emit translationTriggerChanged("");
        } else {
            qWarning() << "Tranlsations: was not able to load translation file: " << localePath;
        }
    } else {
        qWarning() << "Translations: can't find the selected language in preloaded locales";
    }
}

void TranslationManager::initLanguages()
{
    const QString translationsPath(":/translations/");

    QDir translationsDir(translationsPath);
    auto translationFiles = translationsDir.entryList(QStringList { "*.qm" }, QDir::Files | QDir::NoDotAndDotDot | QDir::Readable);

    if (translationFiles.length() > 0) {
        QRegExp translationFileNameRegexp(translationFileNamePattern + "(.+)\\.qm");
        for (const auto& translationFileName : translationFiles) {
            if (translationFileNameRegexp.indexIn(translationFileName) >= 0) {
                const auto languageLocale = translationFileNameRegexp.cap(1);
                if (m_languageDictionary.contains(languageLocale)) {
                    m_languages->append(m_languageDictionary.value(languageLocale));
                }
            }
        }
    } else {
        qWarning() << "Translations: can not find any translation file";
    }
}

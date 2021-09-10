#include "TranslationManager.h"

#include <QtCore/QDir>
#include <QtCore/QFileInfo>
#include <QtGui/QGuiApplication>

namespace {
static const QString translationFileNamePattern = QStringLiteral("lang_");
}

TranslationManager::TranslationManager(QObject* parent)
    : QObject(parent)
    , m_languages(new QQmlObjectListModel<Language>(this))
{
    auto * english = new Language();
    english->setName("English");
    english->setLocale("en");
    english->setIcon("qrc:/icons/preferences/preferences_language_settings_english_flag_icon.svg");
    languageDictionary.insert("en", english);
    auto * russian = new Language();
    russian->setName("Русский");
    russian->setLocale("ru");
    russian->setIcon("qrc:/icons/preferences/preferences_language_settings_russian_flag_icon.svg");
    languageDictionary.insert("ru", russian);

    initLanguages();
}

void TranslationManager::setLanguage(const QString& name)
{
    bool translationLoaded = m_translator.load(qApp->applicationDirPath() + "/translations/lang_ru.qm");
    if (translationLoaded) {
        qApp->installTranslator(&m_translator);
    } else {
        qWarning() << "Tranlsations: was not able to load translation file: " << qApp->applicationDirPath() + "/translations/lang_ru.qm";
    }
}

void TranslationManager::initLanguages()
{
    const QString translationsPath(qApp->applicationDirPath() + "/translations/");

    QDir translationsDir(translationsPath);
    auto translationFiles = translationsDir.entryList(QStringList { "*.qm" }, QDir::Files | QDir::NoDotAndDotDot | QDir::Readable);

    if (translationFiles.length() > 0) {
        QRegExp translationFileNameRegexp(translationFileNamePattern + "(.+)\\.qm");
        for (const auto& translationFileName : translationFiles) {
            if (translationFileNameRegexp.indexIn(translationFileName) >= 0) {
                const auto languageLocale = translationFileNameRegexp.cap(1);
                if (languageDictionary.contains(languageLocale)) {
                    m_languages->append(languageDictionary.value(languageLocale));
                }
            }
        }
    } else {
        qWarning() << "Translations: can not find any translation file";
    }
}

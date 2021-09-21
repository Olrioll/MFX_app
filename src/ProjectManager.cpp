#include "ProjectManager.h"

#include <QFile>
#include <QJsonDocument>
#include <QFileDialog>
#include <QStandardPaths>
#include <QProcess>

#include <QDebug>

ProjectManager::ProjectManager(SettingsManager &settngs, QObject *parent) : QObject(parent), _settings(settngs)
{
    addChild("Patches");
    addChild("Cues");
    addChild("Groups");
}

ProjectManager::~ProjectManager()
{
    cleanWorkDirectory();
}

void ProjectManager::cleanWorkDirectory()
{
    QDir workDir(_settings.workDirectory());
    auto fileNamesList = workDir.entryList(QDir::Files);

    QStringList exceptionList = {"settings.ini", "default.png"};

    for(auto & entry : fileNamesList)
    {
        if(entry.contains("pattern") && entry.contains(".txt"))
            continue;

        if(!exceptionList.contains(entry))
        {
            QFile::remove(_settings.workDirectory() + "/" + entry);
        }
    }
}

void ProjectManager::loadProject(QString fileName)
{
    QFile::remove(_settings.workDirectory() + "/" + property("backgroundImageFile").toString());
    QFile::remove(_settings.workDirectory() + "/" + property("audioTrackFile").toString());

    QProcess proc;
    proc.setProgram("7z.exe");
    QStringList args = {};
    args.append("e");
    args.append("-o" + _settings.workDirectory());
    args.append("-y");
    args.append(fileName);
    proc.start("7z.exe", args);
    proc.waitForFinished();

    QFile file(_settings.workDirectory() + "/project.json");
    if (file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        _hasUnsavedChanges = true; // Пока ставим этот флаг сразу, даже без фактических изменений
        _settings.setValue("lastProject", fileName);
        setCurrentProjectFile(fileName);
        fromJsonObject(QJsonDocument::fromJson(file.readAll()).object());

        emit groupCountChanged();
        emit patchListChanged();
        emit backgroundImageChanged();
        emit audioTrackFileChanged();
        for(auto cue : getChild("Cues")->namedChildren()) {
            QString cueName = cue->properties().value("name").toString();
            emit addCue(cue->properties());
            foreach(auto action, cue->listedChildren()) {
                QString pattern = action->properties().value("actionName").toString();
                quint64 deviceId = action->properties().value("patchId").toUInt();
                quint64 position = action->properties().value("position").toUInt();
                emit setActionProperty(cueName, pattern, deviceId, position);
            }
        }
    }
}

void ProjectManager::newProject()
{
    if(!isEmpty())
        saveProject();

    clear();

    setCurrentProjectFile("");
    setProperty("backgroundImageFile", "");
    setProperty("audioTrackFile", "");
    setProperty("sceneFrameX", 0.1);
    setProperty("sceneFrameY", 0.1);
    setProperty("sceneImageWidth", 0);
    setProperty("sceneScaleFactor", 1.0);
    setProperty("startPosition", -1);

    addChild("Patches");
    addChild("Cues");
    addChild("Groups");

    _hasUnsavedChanges = true;
    emit groupCountChanged();
    emit patchListChanged();
    emit backgroundImageChanged();
}

void ProjectManager::saveProject()
{
    if(m_currentProjectFile == "")
    {
        setCurrentProjectFile(saveProjectDialog());
    }

    if(m_currentProjectFile == "")
        return;

    QFile jsonFile(_settings.workDirectory() + "/project.json");
    if (jsonFile.open(QIODevice::WriteOnly | QIODevice::Truncate))
    {
        QJsonDocument doc;
        doc.setObject(toJsonObject());
        jsonFile.write(doc.toJson());
    }

    jsonFile.waitForBytesWritten(30000);
    jsonFile.close();

    QFile::remove(m_currentProjectFile);

    QProcess proc;
    proc.setProgram("7z.exe");
    QStringList args = {};
    args.append("a");
    args.append(m_currentProjectFile);
    args.append("-y");
    args.append(_settings.workDirectory() + "/project.json");

    if(property("backgroundImageFile").toString() != "")
        args.append(_settings.workDirectory() + "/" + property("backgroundImageFile").toString());

    if(property("audioTrackFile").toString() != "")
        args.append(_settings.workDirectory() + "/" + property("audioTrackFile").toString());

    proc.start("7z.exe", args);
    proc.waitForFinished();

    jsonFile.remove();
    QFile::remove(_settings.workDirectory() + "/" + property("backgroundImageFile").toString());
    QFile::remove(_settings.workDirectory() + "/" + property("audioTrackFile").toString());

    _settings.setValue("lastProject", m_currentProjectFile);
}

QString ProjectManager::saveProjectDialog()
{
    QString lastOpenedDir = _settings.value("lastOpenedDirectory").toString();
    lastOpenedDir = lastOpenedDir == "" ? QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) : lastOpenedDir;

    QString fileName = QFileDialog::getSaveFileName(nullptr, tr("Save current MFX project"), lastOpenedDir, tr("MFX projects (*.mfx)"));

    if(fileName.size())
    {
        QFileInfo info(fileName);
        _settings.setValue("lastOpenedDirectory", info.canonicalPath());
    }

    return fileName;
}

QString ProjectManager::openProjectDialog()
{
    QString lastOpenedDir = _settings.value("lastOpenedDirectory").toString();
    lastOpenedDir = lastOpenedDir == "" ? QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) : lastOpenedDir;

    QString fileName = QFileDialog::getOpenFileName(nullptr, tr("Open MFX project file"), lastOpenedDir, tr("MFX projects (*.mfx)"));

    if(fileName.size())
    {
        QFileInfo info(fileName);
        _settings.setValue("lastOpenedDirectory", info.canonicalPath());
    }

    return fileName;
}

bool ProjectManager::hasUnsavedChanges() const
{
    return _hasUnsavedChanges;
}

QStringList ProjectManager::groupNames() const
{
    return getChild("Groups")->childrenNames();
}

int ProjectManager::patchCount() const
{
    return getChild("Patches")->listedChildrenCount();
}

QList<int> ProjectManager::checkedPatchesList() const
{
    QList<int> checkedIDs;
    for(auto & patch : getChild("Patches")->listedChildren())
    {
        if(patch->property("checked").toBool())
            checkedIDs.push_back(patch->property("ID").toInt());
    }

    return checkedIDs;
}

QVariant ProjectManager::patchProperty(int id, QString propertyName) const
{
    auto patches = getChild("Patches")->listedChildren();
    for(auto patch : patches)
    {
        if(patch->property("ID").toInt() == id)
        {
            return patch->property(propertyName);
        }
    }

    return 0;
}

QVariant ProjectManager::patchPropertyForIndex(int index, QString propertyName) const
{
    return getChild("Patches")->listedChildren().at(index)->property(propertyName);
}

QString ProjectManager::patchType(int index) const
{
    return getChild("Patches")->listedChildren().at(index)->property("type").toString();
}

QVariantMap ProjectManager::patchProperties(int index) const
{
    QVariantMap props = getChild("Patches")->listedChildren().at(index)->properties();
    return props;
}

QStringList ProjectManager::patchPropertiesNames(int index) const
{
    return getChild("Patches")->listedChildren().at(index)->properties().keys();
}

QList<QVariant> ProjectManager::patchPropertiesValues(int index) const
{
    return getChild("Patches")->listedChildren().at(index)->properties().values();
}

void ProjectManager::setPatchProperty(int id, QString propertyName, QVariant value)
{
    auto patches = getChild("Patches")->listedChildren();
    for(auto patch : patches)
    {
        if(patch->property("ID").toInt() == id)
        {
            patch->setProperty(propertyName, value);
            if(propertyName == "checked")
            {
                emit patchCheckedChanged(id, value.toBool());
            }
            else
            {
                emit patchListChanged();
            }
            return;
        }
    }
}

void ProjectManager::setProperty(QString name, QVariant value)
{
    JsonSerializable::setProperty(name, value);
}

QVariant ProjectManager::property(QString name) const
{
    return JsonSerializable::property(name);
}

int ProjectManager::lastPatchId() const
{
    int id = 0;
    auto patches = getChild("Patches")->listedChildren();
    foreach(auto patch, patches)
    {
        if(patch->property("ID").toInt() > id)
            id = patch->property("ID").toInt();
    }

    return id;
}

void ProjectManager::addPatch(QString type, QVariantList properties)
{
    JsonSerializable* patch = new JsonSerializable;
    patch->setProperty("type", type);
    patch->setProperty("act", "");
    patch->setProperty("checked", false);

    foreach(auto prop, properties)
    {
        patch->setProperty(prop.toMap().first().toString(), prop.toMap().last());
    }


    getChild("Patches")->addChild(patch);

    for(int i = 0; i < 20; i++)
    {
        bool hasUnplacedPatch = false;
        for(auto & currPatch : getChild("Patches")->listedChildren())
        {
            if(currPatch->property("posXRatio").toDouble() == (0.05 + 0.01 * i) &&
                    currPatch->property("posYRatio").toDouble() == (0.05 + 0.01 * i))
            {
                hasUnplacedPatch = true;
            }
        }

        if(!hasUnplacedPatch)
        {
             getChild("Patches")->listedChildren().last()->setProperty("posXRatio", (0.05 + 0.01 * i));
            getChild("Patches")->listedChildren().last()->setProperty("posYRatio", (0.05 + 0.01 * i));
            emit patchListChanged();
            return;
        }
    }

    getChild("Patches")->listedChildren().last()->setProperty("posXRatio", 0.05);
    getChild("Patches")->listedChildren().last()->setProperty("posXRatio", 0.05);
    emit patchListChanged();
}

void ProjectManager::editPatch(QVariantList properties)
{
    JsonSerializable* patch = new JsonSerializable;
//    patch->setProperty("type", type);
//    patch->setProperty("act", "");
//    patch->setProperty("checked", false);

    foreach(auto prop, properties)
    {
        patch->setProperty(prop.toMap().first().toString(), prop.toMap().last());
    }

    for(auto & p : getChild("Patches")->listedChildren())
    {
        if(p->property("ID") == patch->property("ID"))
        {
            patch->setProperty("type", p->property("type"));
            patch->setProperty("act", p->property("act"));
            patch->setProperty("checked", p->property("checked"));
            patch->setProperty("posXRatio", p->property("posXRatio"));
            patch->setProperty("posYRatio", p->property("posYRatio"));

            getChild("Patches")->replaceChild(p, patch);
            emit patchListChanged();
            return;
        }
    }

    delete patch;
}

int ProjectManager::patchIndexForId(int id) const
{
    int counter = 0;
    for(auto & patch : getChild("Patches")->listedChildren())
    {
        if(patch->property("ID").toInt() == id)
            return counter;

        counter++;
    }

    return -1;
}


QVariantList ProjectManager::patchesIdList(QString groupName) const
{
    auto groups = getChild("Groups")->namedChildren();
    return groups.value(groupName)->property("patches").toList();
}

QString ProjectManager::selectAudioTrackDialog()
{
    QString lastOpenedDir = _settings.value("lastOpenedDirectory").toString();
    lastOpenedDir = lastOpenedDir == "" ? QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) : lastOpenedDir;

    QString fileName = QFileDialog::getOpenFileName(nullptr, tr("Open Audio Track"), lastOpenedDir, tr("Audio Files (*.wav *.mp3)"));

    if(fileName.size())
    {
        QFileInfo info(fileName);
        _settings.setValue("lastOpenedDirectory", info.canonicalPath());
    }

    return fileName;
}

QString ProjectManager::selectBackgroundImageDialog()
{
    QString lastOpenedDir = _settings.value("lastOpenedDirectory").toString();
    lastOpenedDir = lastOpenedDir == "" ? QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) : lastOpenedDir;

    QString fileName = QFileDialog::getOpenFileName(nullptr, tr("Open Image"), lastOpenedDir, tr("Image Files (*.png *.jpg *.bmp)"));

    if(fileName.size())
    {
        QFileInfo info(fileName);
        _settings.setValue("lastOpenedDirectory", info.canonicalPath());
    }

    return fileName;
}

void ProjectManager::setBackgroundImage(QString fileName)
{
    QFileInfo info(fileName);
    if((info.completeBaseName() + "." + info.completeSuffix()) != property("backgroundImageFile").toString())
    {
        QFile::remove(_settings.workDirectory() + "/" + property("backgroundImageFile").toString());
        QString shortName = info.completeBaseName();
        QFile::copy(fileName, _settings.workDirectory() + "/" + info.completeBaseName() + "." + info.completeSuffix());
        setProperty("backgroundImageFile", info.completeBaseName() + "." + info.completeSuffix());
    }
}

void ProjectManager::setAudioTrack(QString fileName)
{
    QFileInfo info(fileName);
    if((info.completeBaseName() + "." + info.completeSuffix()) != property("audioTrackFile").toString())
    {
        QFile::remove(_settings.workDirectory() + "/" + property("audioTrackFile").toString());
        QString shortName = info.completeBaseName();
        QFile::copy(fileName, _settings.workDirectory() + "/" + info.completeBaseName() + "." + info.completeSuffix());
        setProperty("audioTrackFile", info.completeBaseName() + "." + info.completeSuffix());

        emit audioTrackFileChanged();
    }
}

QString ProjectManager::currentGroup() const
{
    return _currentGroup;
}

void ProjectManager::setCurrentGroup(QString name)
{
    if(getChild("Groups")->childrenNames().contains(name))
    {
        _currentGroup = name;
        emit currentGroupChanged(name);
    }

}

bool ProjectManager::isGroupVisible(QString groupName) const
{
    auto groups = getChild("Groups")->namedChildren();
    return groups.value(groupName)->property("visible").toBool();
}

void ProjectManager::setGroupVisible(QString groupName, bool state)
{
    auto groups = getChild("Groups")->namedChildren();
    groups.value(groupName)->setProperty("visible", state);
}

bool ProjectManager::addGroup(QString name)
{
    if(getChild("Groups")->childrenNames().contains(name))
        return false;

    getChild("Groups")->addChild(name);
    auto groups = getChild("Groups")->namedChildren();
    groups.value(name)->setProperty("visible", true);
    groups.value(name)->setProperty("patches", QVariantList());

    emit groupCountChanged();
    return true;
}

void ProjectManager::removeGroup(QString name)
{
    getChild("Groups")->removeChild(name);
    emit groupCountChanged();
}

bool ProjectManager::renameGroup(QString newName)
{
    if(getChild("Groups")->childrenNames().contains(newName))
        return false;

   getChild("Groups")->renameChild(currentGroup(), newName);

   emit groupChanged(currentGroup());
   return true;
}

void ProjectManager::addPatchesToGroup(QString groupName, QList<int> patchIDs)
{
    QVariantList patchesList = getChild("Groups")->getChild(groupName)->property("patches").toList();
    for(auto i : patchIDs)
    {
        if(!patchesList.contains(i))
        {
            patchesList.append(i);
        }
    }

    getChild("Groups")->getChild(groupName)->setProperty("patches", patchesList);

    emit groupChanged(currentGroup());
}

void ProjectManager::removePatchesFromGroup(QString groupName, QList<int> patchIDs)
{
    QVariantList patchesList = getChild("Groups")->getChild(groupName)->property("patches").toList();
    for(auto i : patchIDs)
    {
        if(patchesList.contains(i))
        {
            patchesList.removeOne(i);
        }
    }

    getChild("Groups")->getChild(groupName)->setProperty("patches", patchesList);

    emit groupChanged(currentGroup());
}

bool ProjectManager::isGroupContainsPatch(QString groupName, int patchId) const
{
    return getChild("Groups")->getChild(groupName)->property("patches").toList().contains(patchId);
}

bool ProjectManager::isPatchHasGroup(int patchId) const
{
    for(auto & groupName : getChild("Groups")->childrenNames())
    {
        if(isGroupContainsPatch(groupName, patchId))
            return true;
    }

    return false;
}

void ProjectManager::onAddCue(QVariantMap properties)
{
    auto newCueName = properties.value("name").toString();
    getChild("Cues")->addChild(newCueName);
    getChild("Cues")->getChild(newCueName)->setProperties(properties);
}

QVariantList ProjectManager::getCues() const
{
    QVariantList cueList;
    for(auto & cue : getChild("Cues")->namedChildren())
    {
        cueList.push_back(cue->properties());
    }

    return cueList;
}

void ProjectManager::setCueProperty(QString cueName, QString propertyName, QVariant value)
{
    getChild("Cues")->getChild(cueName)->setProperty(propertyName, value);
}

void ProjectManager::addActionToCue(QString cueName, QString actionName, int patchId, int position)
{
    JsonSerializable* newAction = new JsonSerializable;
    newAction->setProperties({{"actionName", actionName}, {"patchId", patchId}, {"position", position}});
    getChild("Cues")->getChild(cueName)->addChild(newAction);
}

QVariantList ProjectManager::cueActions(QString cueName) const
{
    QVariantList actionList;
    for(auto & action : getChild("Cues")->getChild(cueName)->listedChildren())
    {
        actionList.push_back(action->properties());
    }

    return actionList;
}

void ProjectManager::onSetActionProperty(QString cueName, QString actionName, int patchId, QString propertyName, QVariant value)
{
    for(auto & action : getChild("Cues")->getChild(cueName)->listedChildren())
    {
        if(action->property("actionName").toString() == actionName && action->property("patchId").toInt() == patchId)
        {
            action->setProperty(propertyName, value);
        }
    }
}

void ProjectManager::deleteCues(QStringList deletedCueNames)
{
    for(auto &name: deletedCueNames) {
        getChild("Cues")->removeChild(name);
    }
}

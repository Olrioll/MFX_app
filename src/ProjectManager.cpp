#include "ProjectManager.h"

#include <QFile>
#include <QJsonDocument>
#include <QFileDialog>
#include <QStandardPaths>
#include <QProcess>
#include <QJsonValue>
#include <QJsonArray>
#include <algorithm>
#include <random>


#include <QDebug>

constexpr int defaultSceneFrameWidth = 20;
constexpr int defaultSceneFrameHeight = 10;

ProjectManager::ProjectManager(SettingsManager &settngs, QObject *parent) : QObject(parent), _settings(settngs)
{
    QMutexLocker locker( &m_ProjectLocker );

    addChild("Patches");
    addChild("Cues");
    addChild("Groups");
}

ProjectManager::~ProjectManager()
{
    cleanWorkDirectory();
}

void ProjectManager::setPrefire( const QMap<QString, int>& pref)
{
    m_prefire = pref;
}

void ProjectManager::cleanWorkDirectory()
{
    QDir workDir(_settings.workDirectory());
    auto fileNamesList = workDir.entryList(QDir::Files);

    QStringList exceptionList = {"settings.ini", "project.backup"};

    for(auto & entry : fileNamesList)
    {
        if(entry.contains("pattern") && entry.contains(".txt"))
            continue;

        if(!exceptionList.contains(entry))
        {
            qDebug() << entry;
            QFile::remove(_settings.workDirectory() + "/" + entry);
        }
    }
}

bool ProjectManager::loadProject(const QString& fileName)
{
    qDebug() << fileName;
    QMutexLocker locker( &m_ProjectLocker );

    if( !QFile::exists( fileName ) )
    {
        qDebug() << "file " << fileName << " not found";
        return false;
    }

    QDir dir( _settings.workDirectory() );
    QFile::remove( dir.filePath( property( "backgroundImageFile" ).toString() ) );
    QFile::remove( dir.filePath( property( "audioTrackFile" ).toString() ) );

    QProcess proc;
    proc.setProgram("7z.exe");
    QStringList args = {};
    args.append("e");
    args.append("-o" + _settings.workDirectory());
    args.append("-y");
    args.append(fileName);
    proc.start("7z.exe", args);
    proc.waitForFinished();

    emit deleteAllCue();

    QFile file( dir.filePath( PROJECT_FILE ) );
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

        for(auto cue : getChild("Cues")->namedChildren())
        {
            QString cueName = cue->properties().value("name").toString();
            emit addCue(cue->properties());
            foreach(auto action, cue->listedChildren())
            {
                QString pattern = action->properties().value("actionName").toString();
                quint64 deviceId = action->properties().value("patchId").toUInt();
                quint64 position = action->properties().value("position").toUInt();
                emit setActionProperty(cueName, pattern, deviceId, position);
            }
        }

        emit reloadPattern();

        for(auto patch : getChild("Patches")->listedChildren())
        {
            QVariantList properties;
            QVariantMap propertiesMap;
            propertiesMap["propName"] = "ID";
            propertiesMap["propValue"] = patch->properties().value("ID").toUInt();
            properties.append(propertiesMap);
            propertiesMap["propName"] = "DMX";
            propertiesMap["propValue"] = patch->properties().value("DMX").toInt();
            properties.append(propertiesMap);
            propertiesMap["propName"] = "min ang";
            propertiesMap["propValue"] = patch->properties().value("min ang").toInt();
            properties.append(propertiesMap);
            propertiesMap["propName"] = "max ang";
            propertiesMap["propValue"] = patch->properties().value("max ang").toInt();
            properties.append(propertiesMap);
            propertiesMap["propName"] = "RF pos";
            propertiesMap["propValue"] = patch->properties().value("RF pos").toInt();
            properties.append(propertiesMap);
            propertiesMap["propName"] = "RF ch";
            propertiesMap["propValue"] = patch->properties().value("RF ch").toInt();
            properties.append(propertiesMap);
            propertiesMap["propName"] = "height";
            propertiesMap["propValue"] = patch->properties().value("height").toInt();
            properties.append(propertiesMap);
            emit editPatch(properties);
        }

        return true;
    }

    return false;
}

void ProjectManager::defaultProject()
{
    qDebug();
    QMutexLocker locker( &m_ProjectLocker );

    newProject();

    setProperty( "sceneFrameWidth", defaultSceneFrameWidth );
    setProperty( "sceneFrameHeight", defaultSceneFrameHeight );
    setAudioTrack( QDir( _settings.appDirectory() ).filePath( "default.mp3" ) );
    setBackgroundImage( QDir( _settings.appDirectory() ).filePath( "default.svg" ) );

    if( property( "sceneFrameWidth" ).toInt() >= property( "sceneFrameHeight" ).toInt() )
        setProperty( "sceneImageWidth", property( "sceneFrameWidth" ).toInt() * 2 );
    else
        setProperty( "sceneImageWidth", property( "sceneFrameWidth" ).toInt() * 20 );

    if( property( "backgroundImageFile" ).toString() != "" && property( "sceneImageWidth" ).toInt() > 0 )
    {
        QImage img( property( "backgroundImageFile" ).toString() );

        float xPos = ((img.width() - property( "sceneFrameWidth" ).toInt() / (float)property( "sceneImageWidth" ).toInt() * img.width()) / 2) / img.width();
        float yPos = ((img.height() - property( "sceneFrameHeight" ).toInt() / (float)property( "sceneImageHeight" ).toInt() * img.height()) / 2) / img.height();

        setProperty( "sceneFrameX", xPos );
        setProperty( "sceneFrameY", yPos );
    }
}

void ProjectManager::reloadCurrentProject()
{
    qDebug();
    QMutexLocker locker( &m_ProjectLocker );

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
    emit reloadPattern();
    for(auto patch : getChild("Patches")->listedChildren()) {
        QVariantList properties;
        QVariantMap propertiesMap;
        propertiesMap["propName"] = "ID";
        propertiesMap["propValue"] = patch->properties().value("ID").toUInt();
        properties.append(propertiesMap);
        propertiesMap["propName"] = "DMX";
        propertiesMap["propValue"] = patch->properties().value("DMX").toInt();
        properties.append(propertiesMap);
        propertiesMap["propName"] = "min ang";
        propertiesMap["propValue"] = patch->properties().value("min ang").toInt();
        properties.append(propertiesMap);
        propertiesMap["propName"] = "max ang";
        propertiesMap["propValue"] = patch->properties().value("max ang").toInt();
        properties.append(propertiesMap);
        propertiesMap["propName"] = "RF pos";
        propertiesMap["propValue"] = patch->properties().value("RF pos").toInt();
        properties.append(propertiesMap);
        propertiesMap["propName"] = "RF ch";
        propertiesMap["propValue"] = patch->properties().value("RF ch").toInt();
        properties.append(propertiesMap);
        propertiesMap["propName"] = "height";
        propertiesMap["propValue"] = patch->properties().value("height").toInt();
        properties.append(propertiesMap);
        emit editPatch(properties);
    }

    emit groupCountChanged();
    emit patchListChanged();
}

void ProjectManager::newProject()
{
    qDebug();
    QMutexLocker locker( &m_ProjectLocker );

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
    QMutexLocker locker( &m_ProjectLocker );

    if(m_currentProjectFile == "")
        setCurrentProjectFile(saveProjectDialog());

    if(m_currentProjectFile == "")
        return;

    qDebug() << m_currentProjectFile;

    saveProjectToFile( PROJECT_FILE, m_currentProjectFile, _settings.workDirectory() );

    //QFile::remove(_settings.workDirectory() + "/" + property("backgroundImageFile").toString());
    //QFile::remove(_settings.workDirectory() + "/" + property("audioTrackFile").toString());

    _settings.setValue("lastProject", m_currentProjectFile);
}

void ProjectManager::saveProjectToFile( const QString& projectFile, const QString& saveFile, const QDir& saveDir )
{
    QFile jsonFile( saveDir.filePath( projectFile ) );
    if( jsonFile.open( QIODevice::WriteOnly | QIODevice::Truncate ) )
    {
        qDebug() << jsonFile;

        QJsonDocument doc;
        {
            QMutexLocker locker( &m_ProjectLocker );
            doc.setObject( toJsonObject() );
        }
        jsonFile.write( doc.toJson() );
    }
    else
    {
        qDebug() << "file " << projectFile << " not found";
        return;
    }

    jsonFile.waitForBytesWritten( 30000 );
    jsonFile.close();

    QFile::remove( saveDir.filePath( saveFile ) );

    QProcess proc;
    proc.setProgram( "7z.exe" );
    QStringList args = {};
    args.append( "a" );
    args.append( saveDir.filePath( saveFile ) );
    args.append( "-y" );
    args.append( saveDir.filePath( projectFile ) );

    if( property( "backgroundImageFile" ).toString() != "" )
        args.append( saveDir.filePath( property( "backgroundImageFile" ).toString() ) );

    if( property( "audioTrackFile" ).toString() != "" )
        args.append( saveDir.filePath( property( "audioTrackFile" ).toString() ) );

    proc.start( "7z.exe", args );
    proc.waitForFinished();

    jsonFile.remove();
}

QString ProjectManager::saveProjectDialog()
{
    QString lastOpenedDir = _settings.value("lastOpenedDirectory").toString();
    lastOpenedDir = lastOpenedDir == "" ? QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) : lastOpenedDir;

    QString fileName = QFileDialog::getSaveFileName(nullptr, tr("Save current MFX project"), lastOpenedDir, tr("MFX projects (*.mfx)"));
    qDebug() << fileName;

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
    qDebug() << fileName;

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

void ProjectManager::removePatchesByIDs(const QStringList &ids)
{
    qInfo() << "IDS LIST: " << ids;
    QStringList patchNamesToRemove;

    for(const auto &patch: getChild("Patches")->listedChildren()) {
        const auto &patchID = patch->property("ID").toString();
        qInfo() << patch->toJsonObject();
        if(ids.contains(patchID)) {
            patchNamesToRemove << patch->property("ID").toString();
        }
    }

    qInfo() << "PATCH NAMES: " << patchNamesToRemove;
    QMutexLocker locker( &m_ProjectLocker );

    for(auto &patchName: patchNamesToRemove) {
        getChild("Patches")->removeChild(patchName);
    }


    emit patchListChanged();
}

QVariant ProjectManager::patchProperty(int id, const QString& propertyName) const
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

QVariant ProjectManager::patchPropertyForIndex(int index, const QString& propertyName) const
{
    auto& children = getChild( "Patches" )->listedChildren();

    if( index < 0 || index >= children.size() )
        return {};

    return children.at(index)->property(propertyName);
}

QString ProjectManager::patchType(int index) const
{
    auto& children = getChild( "Patches" )->listedChildren();

    if( index < 0 || index >= children.size() )
        return {};

    return children.at(index)->property("type").toString();
}

QVariantMap ProjectManager::patchProperties(int index) const
{
    auto& children = getChild( "Patches" )->listedChildren();

    if( index < 0 || index >= children.size() )
        return {};

    QVariantMap props = children.at(index)->properties();
    return props;
}

QStringList ProjectManager::patchPropertiesNames(int index) const
{
    auto& children = getChild( "Patches" )->listedChildren();

    if( index < 0 || index >= children.size() )
        return {};

    return children.at(index)->properties().keys();
}

QList<QVariant> ProjectManager::patchPropertiesValues(int index) const
{
    auto& children = getChild( "Patches" )->listedChildren();

    if( index < 0 || index >= children.size() )
        return {};

    return children.at(index)->properties().values();
}

void ProjectManager::setPatchProperty(int id, const QString& propertyName, QVariant value)
{
    //qDebug() << id << " " << propertyName << " " << value;
    QMutexLocker locker( &m_ProjectLocker );

    auto patches = getChild("Patches")->listedChildren();
    for(auto& patch : patches)
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

void ProjectManager::uncheckPatch()
{
    QMutexLocker locker( &m_ProjectLocker );

    auto patches = getChild("Patches")->listedChildren();
    for(auto patch : patches)
    {
        patch->setProperty("checked", false);
        emit patchCheckedChanged(patch->property("ID").toInt(), false);
    }
}

void ProjectManager::setProperty(const QString& name, QVariant value)
{
    //qDebug() << name << " " << value;
    QMutexLocker locker( &m_ProjectLocker );

    JsonSerializable::setProperty(name, value);
}

QVariant ProjectManager::property(const QString& name) const
{
    return JsonSerializable::property( name );
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

void ProjectManager::addPatch(const QString& type, const QVariantList& properties)
{
    QMutexLocker locker( &m_ProjectLocker );

    JsonSerializable* patch = new JsonSerializable;
    patch->setProperty("type", type);
    patch->setProperty("act", "");
    patch->setProperty("checked", false);

    foreach(const auto& prop, properties)
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

void ProjectManager::onEditPatch(const QVariantList& properties)
{
    QMutexLocker locker( &m_ProjectLocker );

    JsonSerializable* patch = new JsonSerializable;
//    patch->setProperty("type", type);
//    patch->setProperty("act", "");
//    patch->setProperty("checked", false);

    foreach(const auto& prop, properties)
    {
        if(!prop.toMap().isEmpty())
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

            if(patch->property("DMX").isNull())
                patch->setProperty("DMX", p->property("DMX"));

            if(patch->property("min ang").isNull())
                patch->setProperty("min ang", p->property("min ang"));

            if(patch->property("max ang").isNull())
                patch->setProperty("max ang", p->property("max ang"));

            if(patch->property("RF pos").isNull())
                patch->setProperty("RF pos", p->property("RF pos"));

            if(patch->property("RF ch").isNull())
                patch->setProperty("RF ch", p->property("RF ch"));

            if(patch->property("height").isNull())
                patch->setProperty("height", p->property("height"));


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


QVariantList ProjectManager::patchesIdList(const QString& groupName) const
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

void ProjectManager::setBackgroundImage(const QString& fileName)
{
    qDebug() << fileName;
    QMutexLocker locker( &m_ProjectLocker );

    QFileInfo info(fileName);
    if((info.completeBaseName() + "." + info.completeSuffix()) != property("backgroundImageFile").toString())
    {
        QFile::remove(_settings.workDirectory() + "/" + property("backgroundImageFile").toString());
        QString shortName = info.completeBaseName();
        QFile::copy(fileName, _settings.workDirectory() + "/" + info.completeBaseName() + "." + info.completeSuffix());
        setProperty("backgroundImageFile", info.completeBaseName() + "." + info.completeSuffix());
    }
}

void ProjectManager::setAudioTrack(const QString& fileName)
{
    qDebug() << fileName;
    QMutexLocker locker( &m_ProjectLocker );

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
    QMutexLocker locker( &m_ProjectLocker );

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
    QMutexLocker locker( &m_ProjectLocker );

    auto groups = getChild("Groups")->namedChildren();
    groups.value(groupName)->setProperty("visible", state);
}

bool ProjectManager::addGroup(QString name)
{
    QMutexLocker locker( &m_ProjectLocker );

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
    QMutexLocker locker( &m_ProjectLocker );

    getChild("Groups")->removeChild(name);
    emit groupCountChanged();
}

bool ProjectManager::renameGroup(QString newName)
{
    QMutexLocker locker( &m_ProjectLocker );

    if(getChild("Groups")->childrenNames().contains(newName))
        return false;

   getChild("Groups")->renameChild(currentGroup(), newName);

   emit groupChanged(currentGroup());
   return true;
}

void ProjectManager::addPatchesToGroup(QString groupName, QList<int> patchIDs)
{
    QMutexLocker locker( &m_ProjectLocker );

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

void ProjectManager::removePatches(const QList<int> patchIds)
{
    QMutexLocker locker( &m_ProjectLocker );

     getChild("Patches")->removeChildrenAtIndex(patchIds);
     emit patchListChanged();
}

void ProjectManager::removeSelectedPatches()
{

    QMutexLocker locker( &m_ProjectLocker );

    QList<int> ids;
    for(auto i =0; i< patchCount();++i){
          if(patchPropertyForIndex(i,"checked").toBool())
               ids.append(patchPropertyForIndex(i,"ID").toInt());

    }


      for(auto &gr: getChild("Groups")->namedChildren().keys()){
           removePatchesFromGroup(gr,ids);
      }

       getChild("Patches")->removefromChildrenWithProperty("checked",QVariant(true));
       emit patchListChanged();

    for(auto patchId: ids){
        for( auto &cue: getChild("Cues")->namedChildren()){
            cue->removefromChildrenWithProperty("patchId", patchId);
            if(!cue->listedChildren().isEmpty())
              updateCues(cue->property("name").toString());
            else{
                const auto cueName = cue->property("name").toString();
                getChild("Cues")->removeChild(cueName);
            }
        }

    }
    emit deleteAllCue();
    _hasUnsavedChanges = true;
    reloadCurrentProject();
    emit reloadCues();
}

void ProjectManager::removePatchesFromGroup(QString groupName, QList<int> patchIDs)
{
    QMutexLocker locker( &m_ProjectLocker );

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
    QMutexLocker locker( &m_ProjectLocker );

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
    QMutexLocker locker( &m_ProjectLocker );
    getChild("Cues")->getChild(cueName)->setProperty(propertyName, value);
}

void ProjectManager::addActionToCue(QString cueName, QString actionName, int patchId, int position)
{
    QMutexLocker locker( &m_ProjectLocker );

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

    auto variantSort = [](const QVariant &v1, const QVariant &v2)
    {
        return v1.toMap().value("position").toDouble() < v2.toMap().value("position").toDouble() ;
    };

    std::sort(actionList.begin(), actionList.end(), variantSort);
    return actionList;
}

void ProjectManager::onSetActionProperty(QString cueName, QString actionName, int patchId, QString propertyName, QVariant value)
{
    QMutexLocker locker( &m_ProjectLocker );

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
    QMutexLocker locker( &m_ProjectLocker );

    for(auto &name: deletedCueNames) {
        getChild("Cues")->removeChild(name);
    }
}

void ProjectManager::copyCues(QStringList copyCueNames)
{
    QMutexLocker locker( &m_ProjectLocker );

    _pastedCues.clear();
    for(auto &name: copyCueNames) {
        auto newName = getChild("Cues")->addFromJsonObject(getChild("Cues")->getChild(name)->toJsonObject());
        if(!newName.isEmpty()){
            _pastedCues<<newName;
            auto cue = getChild("Cues")->getChild(newName);
            emit addCue(cue->properties());
            foreach(auto action, cue->listedChildren()) {
                QString pattern = action->properties().value("actionName").toString();
                quint64 deviceId = action->properties().value("patchId").toUInt();
                quint64 position = action->properties().value("position").toUInt();
                emit setActionProperty(newName, pattern, deviceId, position);
            }
        }
    }

    if(!_pastedCues.isEmpty()){
        emit pasteCues(_pastedCues);
    }
}

void ProjectManager::changeAction(QString cueName, int deviceId, QString pattern)
{
    QMutexLocker locker( &m_ProjectLocker );

        auto cue = getChild("Cues")->getChild(cueName);
        foreach(auto action, cue->listedChildren()) {
            if(deviceId == action->properties().value("patchId").toUInt())
            {
                action->setProperty("actionName",pattern);
                quint64 position = action->properties().value("position").toUInt();
                emit setActionProperty(cueName, pattern, deviceId, position);
                emit updateCues(cueName);
                return;
            }
    }
}

void ProjectManager::saveJsonOut()
{
    QString lastOpenedDir = _settings.value("lastOpenedDirectory").toString();
    lastOpenedDir = lastOpenedDir == "" ? QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) : lastOpenedDir;
    QString fileName = QFileDialog::getSaveFileName(nullptr, tr("Save json output file"), lastOpenedDir);

    QFile jsonFile(fileName);
    if (jsonFile.open(QIODevice::WriteOnly | QIODevice::Truncate))
    {
        QMutexLocker locker( &m_ProjectLocker );

        auto ar = getChild("Cues")->toJsonObject().value("namedChildren").toObject();

        auto pch = getChild("Patches")->toJsonObject().value("children").toArray();
        QMap <int,QJsonObject>patch;
        for(auto z: pch){
            auto p = z.toObject().value("properties").toObject();
            patch.insert(p.value("ID").toInt(),p);
        }

        QJsonObject out;
        auto getRoundPos = [](const double p){
            return qint64(p/10.0)*10;
        };
        QVector<QJsonObject> list;
        auto data = QJsonObject({

                                    qMakePair(QString("action"), 1),
                                    qMakePair(QString("between"), QJsonValue(static_cast<qint64>(0))),
                                    qMakePair(QString("ch"), 1),
                                    qMakePair(QString("delay"), QJsonValue(static_cast<qint64>(0))),
                                    qMakePair(QString("freeze"), bool(false)),
                                    qMakePair(QString("id"), 0),
                                    qMakePair(QString("position"), 0),
                                    qMakePair(QString("time"), QJsonValue(static_cast<qint64>(100))),
                                    qMakePair(QString("type"),1)
                                });
        for( auto y:ar )
        {

            for(const auto x: y.toObject().value("children").toArray())
            {
                QJsonObject d;
                auto actionName = x.toObject().value("properties").toObject().value("actionName").toString();
                auto patchid = x.toObject().value("properties").toObject().value("patchId").toInt();
                auto position = getRoundPos(x.toObject().value("properties").toObject().value("position").toDouble()) - m_prefire.value(actionName);
                if(position<0)continue;

                data["action"] = actionName.remove("A").toInt();
                data["ch"] = patch.find(patchid).value().value("DMX").toInt();
                data["delay"] = position;
                list.append(data);
            }

        }

        std::sort(list.begin(),list.end(),[](const QJsonObject &a,const QJsonObject &b){
            return a.value("delay").toInt() < b.value("delay").toInt();});

        int id = 1;
        auto lastMs = 0;
        for(auto &x: list){
            x["id"] = id++;
            auto pl = x.value("delay").toInt();
            x["between"] = pl - lastMs;
            lastMs = pl;
        }

        QJsonArray arr;
        for(auto &x: list)
        {
            arr.push_back(x);
        }

        const auto jsonout = QJsonDocument(arr).toJson();
        jsonFile.write(jsonout);
        const auto l = _settings.value("cloudLogin").toString();
        const auto p = _settings.value("cloudPassword").toString();
        if(!l.isEmpty() && !p.isEmpty())
        {
            QFileInfo info(fileName);
            auto fname =info.fileName();
            if(fname>0)
            {
                if(fname.size() + 1>12){
                    const auto s = fname.size() - 12;
                    fname = fname.remove(12,s-1);
                }
//                clouds.sendToClouds(jsonout,l,p,fname);
            }
        }

        jsonFile.waitForBytesWritten(30000);
        jsonFile.close();
    }
}

void ProjectManager::onMirror(const QString &cueName, QList<int> deviceId)
{
    QMutexLocker locker( &m_ProjectLocker );

    auto cue = getChild("Cues")->getChild(cueName);

    QList<JsonSerializable*> l;
    foreach(auto action, cue->listedChildren()) {
        if(deviceId.contains(action->properties().value("patchId").toUInt()))
        {
           l << action;
        }
      }

    for(auto i = 0,y = l.size() -1; i < l.size(); i++,--y){
        if(i<y){
         auto devL = l[i]->properties().value("patchId").toUInt();
         auto actL = l[i]->properties().value("actionName").toString();
         auto devF = l[y]->properties().value("patchId").toUInt();
         auto actF =  l[y]->properties().value("actionName").toString();
         l[i]->setProperty("patchId",devF);
         l[i]->setProperty("actionName",actF);
         l[y]->setProperty("patchId",devL);
         l[y]->setProperty("actionName",actL);
         quint64 position = l[i]->properties().value("position").toUInt();
         quint64 position2 = l[y]->properties().value("position").toUInt();

         emit setActionProperty(cueName, actL, devL, position2);
         emit setActionProperty(cueName, actF, devF, position);
        }else break;;
    }

     updateCoeffByName(cueName);
    if(!l.isEmpty()) emit updateCues(cueName);
}

void ProjectManager::onInsideOutside(const QString &cueName, QList<int> deviceId, bool inside)
{
    QMutexLocker locker( &m_ProjectLocker );

    auto cue = getChild("Cues")->getChild(cueName);
    QList<JsonSerializable*> p;
    foreach(auto action, cue->listedChildren()) {
        if(deviceId.contains(action->properties().value("patchId").toUInt()))
        {
           p << action;
        }
      }


    QList<JsonSerializable*> l;
    QList<quint64> pos;
    for(auto i = 0,y = p.size()-1; i < p.size(); i++,--y){
        if(i<y){
           l << p[i] << p[y];
           auto _pos = p[i*2]->properties().value("position").toUInt();
           pos << _pos << _pos;
        }else if(i == y){
            l<< p[i];
            pos << p[p.size()-1]->properties().value("position").toUInt();
        }
    }

if(inside){
   std::reverse(l.begin(),l.end());
}

    for(auto i = 0,y=0; i < l.size(); i+=2,y+=2){
        if(i<l.size()-1){
         auto devL = l[i]->properties().value("patchId").toUInt();
         auto actL = l[i]->properties().value("actionName").toString();
         auto devF = l[i+1]->properties().value("patchId").toUInt();
         auto actF =  l[i+1]->properties().value("actionName").toString();
         quint64 position =  pos[i];
         l[i+1]->setProperty("position",position);
         l[i]->setProperty("position",position);
         emit setActionProperty(cueName, actL, devL, position);
         emit setActionProperty(cueName, actF, devF, position);
        }else if(i<l.size()){
            quint64 position =  pos[i];
            l[i]->setProperty("position",position);
            emit setActionProperty(cueName, l[i]->properties().value("actionName").toString(),
                                   l[i]->properties().value("patchId").toUInt(), position);
        }else break;
    }

     updateCoeffByName(cueName);
     if(!l.isEmpty()) emit updateCues(cueName);
}

void ProjectManager::onRandom(const QString &cueName, QList<int> deviceId)
{
    QMutexLocker locker( &m_ProjectLocker );

    auto cue = getChild("Cues")->getChild(cueName);

    QList<JsonSerializable*> l;
    foreach(auto action, cue->listedChildren()) {
        if(deviceId.contains(action->properties().value("patchId").toUInt()))
        {
           l << action;
        }
      }

    for(auto i = 0; i< l.size(); i+=2){
        if((i+1) < l.size()){
            l.swapItemsAt(i,i+1);
        }else break;
    }

    std::random_device rd;
    std::mt19937 g(rd());

    std::shuffle(l.begin(),l.end(),g);

    for(auto i = 0,y = l.size() -1; i < l.size(); i++,--y){
        if(i<y){
         auto devL = l[i]->properties().value("patchId").toUInt();
         auto actL = l[i]->properties().value("actionName").toString();
         auto devF = l[y]->properties().value("patchId").toUInt();
         auto actF =  l[y]->properties().value("actionName").toString();
         l[i]->setProperty("patchId",devF);
         l[i]->setProperty("actionName",actF);
         l[y]->setProperty("patchId",devL);
         l[y]->setProperty("actionName",actL);
         quint64 position = l[i]->properties().value("position").toUInt();
         quint64 position2 = l[y]->properties().value("position").toUInt();

         emit setActionProperty(cueName, actL, devL, position2);
         emit setActionProperty(cueName, actF, devF, position);
        }else break;;
    }

    updateCoeffByName(cueName);

    if(!l.isEmpty()) emit updateCues(cueName);
}

QStringList ProjectManager::maxActWidth(const QList<int> &ids)
{
    QStringList out;
    auto patches = getChild("Patches")->listedChildren();
    for(auto patch : patches)
    {
        for(auto &id:ids){
            if(patch->property("ID").toInt() == id)
            {
                out<<patch->property("act").toString();
            }
        }
    }

    return out;
}

void ProjectManager::updateCurrent()
{
    QMutexLocker locker( &m_ProjectLocker );

    emit deleteAllCue();
    _hasUnsavedChanges = true;
    reloadCurrentProject();
    emit reloadCues();
}

void ProjectManager::updateCoeffByName(QString cueName){

//    auto cue = getChild("Cues")->getChild(cueName);
//    auto size = cue->listedChildren().size()-1;
//    auto i = 0;

//    auto variantSort = []( JsonSerializable* v1,  JsonSerializable* v2)
//    {
//        return v1->properties().value("position").toDouble() < v2->properties().value("position").toDouble() ;
//    };


//    QList<JsonSerializable*> l;
//    foreach(auto action, cue->listedChildren()) {
//        l << action;
////        qDebug()<<"coff "<<(1.f/size) * i;
////         action->setProperty("positionCoeff",cueActions(cueName).size() / * i);
////         ++i;
////         emit setActionProperty(cueName, action->properties().value("actionName").toString(),
////                                action->properties().value("patchId").toUInt(),
////                                action->properties().value("position").toUInt());

//    }
//    std::sort(l.begin(), l.end(), variantSort);

//    for(auto &action: l)
//    {
//        action->setProperty("positionCoeff",(1.f/size)  * i);
//        ++i;
//    }

}

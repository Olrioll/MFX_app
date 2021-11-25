#include "JsonSerializable.h"

#include <QJsonArray>

JsonSerializable::JsonSerializable()
{

}

JsonSerializable::JsonSerializable(const QJsonObject &jsonObject)
{
    fromJsonObject(jsonObject);
}

JsonSerializable::~JsonSerializable()
{
    cleanChildren();
}

void JsonSerializable::setProperty(const QString &name, QVariant value)
{
    _properties.insert(name, value);
}

void JsonSerializable::setProperties(const QVariantMap &props)
{
    _properties = props;
}

QVariant JsonSerializable::property(const QString &name) const
{
    return _properties.value(name);
}

QVariantMap &JsonSerializable::properties()
{
    return _properties;
}

void JsonSerializable::addChild(const QString &name)
{
    _namedChildren.insert(name, new JsonSerializable());
}

void JsonSerializable::addChild(JsonSerializable *child)
{
    _childrenList.push_back(child);
}

void JsonSerializable::replaceChild(JsonSerializable *child, JsonSerializable *newChild)
{
    _childrenList.replace(_childrenList.indexOf(child), newChild);
    delete child;
}

void JsonSerializable::addChild()
{
    _childrenList.push_back(new JsonSerializable());
}

void JsonSerializable::removeChild(const QString &name)
{
    delete _namedChildren.value(name);
    _namedChildren.remove(name);
}

void JsonSerializable::renameChild(const QString &name, const QString &newName)
{
    auto oldValue = _namedChildren.take(name);
    _namedChildren.insert(newName, oldValue);
}

JsonSerializable *JsonSerializable::getChild(const QString &name) const
{
    return _namedChildren.value(name);
}

QStringList JsonSerializable::childrenNames() const
{
    return _namedChildren.keys();
}

int JsonSerializable::listedChildrenCount() const
{
    return _childrenList.size();
}

QList<JsonSerializable *> JsonSerializable::listedChildren() const
{
    return _childrenList;
}

QMap<QString, JsonSerializable *> JsonSerializable::namedChildren() const
{
    return _namedChildren;
}

QJsonObject JsonSerializable::toJsonObject() const
{
    QJsonObject object;
    object.insert("properties", QJsonValue::fromVariant(_properties));

    QJsonArray children;
    for(auto & child : _childrenList)
    {
        children.append(child->toJsonObject());
    }
    object.insert("children", children);

    QJsonObject namedChildren;
    for(auto & child : _namedChildren)
    {
        namedChildren.insert(_namedChildren.key(child), child->toJsonObject());
    }

    object.insert("namedChildren", namedChildren);

    return object;
}

void JsonSerializable::fromJsonObject(const QJsonObject &jsonObject)
{
    cleanChildren();
    _properties = jsonObject.value("properties").toObject().toVariantMap();

    QJsonObject namedChildren = jsonObject.value("namedChildren").toObject();
    for(auto & childName : namedChildren.keys())
    {
        _namedChildren.insert(childName, new JsonSerializable(namedChildren.value(childName).toObject()));
    }

    QJsonArray children = jsonObject.value("children").toArray();
    for(const auto & child : children)
    {
        _childrenList.push_back(new JsonSerializable(child.toObject()));
    }
}

QString JsonSerializable::addFromJsonObject(QJsonObject &&jsonObject)
{
    auto pr = jsonObject.take("properties").toObject().toVariantMap();
    auto tm = pr.take("name");
    auto yp = pr.take("yPosition");

    QString newName;
    int i = 1;
    for(;i<1000;i++)
    {
        newName = "Cue" + QString::number(i);
        if(_namedChildren.contains(newName))
            continue;
        else{
            pr.insert("name",newName);

            auto pos = pr.value("position").toDouble();
            double dur = pr.value("duration").toUInt();
            QVector<QVariant> allPos;
            for(auto &x:_namedChildren){

                  const auto oX =x->_properties.value("position").toDouble();
                  const double oD = x->_properties.value("duration").toUInt();
//                  auto a1 = (pos == oX);
//                  auto a2 = ((pos<= oX) && ((pos + dur)>=oX));
//                  auto a3 = ((oX<= pos) && ((oX + oD)>=pos));
                if( !(((pos+dur) < oX) || (pos > (oX+oD))))
                {
                    allPos.push_back(x->_properties.value("yPosition"));
                }else if(pos == oX){
                   allPos.push_back(x->_properties.value("yPosition"));
                }
            }

            std::sort(allPos.begin(),allPos.end());
            bool isOk=true;
            int y2 = 0;
            auto y1 =yp.toInt() + 12;

            for(auto &x:allPos){
                if(yp.toInt() < x.toInt()){
                    auto y3 = y1>y2?y1:y2;
                    if(y3 < (x.toInt()-12)){
                        yp = y3;
                        isOk=false;
                        break;
                    }else{
                        y2 = x.toInt()+12;
                    }
                }else{
                    y2 = x.toInt()+12;
                }
            }

            if(isOk){
              yp = allPos.back().toInt()+12;
            }

            pr.insert("yPosition",yp);
            jsonObject.insert("properties",QJsonValue::fromVariant(pr));
            _namedChildren.insert(newName,new JsonSerializable(jsonObject));
            break;
        }
    }
    if(i==1000)return QString();

    return newName;
}

void JsonSerializable::clear()
{
    cleanChildren();
}

bool JsonSerializable::isEmpty() const
{
    return !_properties.count();
}

void JsonSerializable::cleanChildren()
{
    for(auto & i : _namedChildren)
    {
        delete i;
    }

    for(auto & i : _childrenList)
    {
        delete i;
    }

    _namedChildren.clear();
    _childrenList.clear();
    _properties.clear();
}

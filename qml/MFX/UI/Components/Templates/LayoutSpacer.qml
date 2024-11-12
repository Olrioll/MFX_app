import QtQuick 2.15
import QtQuick.Layouts 1.12

Item
{
    id: _itm

    property var fixedWidth: undefined
    property var fixedHeight: undefined

    Component.onCompleted:
    {
        if(_itm.fixedHeight === undefined)
        {
            Layout.fillHeight = true
        }
        else
        {
            Layout.preferredHeight = _itm.fixedHeight
            Layout.minimumHeight = _itm.fixedHeight
            Layout.maximumHeight = _itm.fixedHeight
        }

        if(_itm.fixedWidth === undefined)
        {
            Layout.fillWidth = true
        }
        else
        {
            Layout.preferredWidth = _itm.fixedWidth
            Layout.minimumWidth = _itm.fixedWidth
            Layout.maximumWidth = _itm.fixedWidth
        }
    }
}

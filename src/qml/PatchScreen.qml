import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
    id: patchScreen

//    Rectangle
//    {
//        width: 22
//        anchors.right: patchScreen.right
//        anchors.top: patchScreen.top
//        anchors.bottom: patchScreen.bottom
//        color: "#444444"
//    }

    SideDockedWindow
    {
        id: deviceLib
        anchors.right: patchScreen.right
        anchors.top: patchScreen.top
        anchors.bottom: patchScreen.bottom
    }

    Component.onCompleted:
    {
        console.log(patchScreen.width)
    }
}

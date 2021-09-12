import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: addGroupItem
    anchors.fill: parent

    signal canBeDestroyed

    function attemptToAdd()
    {
        if(groupNameField.text !== "")
        {
            project.addGroup(groupNameField.text);
            addGroupItem.canBeDestroyed()
        }
    }

    Text
    {
        id: titleText
        anchors.topMargin: 40
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#ffffff"
        text: translationsManager.translationTrigger + qsTr("Group name")
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        textFormat: Text.RichText
    }

    TextField
    {
        id: groupNameField
        width: 140
        height: 30
        anchors.topMargin: 20
        anchors.top: titleText.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#ffffff"

        background: Rectangle
        {
            color: "#444444"
        }

        Keys.onReturnPressed:
        {
            addGroupItem.attemptToAdd()
        }
    }

    MfxButton
    {
        id: addGroupButton
        text: translationsManager.translationTrigger + qsTr("Add")
        width: 100
        color: "#2F80ED"

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10
        anchors.bottom: parent.bottom

        onClicked:
        {
            addGroupItem.attemptToAdd()
        }
    }

    Component.onCompleted:
    {
        groupNameField.focus = true
    }

//    Button
//    {
//        id: cancelButton
//        text: translationsManager.translationTrigger + qsTr("Cancel")
//        height: 24
//        width: (parent.width - anchors.margins * 3) / 2

//        anchors.margins: 2
//        anchors.left: addGroupButton.right
//        anchors.bottom: parent.bottom


//        bottomPadding: 2
//        topPadding: 2
//        rightPadding: 2
//        leftPadding: 2

//        background: Rectangle
//        {
//            color: parent.pressed ? "#222222" : "#EB5757"
//            radius: 2
//        }

//        contentItem: Text
//        {
//            color: "#ffffff"
//            text: parent.text
//            horizontalAlignment: Text.AlignHCenter
//            verticalAlignment: Text.AlignVCenter
//            elide: Text.ElideRight
//            font.family: MFXUIS.Fonts.robotoRegular.name
//        }

//        onClicked:
//        {

//        }
//    }

}

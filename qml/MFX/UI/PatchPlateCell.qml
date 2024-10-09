import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: plateCell
    width: 50
    height: 36

    property string propertyName
    property string propertyValue

    Text {
        id: displayedPropertyName
        y: 2
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#ffffff"
        text: plateCell.propertyName
        font.family: MFXUIS.Fonts.robotoRegular.name
        font.pixelSize: 10
    }

    Text {
        id: displayedPropertyValue
        y: 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#ffffff"
        text: (plateCell.propertyName === "DMX ch" && Number(plateCell.propertyValue) === 0) ? "-" : plateCell.propertyValue
        font.family: MFXUIS.Fonts.robotoRegular.name
        font.pixelSize: 12
    }

    Rectangle
    {
        id: separator
        width: 2
        anchors.topMargin: 2
        anchors.bottomMargin: 2
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "#ffffff"
        opacity: 0.2
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

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
        font.family: "Roboto"
        font.pixelSize: 10
    }

    Text {
        id: displayedPropertyValue
        y: 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#ffffff"
        text: plateCell.propertyValue
        font.family: "Roboto"
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

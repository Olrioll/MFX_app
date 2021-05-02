import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    property string name

    Button
    {
        id: collapseButton
        width: 15
        height: 15
        checkable: true

        bottomPadding: 0
        topPadding: 0
        rightPadding: 0
        leftPadding: 0

        background: Rectangle {
            color: "#444444"
            radius: 2
        }

        contentItem: Text {
            color: "#ffffff"
            text: parent.checked ? "-" : "+"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.family: "Roboto"
            font.pixelSize: 14
        }
    }

    Text
    {
        color: "#ffffff"
        text: parent.name
        anchors.leftMargin: 10
        anchors.left: collapseButton.right
        horizontalAlignment: Text.AlignHLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.family: "Roboto"
        font.pixelSize: 12
    }

    Item
    {
        id: listArea
        visible: collapseButton.checked
//        anchors.topMargin: 10
//        anchors.top: collapseButton.bottom
//        anchors.leftMargin: 10
//        anchors.left: parent.left
//        anchors.bottomMargin: 2
//        anchors.bottom: parent.bottom
//        anchors.rightMargin: 2
//        anchors.right: parent.right
        x: 18
        y: 30
        width: 360
        height: 300

        DeviceListWidget
        {
            id: deviceList
            anchors.fill: parent
        }
    }

}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    height: collapseButton.checked ? collapseButton.height + deviceList.contentItem.height + 20 : collapseButton.height
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
        x: 18
        y: 30
        width: 360
        height: deviceList.contentItem.height + 10

        DeviceListWidget
        {
            id: deviceList
            anchors.fill: parent
        }
    }

}

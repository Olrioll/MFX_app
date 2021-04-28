import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: patchPlate
    height: 40

    property int no
    property string name
    property string imageFile
    property bool checked

    Rectangle
    {
        anchors.fill: parent
        color: patchPlate.checked ? "#27AE60" : "#4f4f4f"
        radius: 2

        Image
        {
            id: deviceImage
            x: 2
            height: 36
            width: 36
            source: patchPlate.imageFile
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle
        {
            id: rect1
            width: 14
            height: 14
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            color: "#828282"
            radius: 4

            Text
            {
                id: no
                anchors.centerIn: parent
                color: "#ffffff"
                text:  patchPlate.no
                font.family: "Roboto"
                font.pixelSize: 10
            }
        }

        Rectangle
        {
            width: 4
            height: 4
            anchors.left: rect1.left
            anchors.top: rect1.top
            color: "#828282"
        }

        Rectangle
        {
            width: 4
            height: 4
            anchors.right: rect1.right
            anchors.bottom: rect1.bottom
            color: "#828282"
        }

        Rectangle
        {
            width: 4
            height: 4
            anchors.left: rect1.left
            anchors.bottom: rect1.bottom
            color: "#828282"
            radius: 2
        }

        ListView
        {
            id: cellListView
            width: parent.width
            anchors.leftMargin: 6
            anchors.topMargin: 2
            anchors.bottomMargin: 2
            anchors.left: deviceImage.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            orientation: ListView.Horizontal
            interactive: false

            delegate: PatchPlateCell
            {
                propertyName: name
                propertyValue: value
            }

            model: ListModel
            {
                id: cellListModel
            }

            Component.onCompleted:
            {
                cellListModel.append({name: "DMX", value: "0"})
                cellListModel.append({name: "min ang", value: "+105"})
                cellListModel.append({name: "max ang", value: "-105"})
                cellListModel.append({name: "RF pos", value: "3"})
                cellListModel.append({name: "RF ch", value: "1"})
                cellListModel.append({name: "height", value: "1"})
            }
        }

        MouseArea
        {
            anchors.fill: parent

            onClicked:
            {
                patchPlate.checked = !patchPlate.checked
            }
        }
    }
}


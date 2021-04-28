import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: patchPlate
    height: 40

    property string name
    property string imageFile

    Rectangle
    {
        anchors.fill: parent
        color: "#4f4f4f"
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

//        Rectangle {
//            id: separator
//            x: 44
//            y: 2
//            width: 2
//            anchors.leftMargin: 4
//            anchors.topMargin: 2
//            anchors.bottomMargin: 2
//            anchors.left: deviceImage.right
//            anchors.top: parent.top
//            anchors.bottom: parent.bottom
//            color: "#ffffff"
//            opacity: 0.1
//        }

        ListView
        {
            id: cellListView
            width: parent.width
            anchors.leftMargin: 2
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

    }
}


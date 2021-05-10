import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: patchPlate
    height: 40
    width: 392

    property var parentList: null
    property int no: 0
    property string name: "Patch Plate"
    property bool withBorder: false
    property string type: ""
    property string imageFile: ""
    property bool checked: false
    property var cells: []
    property var checkedIDs: [] // Заполняется при перетаскивании некольких выделенных плашек

    function getId()
    {
        return cells.get(0).propValue
    }

    function refreshCells()
    {
        cellListModel.clear()
        for(let i = 0; i < cells.count; i++)
            cellListModel.append(cells.get(i))
    }

    Rectangle
    {
        anchors.fill: parent
        color: patchPlate.checked ? "#27AE60" : "#4f4f4f"
        radius: 2
        border.width: 2
        border.color: patchPlate.withBorder ? "lightblue" : "#4f4f4f"

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
                propertyName: propName
                propertyValue: propValue
            }

            model: ListModel
            {
                id: cellListModel
            }

            Component.onCompleted:
            {
                refreshCells()
            }
        }

        MouseArea
        {
            id: mouseArea
            anchors.fill: parent

            onClicked:
            {
                patchPlate.checked = !patchPlate.checked
                if(parentList)
                {
                    project.setCurrentGroup(parentList.groupName)
                }
            }
        }
    }
}


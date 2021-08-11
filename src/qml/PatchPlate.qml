import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: patchPlate
    height: 40
    width: showAction ? 442 : 392

    property var parentList: null
    property int no: 0
    property int patchId
    property string name: "Patch Plate"
    property bool withBorder: false
    property bool halfChecked: isNeedToShowHalfChecked()
    property string type: ""
    property bool checked: isNeedToShowChecked();
    property var checkedIDs: [] // Заполняется при перетаскивании некольких выделенных плашек
    property string imageFile: ""
    property bool isInGroupList: false
    property bool showAction: applicationWindow.screensLayout.currentIndex === 2

    onShowActionChanged: refreshCells()

    function isNeedToShowChecked()
    {
        if(parentList)
        {
            if(parentList.groupName === project.currentGroup())
                return project.patchProperty(patchId, "checked")
            else
                return false
        }

        else
            return project.patchProperty(patchId, "checked")
    }

    function isNeedToShowHalfChecked()
    {
        if(parentList)
        {
            if(parentList.groupName !== project.currentGroup())
                return project.patchProperty(patchId, "checked")
            else
                return false
        }

        return false
    }

    function refreshCells()
    {
        if(patchId <= 0)
            return

        cellListModel.clear()
        var propNamesList = project.patchPropertiesNames(project.patchIndexForId(patchId))
        var propValuesList = project.patchPropertiesValues(project.patchIndexForId(patchId))
        for(let i = 0; i < propNamesList.length; i++)
        {
            let currentPropName = propNamesList[i]
            if(currentPropName !== "posXRatio" && currentPropName !== "posYRatio" && currentPropName !== "checked")
            {
                if(currentPropName === "act")
                {
                    if(showAction)
                        cellListModel.append({propName: propNamesList[i], propValue: String(propValuesList[i])})
                }

                else
                    cellListModel.append({propName: propNamesList[i], propValue: String(propValuesList[i])})
            }
        }

        patchPlate.type = project.patchType(project.patchIndexForId(patchId))

        switch (patchPlate.type)
        {
        case "Sequences" :
            imageFile = "qrc:/device_sequences"
            break;

        case "Pyro" :
            imageFile = "qrc:/device_pyro"
            break;

        case "Shot" :
            imageFile = "qrc:/device_shot"
            break;

        case "Dimmer" :
            imageFile = "qrc:/device_dimmer"
            break;
        }
    }

    Rectangle
    {
        anchors.fill: parent
        color: patchPlate.checked ? "#27AE60" : "#4f4f4f"
        radius: 2
        border.width: 2
        border.color: patchPlate.withBorder ? "lightblue" :
                                              patchPlate.halfChecked ? "#27AE60" : "#4f4f4f"

        Rectangle
        {
            id: imageRect
            anchors.topMargin: 6
            anchors.leftMargin: 8
            anchors.bottomMargin: 6
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: height
            color: "transparent"
        }

        Image
        {
            source: patchPlate.imageFile
            anchors.centerIn: imageRect
            height: imageRect.height
            width: sourceSize.width / sourceSize.height * height
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
            anchors.leftMargin: 10
            anchors.topMargin: 2
            anchors.bottomMargin: 2
            anchors.left: imageRect.right
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

        MfxMouseArea
        {
            id: mouseArea
            anchors.fill: parent
            preventStealing: true

            onEntered:
            {

            }

            onClicked:
            {
                project.setPatchProperty(patchId, "checked", !project.patchProperty(patchId, "checked"))
                if(parentList)
                {
                    project.setCurrentGroup(parentList.groupName)
                }
            }

            onPressed:
            {
//                console.log("here")
            }
        }
    }

    Connections
    {
        target: project
        function onPatchCheckedChanged(checkedId, checked)
        {
            if((checkedId === patchPlate.patchId))
            {
                patchPlate.checked = isNeedToShowChecked()
                patchPlate.halfChecked = isNeedToShowHalfChecked()

            }
        }
    }
}


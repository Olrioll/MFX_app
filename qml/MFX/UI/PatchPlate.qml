import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml.Models 2.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: patchPlate
    height: 40

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
        var patchProperties = project.patchProperties(project.patchIndexForId(patchId))


        if("ID" in patchProperties)
            cellListModel.append({propName: "ID", propValue: patchProperties["ID"]})

        if("DMX" in patchProperties)
            cellListModel.append({propName: "DMX", propValue: patchProperties["DMX"]})

        if("RF ch" in patchProperties)
            cellListModel.append({propName: "RF ch", propValue: patchProperties["RF ch"]})

        if("RF pos" in patchProperties)
            cellListModel.append({propName: "RF pos", propValue: patchProperties["RF pos"]})

        if("max ang" in patchProperties)
            cellListModel.append({propName: "max ang", propValue: patchProperties["max ang"]})

        if("min ang" in patchProperties)
            cellListModel.append({propName: "min ang", propValue: patchProperties["min ang"]})

        if("angle" in patchProperties)
            cellListModel.append({propName: "angle", propValue: patchProperties["angle"]})

        if("channel" in patchProperties)
            cellListModel.append({propName: "channel", propValue: patchProperties["channel"]})

        if("height" in patchProperties)
            cellListModel.append({propName: "height", propValue: patchProperties["height"]})

        if("act" in patchProperties && showAction)
            cellListModel.append({propName: "act", propValue: patchProperties["act"]})

        if("type" in patchProperties)
            patchPlate.type = patchProperties["type"]

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
                font.family: MFXUIS.Fonts.robotoRegular.name
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


        RowLayout {
            anchors.left: imageRect.right
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 10

            Repeater
            {
                id: cellListView

                delegate: PatchPlateCell
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    propertyName: propName
                    propertyValue: propValue
                }

                model: ListModel
                {
                    id: cellListModel
                    dynamicRoles: true
                }

                Component.onCompleted:
                {
                    refreshCells()
                }
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

                if(project.patchProperty(patchId, "checked"))cueContentManager.cleanSelectionRequest()
            }

            onPressed:
            {
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


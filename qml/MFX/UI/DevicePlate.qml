import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: devicePlate
    height: 40

    property string name: "devPlate"
    property string imageFile
    property bool withBorder: false

    Rectangle
    {
        anchors.fill: parent
        color: "#4f4f4f"
        radius: 2
        border.width: 2
        border.color: withBorder ? "lightblue" : "#4f4f4f"

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
            source: devicePlate.imageFile
            anchors.centerIn: imageRect
            height: imageRect.height
            width: sourceSize.width / sourceSize.height * height
        }

        Rectangle {
            id: rectangle
            x: 44
            y: 2
            width: 2
            height: 36
            color: "#ffffff"
            opacity: 0.1
        }

        Text {
            id: titleText
            x: 52
            y: 2
            color: "#ffffff"
            text: qsTr("Name")
            font.family: MFXUIS.Fonts.robotoRegular.name
            font.pixelSize: 10
        }

        Text {
            id: nameText
            x: 52
            y: 20
            color: "#ffffff"
            text: devicePlate.name
            font.family: MFXUIS.Fonts.robotoRegular.name
            font.pixelSize: 12
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:8}
}
##^##*/

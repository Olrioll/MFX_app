import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: devicePlate
    height: 32

    property string name
    property string imageFile

    Rectangle
    {
        anchors.fill: parent
        color: "#4f4f4f"
        radius: 2

        Image
        {
            x: 2
            y: 2
            height: 28
            width: 28
            source: devicePlate.imageFile
        }

        Rectangle {
            id: rectangle
            x: 33
            y: 2
            width: 2
            height: 28
            color: "#ffffff"
            opacity: 0.1
        }

        Text {
            id: titleText
            x: 39
            y: 2
            color: "#ffffff"
            text: qsTr("Name")
            font.family: "Roboto"
            font.pixelSize: 8
        }

        Text {
            id: nameText
            x: 39
            y: 14
            color: "#ffffff"
            text: devicePlate.name
            font.family: "Roboto"
            font.pixelSize: 10
        }

    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:8}
}
##^##*/

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: devicePlate
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
            x: 2
            y: 2
            height: 36
            width: 36
            source: devicePlate.imageFile
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
            font.family: "Roboto"
            font.pixelSize: 10
        }

        Text {
            id: nameText
            x: 52
            y: 20
            color: "#ffffff"
            text: devicePlate.name
            font.family: "Roboto"
            font.pixelSize: 12
        }

    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:8}
}
##^##*/

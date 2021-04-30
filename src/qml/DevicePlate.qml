import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    id: devicePlate
    height: 40

    property string name
    property string imageFile
    property bool held: false

    Drag.active: held
    Drag.source: mouseArea
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2

    Rectangle
    {
        anchors.fill: parent
        color: "#4f4f4f"
        radius: 2
        border.width: 2
        border.color: devicePlate.held ? "lightblue" : "#4f4f4f"

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

        states: State {
                            when: devicePlate.held

                            ParentChange { target: devicePlate; parent: patchScreen }
                            AnchorChanges {
                                target: devicePlate
                                anchors { horizontalCenter: undefined; verticalCenter: undefined; left: undefined; right: undefined }
                            }
                        }

        MouseArea
        {
            id: mouseArea
            anchors.fill: parent

            drag.target: devicePlate.held ? devicePlate : undefined
            drag.axis: Drag.XAndYAxis

            onPressed: devicePlate.held = true
            onReleased: devicePlate.held = false


        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:8}
}
##^##*/

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
    id: sideDockedWindow
    width: collapsedRect.width

    StackLayout
    {
        id: layout
        anchors.fill: parent

        Rectangle
        {
            id: collapsedRect
            width: 22
            radius: 2
            color: "#444444"
            Layout.fillHeight: true

            Button
            {
                id: expandButton
                width: 20
                height: 20
                anchors.right: parent.right

                bottomPadding: 0
                topPadding: 0
                rightPadding: 0
                leftPadding: 0

                background: Rectangle {
                        color: "#444444"
                        opacity: 0
                        radius: 2
                    }

                Image
                {
                    source: "qrc:/expandButton"
                }

    //            onClicked: utilityWindow.visible = false
            }
        }

        Rectangle
        {
            id: expandedRect
            width: 120
            radius: 2
            color: "#444444"
            Layout.fillHeight: true

            Button
            {
                id: collapseButton
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.top: parent.top

                bottomPadding: 0
                topPadding: 0
                rightPadding: 0
                leftPadding: 0

                background: Rectangle {
                        color: "#444444"
                        opacity: 0
                        radius: 2
                    }

                Image
                {
                    source: "qrc:/collapseButton"
                }

    //            onClicked: utilityWindow.visible = false
            }
        }
    }
}

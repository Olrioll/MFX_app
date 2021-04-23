import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item {

    id: menuItem
    height: 28

    signal closeApp
    signal hideApp
    signal fullSizeApp

    Rectangle
    {
        anchors.fill: parent
        color: "#111111"

        Button
        {
            id: hideButton
            x: fullButton.x - width - 1
            width: 28
            height: 28

            bottomPadding: 0
            topPadding: 0
            rightPadding: 0
            leftPadding: 0

            Image
            {
                source: "qrc:/hideButton"
            }

            onClicked: menuItem.hideApp()
        }

        Button
        {
            id: fullButton
            x: closeButton.x - width - 1
            width: 28
            height: 28

            bottomPadding: 0
            topPadding: 0
            rightPadding: 0
            leftPadding: 0

            Image
            {
                source: "qrc:/fullButton"
            }

            onClicked: menuItem.fullSizeApp()
        }

        Button
        {
            id: closeButton
            width: 28
            height: 28
            anchors.right: parent.right

            bottomPadding: 0
            topPadding: 0
            rightPadding: 0
            leftPadding: 0

            Image
            {
                source: "qrc:/closeButton"
            }

            onClicked: menuItem.closeApp()
        }
    }
}

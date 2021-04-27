import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
    id: deviceLibWindow
    width: collapsedRect.width

    property int collapsedWidth: 22
    property int expandedWidth: 120
    property string caption: "Caption"

    property int previousX

    StackLayout
    {
        id: layout
        anchors.fill: parent

        Rectangle
        {
            id: collapsedRect
            width: deviceLibWindow.collapsedWidth
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

                onClicked:
                {
                    deviceLibWindow.width = deviceLibWindow.expandedWidth
                    layout.currentIndex = 1
                }
            }

            Rectangle
            {
                id: rotatedTextRect
                x: parent.x
                y: parent.y + 22
                width: parent.width
                height: collapsedCaptionText.width
                visible: false
            }

            Text
            {
                id: collapsedCaptionText
                color: "#ffffff"
                text: deviceLibWindow.caption
                elide: Text.ElideMiddle
                anchors.centerIn: rotatedTextRect
                rotation: 90
            }
        }

        Rectangle
        {
            id: expandedRect
            width: deviceLibWindow.expandedWidth
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

                onClicked:
                {
                    deviceLibWindow.width = deviceLibWindow.collapsedWidth
                    layout.currentIndex = 0
                }
            }

            Text
            {
                color: "#ffffff"
                text: deviceLibWindow.caption
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideMiddle
                anchors.left: parent.left
                font.family: "Roboto"
                topPadding: 2
                leftPadding: 10
            }

            Rectangle
            {
                id: workArea
                anchors.topMargin: 22
                anchors.bottomMargin: 2
                anchors.leftMargin: 2
                anchors.rightMargin: 2
                anchors.fill: parent
                color: "#000000"

                ListView
                {
                    id: deviceListView
                    height: contentItem.height
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: 2
                    spacing: 2

                    delegate: DevicePlate
                    {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 2
                        name: id
                        imageFile: img
                    }

                    model: ListModel
                    {
                        id: deviceListModel
                    }
                }

                Component.onCompleted:
                {
                    deviceListModel.append({id: "Sequences", img: "qrc:/device_sequences"})
                    deviceListModel.append({id: "Dimmer", img: "qrc:/device_dimmer"})
                    deviceListModel.append({id: "Shot", img: "qrc:/device_shot"})
                    deviceListModel.append({id: "Pyro", img: "qrc:/device_pyro"})
                }
            }
        }
    }

    MouseArea
    {
        id: resizeArea
        width: 4
        visible: layout.currentIndex

        anchors
        {
            top: deviceLibWindow.top
            bottom: deviceLibWindow.bottom
            left: deviceLibWindow.left
        }
        cursorShape: Qt.SizeHorCursor

        onPressed:
        {
            deviceLibWindow.previousX = mouseX
        }

        onMouseXChanged:
        {
            var dx = mouseX - deviceLibWindow.previousX
            deviceLibWindow.width = deviceLibWindow.width - dx
        }
    }
}

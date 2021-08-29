import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
    id: sideDockedWindow
    width: isExpanded ? expandedWidth : collapsedWidth

    property bool isExpanded: false
    property int collapsedWidth: 28
    property int expandedWidth: contentItem.width
    property int minWidth: expandedWidth
    property string caption: "Caption"
    property var contentItem: null

    property int previousX

    function setActive(state)
    {
        if(state)
        {
            sideDockedWindow.enabled = true
        }

        else
        {
            sideDockedWindow.width = sideDockedWindow.collapsedWidth
            layout.currentIndex = 0
            sideDockedWindow.isExpanded = false
            sideDockedWindow.enabled = false
        }
    }


    StackLayout
    {
        id: layout
        anchors.fill: parent

        Rectangle
        {
            id: collapsedRect
            width: sideDockedWindow.collapsedWidth
            radius: 2
            color: "#444444"
            Layout.fillHeight: true

            Button
            {
                id: expandButton
                height: 20
                width: 20
                x: 4
                y: 4
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
                    sideDockedWindow.isExpanded = true
                    sideDockedWindow.width = sideDockedWindow.expandedWidth
                    layout.currentIndex = 1
                }
            }

            Rectangle
            {
                id: rotatedTextRect
                x: parent.x
                y: parent.y + 30
                width: parent.width
                height: collapsedCaptionText.width
                visible: false
            }

            Text
            {
                id: collapsedCaptionText
                color: "#ffffff"
                text: sideDockedWindow.caption
                elide: Text.ElideMiddle
                anchors.centerIn: rotatedTextRect
                font.family: "Roboto"
                font.pixelSize: 12
                rotation: 90
            }
        }

        Rectangle
        {
            id: expandedRect
            width: sideDockedWindow.expandedWidth
            radius: 2
            color: "#444444"
            Layout.fillHeight: true

            Button
            {
                id: collapseButton
                width: 20
                height: 20
                anchors.topMargin: 4
                anchors.rightMargin: 4
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
                    sideDockedWindow.isExpanded = false
                    sideDockedWindow.width = sideDockedWindow.collapsedWidth
                    layout.currentIndex = 0
                }
            }

            Text
            {
                color: "#ffffff"
                text: sideDockedWindow.caption
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideMiddle
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.family: "Roboto"
                topPadding: 6
                leftPadding: 10
            }

            Rectangle
            {
                id: workArea
                anchors.topMargin: 28
                anchors.bottomMargin: 2
                anchors.leftMargin: 2
                anchors.rightMargin: 2
                anchors.fill: parent

                clip: true
                color: "#000000"
            }
        }
    }

    Component.onCompleted:
    {
        if(contentItem)
        {
            contentItem.parent = workArea
            contentItem.anchors.margins = 2
            contentItem.anchors.left = workArea.left
            contentItem.anchors.top = workArea.top
            contentItem.anchors.bottom = workArea.bottom
        }
    }

    Connections
    {
        target: contentItem
        function onWidthChanged()
        {
            expandedWidth = contentItem.width
            width = isExpanded ? expandedWidth : collapsedWidth
        }
    }
}

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import WaveformWidget 1.0
import "qrc:/"

ApplicationWindow
{
    id: applicationWindow
    width: 1280
    height: 960
    visible: true
    color: "#000000"
    title: qsTr("MFX")
    flags: Qt.Window | Qt.FramelessWindowHint

    property int previousX
    property int previousY

    function childWidgetsArea()
    {
        return {x:0, width:width, y:mainMenu.height, height:height}
    }

    Item
    {
        id: mainMenu
        height: 28
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        MouseArea
        {
            id: topResizeArea
            height: 5
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            cursorShape: Qt.SizeVerCursor

            onPressed:
            {
                applicationWindow.previousY = mouseY
            }

            onMouseYChanged:
            {
                var dy = mouseY - applicationWindow.previousY
                applicationWindow.setY(applicationWindow.y + dy)
                applicationWindow.setHeight(applicationWindow.height - dy)
            }
        }

        MouseArea
        {
            id: appWindowMoveArea
            height: mainMenu.height - topResizeArea.height
            anchors.top: topResizeArea.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            onPressed:
            {
                applicationWindow.previousX = mouseX
                applicationWindow.previousY = mouseY
            }

            onMouseXChanged:
            {
                var dx = mouseX - applicationWindow.previousX
                applicationWindow.setX(applicationWindow.x + dx)
            }

            onMouseYChanged:
            {
                var dy = mouseY - applicationWindow.previousY
                applicationWindow.setY(applicationWindow.y + dy)
            }
        }

        Rectangle
        {
            anchors.fill: parent
            color: "#111111"

            ButtonGroup
            {
                id: mainMenuButtons
            }

            Image
            {
                id: logoImage
                source: "qrc:/menuLogo"
                x: parent.x + 10
            }

            Button
            {
                id: fileMenuButton
                text: "File"
                width: 40
                height: 28
                x: logoImage.x + logoImage.width + 10
                layer.enabled: false
                font.pointSize: 12
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#222222" : "#111111"
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: "Roboto"
                }

                ButtonGroup.group: mainMenuButtons
            }

            Button
            {
                id: patchMenuButton
                text: "Patch"
                width: 40
                height: 28
                anchors.left: fileMenuButton.right
                layer.enabled: false
                font.pointSize: 12
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#222222" : "#111111"
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: "Roboto"
                }

                ButtonGroup.group: mainMenuButtons
            }

            Button
            {
                id: mainMenuButton
                text: "Main"
                width: 40
                height: 28
                anchors.left: patchMenuButton.right
                layer.enabled: false
                font.pointSize: 12
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#222222" : "#111111"
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: "Roboto"
                }

                ButtonGroup.group: mainMenuButtons
            }

            Button
            {
                id: outputMenuButton
                text: "Output"
                width: 48
                height: 28
                anchors.left: mainMenuButton.right
                layer.enabled: false
                font.pointSize: 12
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#222222" : "#111111"
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: "Roboto"
                }

                ButtonGroup.group: mainMenuButtons
            }

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

                onClicked: applicationWindow.showMinimized()

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

                onClicked: applicationWindow.showMaximized()
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

                onClicked: Qt.quit()
            }
        }
    }

    MouseArea
    {
        id: bottomResizeArea
        height: 5
        anchors
        {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        cursorShape: Qt.SizeVerCursor

        onPressed:
        {
            applicationWindow.previousY = mouseY
        }

        onMouseYChanged:
        {
            var dy = mouseY - applicationWindow.previousY
            applicationWindow.setHeight(applicationWindow.height + dy)
        }
    }

    MouseArea
    {
        id: leftResizeArea
        width: 5
        anchors
        {
            top: mainMenu.bottom
            bottom: bottomResizeArea.top
            left: parent.left
        }
        cursorShape: Qt.SizeHorCursor

        onPressed:
        {
            applicationWindow.previousX = mouseX
        }

        onMouseXChanged:
        {
            var dx = mouseX - applicationWindow.previousX
            applicationWindow.setX(applicationWindow.x + dx)
            applicationWindow.setWidth(applicationWindow.width - dx)
        }
    }

    MouseArea
    {
        id: rightResizeArea
        width: 5
        anchors
        {
            top: mainMenu.bottom
            bottom: bottomResizeArea.top
            right: parent.right
        }
        cursorShape:  Qt.SizeHorCursor

        onPressed:
        {
            applicationWindow.previousX = mouseX
        }

        onMouseXChanged:
        {
            var dx = mouseX - applicationWindow.previousX
            applicationWindow.setWidth(applicationWindow.width + dx)
        }
    }

    StackLayout
    {
        id: screensLayout
        anchors
        {
            top: mainMenu.bottom
            bottom: bottomResizeArea.top
            right: rightResizeArea.left
            left: leftResizeArea.right
        }

        WaveformWidget
        {
            id: waveformWidget
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            MouseArea
            {
                anchors.fill: parent
                onWheel: (wheel.angleDelta.y > 0) ? waveformWidget.zoomOut()
                                                  : waveformWidget.zoomIn()
            }

            Slider
            {
                id: slider
                anchors.bottom: parent.bottom
            }
        }
    }

    Button
    {
        text: "Create window"
        anchors.top: mainMenu.bottom
        onClicked:
        {
            var test = Qt.createComponent("UtilityWindow.qml").createObject(applicationWindow);
            test.x = 100
            test.y = 100
            test.caption = "Preferences"
        }
    }

    Connections
    {
        target: slider
        function onMoved()
        {
            waveformWidget.moveVisibleRange(slider.position);
        }
    }
}

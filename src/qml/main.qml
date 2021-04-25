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
    x: 300
    y: 70
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
                text: qsTr("File")
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

//                ButtonGroup.group: mainMenuButtons
            }

            Button
            {
                id: patchMenuButton
                text: qsTr("Patch")
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
                text: qsTr("Main")
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
                text: qsTr("Output")
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
                id: keyButton
                text: qsTr("Key")
                width: 60
                height: 24
                x: outputMenuButton.x + outputMenuButton.width + 30
                y: mainMenu.y + 2
                layer.enabled: false
                font.pointSize: 12
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#5F27CD" : "#222222"
                    radius: 2
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: "Roboto"
                }
            }

            Button
            {
                id: midiButton
                text: "MIDI"
                width: 60
                height: 24
                x: keyButton.x + keyButton.width + 10
                y: mainMenu.y + 2
                layer.enabled: false
                font.pointSize: 12
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#6BAAFF" : "#222222"
                    radius: 2
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: "Roboto"
                }
            }

            Button
            {
                id: dmxButton
                text: qsTr("DMX out")
                width: 60
                height: 24
                x: midiButton.x + midiButton.width + 10
                y: mainMenu.y + 2
                layer.enabled: false
                font.pointSize: 12
                checkable: true

                bottomPadding: 2
                topPadding: 2
                rightPadding: 2
                leftPadding: 2

                background: Rectangle {
                    color: parent.checked ? "#EB5757" : "#222222"
                    radius: 2
                }

                contentItem: Text {
                    color: parent.checked ? "#ffffff" : "#777777"
                    text: parent.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.family: "Roboto"
                }
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

        //Drop-down list of "File" menu item

        Item
        {
            id: fileItemList
            visible: fileMenuButton.checked

            Rectangle
            {
                id: newActionRect
                x: fileMenuButton.x
                y: mainMenu.height
                width: 100
                height: 28
                color: newActionMouseArea.containsMouse ? "#333333" : "#222222"

                Text
                {
                    id: newActionText
                    color: newActionMouseArea.containsMouse ? "#ffffff" : "#777777"
                    text: qsTr("New")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Roboto"
                    topPadding: 5
                    leftPadding: 10
                }

                MouseArea
                {
                    id: newActionMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: fileMenuButton.checked = false
                }
            }

            Rectangle
            {
                id: openActionRect
                x: fileMenuButton.x
                y: newActionRect.y + newActionRect.height
                width: 100
                height: 28
                color: openActionMouseArea.containsMouse ? "#333333" : "#222222"

                Text
                {
                    id: openActionText
                    color: openActionMouseArea.containsMouse ? "#ffffff" : "#777777"
                    text: qsTr("Open")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Roboto"
                    topPadding: 5
                    leftPadding: 10
                }

                MouseArea
                {
                    id: openActionMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: fileMenuButton.checked = false
                }
            }

            Rectangle
            {
                id: saveActionRect
                x: fileMenuButton.x
                y: openActionRect.y + openActionRect.height
                width: 100
                height: 28
                color: saveActionMouseArea.containsMouse ? "#333333" : "#222222"

                Text
                {
                    id: saveActionText
                    color: saveActionMouseArea.containsMouse ? "#ffffff" : "#777777"
                    text: qsTr("Save")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Roboto"
                    topPadding: 5
                    leftPadding: 10
                }

                Image
                {
                    source: saveActionMouseArea.containsMouse ? "qrc:/itemArrow_hovered" : "qrc:/itemArrow"
                    x: 90
                    y: 10
                }

                MouseArea
                {
                    id: saveActionMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: saveItemsList.visible = true
                    onExited: saveItemsList.visible = false
                }
            }

            Rectangle
            {
                id: exportActionRect
                x: fileMenuButton.x
                y: saveActionRect.y + saveActionRect.height
                width: 100
                height: 28
                color: exportActionMouseArea.containsMouse ? "#333333" : "#222222"

                Text
                {
                    id: exportActionText
                    color: exportActionMouseArea.containsMouse ? "#ffffff" : "#777777"
                    text: qsTr("Export")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Roboto"
                    topPadding: 5
                    leftPadding: 10
                }

                MouseArea
                {
                    id: exportActionMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: fileMenuButton.checked = false
                }
            }

            Rectangle
            {
                id: preferencesActionRect
                x: fileMenuButton.x
                y: exportActionRect.y + exportActionRect.height - 2
                width: 100
                height: 30
                radius: 2
                color: preferencesActionMouseArea.containsMouse ? "#333333" : "#222222"

                Rectangle
                {
                    width: 4
                    height: 4
                    anchors.top: parent.top
                    anchors.left: parent.left
                    color: preferencesActionMouseArea.containsMouse ? "#333333" : "#222222"
                }

                Rectangle
                {
                    width: 4
                    height: 4
                    anchors.top: parent.top
                    anchors.right: parent.right
                    color: preferencesActionMouseArea.containsMouse ? "#333333" : "#222222"
                }

                Text
                {
                    id: preferencesActionText
                    color: preferencesActionMouseArea.containsMouse ? "#ffffff" : "#777777"
                    text: qsTr("Preferences")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Roboto"
                    topPadding: 5
                    leftPadding: 10
                }

                MouseArea
                {
                    id: preferencesActionMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked:
                    {
                        fileMenuButton.checked = false
                        var test = Qt.createComponent("UtilityWindow.qml").createObject(applicationWindow);
                        test.x = 100
                        test.y = 100
                        test.caption = "Preferences"
                    }
                }
            }
        }

        //sub list for "Save" menu item

        Item
        {
            id: saveItemsList
            visible: false

            Rectangle
            {
                id: projectActionRect
                x: openActionRect.x + openActionRect.width
                y: openActionRect.y
                width: 100
                height: 28
                color: projectActionMouseArea.containsMouse ? "#333333" : "#222222"

                Text
                {
                    id: projectActionext
                    color: projectActionMouseArea.containsMouse ? "#ffffff" : "#777777"
                    text: qsTr("Project")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Roboto"
                    topPadding: 5
                    leftPadding: 10
                }

                MouseArea
                {
                    id: projectActionMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: saveItemsList.visible = true
                    onExited: saveItemsList.visible = false

                    onClicked:
                    {
                        saveItemsList.visible = false
                        fileMenuButton.checked = false
                    }
                }
            }

            Rectangle
            {
                id: workspaceActionRect
                x: projectActionRect.x
                y: projectActionRect.y + projectActionRect.height
                width: 100
                height: 28
                color: workspaceActionMouseArea.containsMouse ? "#333333" : "#222222"

                Text
                {
                    id: workspaceActionText
                    color: workspaceActionMouseArea.containsMouse ? "#ffffff" : "#777777"
                    text: qsTr("Workspace")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Roboto"
                    topPadding: 5
                    leftPadding: 10
                }

                MouseArea
                {
                    id: workspaceActionMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: saveItemsList.visible = true
                    onExited: saveItemsList.visible = false

                    onClicked:
                    {
                        saveItemsList.visible = false
                        fileMenuButton.checked = false
                    }
                }
            }

            Rectangle
            {
                id: patchActionRect
                x: workspaceActionRect.x
                y: workspaceActionRect.y + workspaceActionRect.height
                width: 100
                height: 28
                color: patchActionMouseArea.containsMouse ? "#333333" : "#222222"

                Text
                {
                    id: patchActionText
                    color: patchActionMouseArea.containsMouse ? "#ffffff" : "#777777"
                    text: qsTr("Patch")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Roboto"
                    topPadding: 5
                    leftPadding: 10
                }

                MouseArea
                {
                    id: patchActionMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: saveItemsList.visible = true
                    onExited: saveItemsList.visible = false

                    onClicked:
                    {
                        saveItemsList.visible = false
                        fileMenuButton.checked = false
                    }
                }
            }
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

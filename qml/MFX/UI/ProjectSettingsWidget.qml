import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: projectSettingsWidget
    width: 336
    height: 286

    property bool isNewProject: true
    property string caption: qsTr("Project settings")
    property string choosenImageFile
    property string choosenAudioFile

    signal createButtonClicked

    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        radius: 2
        color: "#444444"

        MouseArea
        {
            id: mouseArea
            height: 28
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            drag.target: projectSettingsWidget
            drag.axis: Drag.XandYAxis

            drag.minimumX: applicationWindow.childWidgetsArea().x
            drag.maximumX: applicationWindow.childWidgetsArea().width - projectSettingsWidget.width
            drag.minimumY: applicationWindow.childWidgetsArea().y
            drag.maximumY: applicationWindow.childWidgetsArea().height - projectSettingsWidget.height
        }

        Text
        {
            color: "#ffffff"
            text: projectSettingsWidget.caption
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideMiddle
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: MFXUIS.Fonts.robotoRegular.name
            topPadding: 8
        }

        Button
        {
            id: closeButton
            width: 25
            height: 25
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.right: parent.right

            bottomPadding: 0
            topPadding: 0
            rightPadding: 0
            leftPadding: 0

            background: Rectangle {
                    color: "#444444"
                    opacity: 0
                }

            Image
            {
                source: "qrc:/utilityCloseButton"
            }

            onClicked:
            {
                applicationWindow.isPatchEditorOpened = false
                patchScreen.deviceLibWidget.setActive(true)
                patchScreen.deviceListWidget.setActive(true)
                patchScreen.groupListWidget.setActive(true)
                projectSettingsWidget.visible = false
            }
        }

        Rectangle
        {
            id: workArea1

            width: 156
            height: 70
            anchors.topMargin: 28
            anchors.rightMargin: 8

            anchors
            {
                top: parent.top
                right: parent.right
            }

            radius: 2
            color: "#222222"

            Text
            {
                x: 7
                y: 5
                width: 70
                height: 17
                color: widthField.isActiveInput ? "#27AE60" : "#ffffff"
                text: qsTr("Scene")
                horizontalAlignment: Text.AlignHLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideMiddle
                font.family: MFXUIS.Fonts.robotoRegular.name
            }

            TextField
            {
                id: widthField
                x: 8
                y: 43
                width: 50
                height: 18
                text: isNewProject ? "" : project.property("sceneFrameWidth")
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                padding: 0
                leftPadding: -2
                font.pointSize: 8

                background: Rectangle
                {
                    color: "#000000"
                    radius: 2
                }

                onFocusChanged:
                {

                }
            }

            TextField {
                id: heightField
                x: 86
                y: 43
                width: 50
                height: 18
                color: "#ffffff"
                text: isNewProject ? "" : project.property("sceneFrameHeight")
                horizontalAlignment: Text.AlignHCenter
                leftPadding: -2
                font.pointSize: 8
                background: Rectangle {
                    color: "#000000"
                    radius: 2
                }
                padding: 0
            }

            Text {
                id: quantityText1
                x: 0
                y: 27
                width: 44
                height: 17
                color: widthField.isActiveInput ? "#27AE60" : "#ffffff"
                text: qsTr("Width")
                elide: Text.ElideMiddle
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 10
            }

            Text {
                id: quantityText2
                x: 85
                y: 27
                width: 34
                height: 17
                color: widthField.isActiveInput ? "#27AE60" : "#ffffff"
                text: qsTr("Height")
                elide: Text.ElideMiddle
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 10
            }

            Text {
                id: quantityText3
                x: 56
                y: 44
                width: 20
                height: 17
                color: widthField.isActiveInput ? "#27AE60" : "#ffffff"
                text: qsTr("m")
                elide: Text.ElideMiddle
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: MFXUIS.Fonts.robotoRegular.name
            }

            Text {
                id: quantityText4
                x: 135
                y: 44
                width: 20
                height: 17
                color: widthField.isActiveInput ? "#27AE60" : "#ffffff"
                text: qsTr("m")
                elide: Text.ElideMiddle
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: MFXUIS.Fonts.robotoRegular.name
            }
        }

        Rectangle
        {
            id: workArea2

            width: 156
            height: 70
            anchors.topMargin: 28
            anchors.leftMargin: 8

            anchors
            {
                top: parent.top
                left: parent.left
            }

            radius: 2
            color: "#222222"

            Text
            {
                x: 7
                y: 5
                width: 70
                height: 17
                color: widthField.isActiveInput ? "#27AE60" : "#ffffff"
                text: qsTr("About")
                horizontalAlignment: Text.AlignHLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideMiddle
                font.family: MFXUIS.Fonts.robotoRegular.name
            }

            Text {
                id: projectNameText
                x: 8
                y: 27
                width: 140
                height: 17
                color: widthField.isActiveInput ? "#27AE60" : "#ffffff"
                text: qsTr("Project Name")
                elide: Text.ElideMiddle
                horizontalAlignment: Text.AlignHLeft
                verticalAlignment: Text.AlignVCenter
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 10
            }

            TextField
            {
                id: projectNameField
                x: 8
                y: 43
                width: 140
                height: 18

                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                padding: 0
                leftPadding: -2
                font.pointSize: 8

                background: Rectangle
                {
                    color: "#000000"
                    radius: 2
                }

                text: project.currentProjectName

                onEditingFinished: () => {
                    project.currentProjectName = text
                }
            }
        }

        Rectangle
        {
            id: workArea3

            width: 156
            height: 140
            anchors.margins: 8
            anchors
            {
                top: workArea1.bottom
                left: parent.left
            }

            radius: 2
            color: "#222222"

            Text
            {
                x: 7
                y: 5
                width: 70
                height: 17
                color: widthField.isActiveInput ? "#27AE60" : "#ffffff"
                text: qsTr("Music Track")
                horizontalAlignment: Text.AlignHRight
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideMiddle
                font.family: MFXUIS.Fonts.robotoRegular.name
            }

            Rectangle
            {
                width: 140
                height: 90
                x: 9
                y: 30

                radius: 2
                color: "#000000"

                Image
                {
                    id: trackPlaceholderImage
                    x: (parent.width - width) / 2
                    y: 20
                    source: "qrc:/trackPlaceholder"
                }


                Text {
                    id: trackButtonText
                    anchors.topMargin: 56
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    color: "#888888"
                    text: choosenAudioFile
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: MFXUIS.Fonts.robotoRegular.name
                    font.pixelSize: 10

                    visible: choosenAudioFile !== ""
                }

                Text {
                    id: defaultTrackButtonText
                    anchors.topMargin: 56
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter

                    color: "#888888"
                    text: qsTr("Click on the area\nto load the track")
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: MFXUIS.Fonts.robotoRegular.name
                    font.pixelSize: 10

                    visible: !trackButtonText.visible
                }

                MouseArea
                {
                    anchors.fill: parent

                    onClicked:
                    {
                        let trackFileName = project.selectAudioTrackDialog()
                        if(trackFileName)
                        {
                            choosenAudioFile = trackFileName
                            trackButtonText.text = choosenAudioFile
                        }
                    }
                }
            }
        }

        Rectangle
        {
            id: workArea4

            width: 156
            height: 140
            anchors.margins: 8
            anchors
            {
                top: workArea2.bottom
                right: parent.right
            }

            radius: 2
            color: "#222222"

            Text
            {
                x: 7
                y: 5
                width: 70
                height: 17
                color: widthField.isActiveInput ? "#27AE60" : "#ffffff"
                text: qsTr("Image")
                horizontalAlignment: Text.AlignHRight
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideMiddle
                font.family: MFXUIS.Fonts.robotoRegular.name
            }

            Rectangle
            {
                width: 140
                height: 90
                x: 9
                y: 30

                radius: 2
                color: "#000000"

                Image
                {
                    id: placeholderImage
                    x: (parent.width - width) / 2
                    y: 20
                    source: "qrc:/imagePlaceholder"
                }


                Text {
                    id: buttonText
                    anchors.topMargin: 56
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter

                    color: "#888888"
                    text: qsTr("Click on the area\nto load the image")
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: MFXUIS.Fonts.robotoRegular.name
                    font.pixelSize: 10
                }

                Image
                {
                    id: previewImage
                    anchors.fill: parent
                    source: projectSettingsWidget.choosenImageFile === "" ? "" : "file:///" + projectSettingsWidget.choosenImageFile
                }

                MouseArea
                {
                    anchors.fill: parent

                    onClicked:
                    {
                        projectSettingsWidget.choosenImageFile = project.selectBackgroundImageDialog();
                    }
                }
            }
        }

        MfxButton
        {
            id: setButton

            color: "#2F80ED"
            width: 140
            anchors.margins: 8
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            enabled: Number(widthField.text) > 0.4 &&
                     Number(heightField.text) > 0.4 &&
                     (Number(widthField.text) >= Number(heightField.text) ?
                     Number(widthField.text) / Number(heightField.text) <= 10 : Number(heightField.text) / Number(widthField.text) <= 10)

            text: isNewProject ? qsTr("Create") : qsTr("Apply")

            onClicked:
            {
                project.setProperty("sceneFrameWidth", Number(widthField.text))
                project.setProperty("sceneFrameHeight", Number(heightField.text))

                if(Number(widthField.text) >= Number(heightField.text))
                    project.setProperty("sceneImageWidth", Number(widthField.text) * 2)
                else
                    project.setProperty("sceneImageWidth", Number(widthField.text) * 20)


                if(projectSettingsWidget.choosenImageFile !== "")
                {
                    project.setBackgroundImage(projectSettingsWidget.choosenImageFile)
                    sceneWidget.backgroundImage.source = "file:///" + settingsManager.workDirectory() + "/" + project.property("backgroundImageFile")
                }

                sceneWidget.centerBackgroundImage()

                // Центруем рамку по фоновой картинке
                let xPos = ((sceneWidget.backgroundImage.width - project.property("sceneFrameWidth") / project.property("sceneImageWidth") * sceneWidget.backgroundImage.width) / 2) / sceneWidget.backgroundImage.width
                project.setProperty("sceneFrameX", xPos)

//                let yPos = ((sceneWidget.backgroundImage.height - project.property("sceneFrameHeight") / project.property("sceneImageHeight") * sceneWidget.backgroundImage.height) / 2) / sceneWidget.backgroundImage.height
                project.setProperty("sceneFrameY", 0.3)

                if(choosenAudioFile !== "")
                {
                    mainScreen.playerWidget.waitingText.text = qsTr("Downloading...")
                    project.setAudioTrack(choosenAudioFile)
                }

                sceneWidget.sceneFrameItem.restorePreviousGeometry()
                sceneWidget.sceneFrameItem.visible = true
                applicationWindow.isPatchEditorOpened = false
                projectSettingsWidget.visible = false
                if(isNewProject)
                {
                    projectSettingsWidget.createButtonClicked()
                }
            }
        }

    }
}

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

import MFX.UI.Components.Templates 1.0 as MFXUICT
import MFX.UI.Styles 1.0 as MFXUIS

Item
{
    id: projectSettingsWidget
    width: 336
    height: 286

    property bool isNewProject: true
    property string caption: translationsManager.translationTrigger + qsTr("Project settings")
    property string choosenImageFile
    property string choosenAudioFile

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
                projectSettingsWidget.visible = false

                //patchScreen.deviceLibWidget.setActive(true)
                //patchScreen.deviceListWidget.setActive(true)
                //patchScreen.groupListWidget.setActive(true)
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
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.topMargin: 8
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 10
                color: "#A1A1A1"
                text: translationsManager.translationTrigger + qsTr("Scene")
                horizontalAlignment: Text.AlignHLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideMiddle
            }

            TextField
            {
                id: widthField
                x: 6
                y: 43
                width: 50
                height: 18
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 8
                padding: 0

                background: Rectangle
                {
                    color: "#000000"
                    radius: 2
                }

                onFocusChanged:
                {

                }
            }

            TextField
            {
                id: heightField
                x: 86
                y: 43
                width: 50
                height: 18
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 8
                padding: 0
                background: Rectangle
                {
                    color: "#000000"
                    radius: 2
                }
            }

            Text {
                id: quantityText1
                x: 0
                y: 27
                width: 50
                height: 17
                color: widthField.isActiveInput ? "#27AE60" : "#ffffff"
                text: translationsManager.translationTrigger + qsTr("Width")
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
                width: 50
                height: 17
                color: widthField.isActiveInput ? "#27AE60" : "#ffffff"
                text: translationsManager.translationTrigger + qsTr("Height")
                elide: Text.ElideMiddle
                horizontalAlignment: Text.AlignLeft
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
                text: translationsManager.translationTrigger + qsTr("m")
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
                text: translationsManager.translationTrigger + qsTr("m")
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
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.topMargin: 8
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 10
                color: "#A1A1A1"
                text: translationsManager.translationTrigger + qsTr("About")
                horizontalAlignment: Text.AlignHLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideMiddle
            }

            Text {
                id: projectNameText
                x: 8
                y: 27
                width: 140
                height: 17
                color: widthField.isActiveInput ? "#27AE60" : "#ffffff"
                text: translationsManager.translationTrigger + qsTr("Project Name")
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
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.topMargin: 8
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 10
                color: "#A1A1A1"
                text: translationsManager.translationTrigger + qsTr("Music Track")
                horizontalAlignment: Text.AlignHRight
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideMiddle
            }

            Rectangle
            {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.bottomMargin: 8
                anchors.topMargin: 26

                radius: 2
                color: "#000000"

                Image
                {
                    id: trackPlaceholderImage
                    x: (parent.width - width) / 2
                    y: 20
                    source: "qrc:/trackPlaceholder"
                }


                Text
                {
                    id: trackButtonText
                    anchors.topMargin: 56
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    color: "#888888"
                    text: project.fileName( choosenAudioFile )
                    elide: Text.ElideLeft
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: MFXUIS.Fonts.robotoRegular.name
                    font.pixelSize: 10

                    visible: choosenAudioFile !== ""
                }

                Text
                {
                    id: defaultTrackButtonText
                    anchors.topMargin: 56
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    wrapMode: Text.WordWrap
                    color: "#888888"
                    text: translationsManager.translationTrigger + qsTr("Click on the area\nto load the track")
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
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.topMargin: 8
                font.family: MFXUIS.Fonts.robotoRegular.name
                font.pixelSize: 10
                color: "#A1A1A1"
                text: translationsManager.translationTrigger + qsTr("Image")
                horizontalAlignment: Text.AlignHRight
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideMiddle
            }

            Rectangle
            {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.bottomMargin: 8
                anchors.topMargin: 26

                radius: 2
                color: "#000000"

                Image
                {
                    id: placeholderImage
                    x: (parent.width - width) / 2
                    y: 20
                    source: "qrc:/imagePlaceholder"
                }

                Text
                {
                    id: defaultImageButtonText
                    anchors.topMargin: 56
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    wrapMode: Text.WordWrap
                    color: "#888888"
                    text: translationsManager.translationTrigger + qsTr("Click on the area\nto load the image")
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: MFXUIS.Fonts.robotoRegular.name
                    font.pixelSize: 10

                    visible: choosenImageFile === ""
                }

                Image
                {
                    id: previewImage
                    anchors.fill: parent
                    source: "file:///" + choosenImageFile
                }

                MouseArea
                {
                    anchors.fill: parent

                    onClicked:
                    {
                        let imageFile = project.selectBackgroundImageDialog();
                        if( imageFile )
                        {
                            choosenImageFile = imageFile
                        }
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

            text: translationsManager.translationTrigger + (isNewProject ? qsTr("Create") : qsTr("Apply"))

            onClicked:
            {
                if(isNewProject)
                    project.newProject()

                project.currentProjectName = projectNameField.text

                if(choosenAudioFile !== "")
                {
                    mainScreen.playerWidget.waitingText.text = qsTr("Downloading...")
                    project.setAudioTrack(choosenAudioFile)
                }

                project.setProperty("sceneFrameWidth", Number(widthField.text))
                project.setProperty("sceneFrameHeight", Number(heightField.text))

                if(projectSettingsWidget.choosenImageFile !== "")
                    project.setBackgroundImage(projectSettingsWidget.choosenImageFile)
                else
                    project.setBackgroundImage("default.svg")

                sceneWidget.centerBackgroundImage()

                applicationWindow.isPatchEditorOpened = false
                projectSettingsWidget.visible = false

                if(isNewProject)
                {
                    project.setProperty("sceneImageWidth", project.property("sceneFrameWidth") * 20 / sceneWidget.backgroundImage.width)

                    // Центруем рамку по фоновой картинке
                    let xPos = ((sceneWidget.backgroundImage.width - project.property("sceneImageWidth") * sceneWidget.backgroundImage.width) / 2) / sceneWidget.backgroundImage.width

                    project.setProperty("sceneFrameX", xPos)
                    project.setProperty("sceneFrameY", 0.3)

                    sceneWidget.sceneFrameItem.visible = true

                    applicationWindow.showPatchScreen()

                    patchScreen.deviceLibWidget.setActive(false)
                    patchScreen.deviceListWidget.setActive(false)
                    patchScreen.groupListWidget.setActive(false)
                }
            }
        }
    }

    onVisibleChanged:
    {
        if(visible)
        {
            if(isNewProject)
            {
                choosenAudioFile = ""
                choosenImageFile = ""
                widthField.text = ""
                heightField.text = ""
                projectNameField.text = ""
            }
            else
            {
                choosenAudioFile = project.workDirStr() + "/" + project.property("audioTrackFile")
                choosenImageFile = project.workDirStr() + "/" + project.property("backgroundImageFile")
                widthField.text = project.property("sceneFrameWidth")
                heightField.text = project.property("sceneFrameHeight")
                projectNameField.text = project.currentProjectName
            }
        }
    }
}

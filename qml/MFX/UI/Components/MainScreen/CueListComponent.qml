import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI.Components.Basic 1.0
import MFX.UI.Styles 1.0

Component
{
    Rectangle
    {
        id: cueListWidget

        objectName: "cue_list"

        color: "#444444"
        radius: 2

        MouseArea
        {
            anchors.fill: parent

            propagateComposedEvents: false
            preventStealing: true

            onWheel: (wheel) => {
                            wheel.accepted = true
                        }
        }

        Rectangle
        {
            anchors.fill: parent
            anchors.topMargin: 32
            anchors.bottomMargin: 2
            anchors.leftMargin: 2
            anchors.rightMargin: 2

            radius: 2

            color: "#222222"
        }

        //TODO должно поставляться из логики бекенда - перенести в c++ часть
        enum CueListViewItemTypes
        {
            GlobalOffset, //Эта роль подразумевает элемент GlobalOffset - он не редактируется
            Normal // Обычный элемент CUE
        }

        ListView
        {
            id: cueListView

            anchors.fill: parent

            anchors.leftMargin: 2
            anchors.rightMargin: 2
            anchors.bottomMargin: 2

            property int columnsCount: 4
            property var columnProportions: [1, 3, 2, 2]
            property var columnWidths: [0, 0, 0, 0]

            function calculateColumnWidths(width) {
                return columnProportions.map(function(columnProportion) {
                    return (width - (columnsCount - 1)) * (columnProportion / cueListView.columnProportions.reduce((a, b) => a + b, 0))
                });
            }

            Component.onCompleted: {
                cueListView.columnWidths = cueListView.calculateColumnWidths(cueListView.width)
            }

            onWidthChanged: {
                cueListView.columnWidths = cueListView.calculateColumnWidths(cueListView.width)
            }

            clip: true

            headerPositioning: ListView.OverlayHeader

            header: Item {
                anchors.left: parent.left
                anchors.right: parent.right
                height: 30

                z: 2

                Rectangle {
                    anchors.fill: parent
                    anchors.bottomMargin: -2
                    radius: 2

                    color: "#444444"
                }


                RowLayout {
                    anchors.fill: parent

                    spacing: 0

                    Text {

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueListView.columnWidths[0]
                        Layout.maximumWidth: cueListView.columnWidths[0]
                        Layout.minimumWidth: cueListView.columnWidths[0]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.family: Fonts.robotoRegular.name
                        font.pixelSize: 10

                        color: "#FFFFFF"

                        text: translationsManager.translationTrigger + qsTr("№")
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 4

                        color: "#1FFFFFFF"
                    }

                    Text {

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueListView.columnWidths[1]
                        Layout.maximumWidth: cueListView.columnWidths[1]
                        Layout.minimumWidth: cueListView.columnWidths[1]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.family: Fonts.robotoRegular.name
                        font.pixelSize: 10

                        color: "#FFFFFF"

                        text: translationsManager.translationTrigger + qsTr("Cue")
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 4

                        color: "#1FFFFFFF"
                    }

                    Text {

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueListView.columnWidths[2]
                        Layout.maximumWidth: cueListView.columnWidths[2]
                        Layout.minimumWidth: cueListView.columnWidths[2]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.family: Fonts.robotoRegular.name
                        font.pixelSize: 10

                        color: "#FFFFFF"

                        text: translationsManager.translationTrigger + qsTr("Start time")
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 4

                        color: "#1FFFFFFF"
                    }

                    Text {

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueListView.columnWidths[3]
                        Layout.maximumWidth: cueListView.columnWidths[3]
                        Layout.minimumWidth: cueListView.columnWidths[3]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.family: Fonts.robotoRegular.name
                        font.pixelSize: 10

                        color: "#FFFFFF"

                        text: translationsManager.translationTrigger + qsTr("Total time")
                    }
                }

            }

            model: cueManager.cuesSorted

            delegate: FocusScope {
                id: cueListViewDelegate

                property bool active: model.active
                property bool selected: model.selected
                onSelectedChanged: cueName = name
                property var id: model.uuid
                property int rowIndex: model.index
                property string name: model.name
                property string startTime: model.startTimeDecorator
                property string totalTime: model.durationTimeDecorator

                property color activeTextColor: "#F2C94C"
                property color activeBackgroundColor: "#1AFFFAFA"

                property color selectedTextColor: "#80FFFFFF"
                property color selectedBackgroundColor: "#80000000"

                property color textColor: "#FFFFFF"
                property color backgroundColor: "transparent"

                QtObject {
                    id: cueListViewDelegatePrivateProperties

                    property color calculatedBackgroundColor: cueListViewDelegate.active ? cueListViewDelegate.activeBackgroundColor
                                                                                            : cueListViewDelegate.selected ? cueListViewDelegate.selectedBackgroundColor
                                                                                                                        : cueListViewDelegate.backgroundColor

                    property color calculatedTextColor: cueListViewDelegate.active ? cueListViewDelegate.activeTextColor
                                                                                    : cueListViewDelegate.selected ? cueListViewDelegate.selectedTextColor
                                                                                                                    : cueListViewDelegate.textColor
                }

                anchors.left: cueListView.contentItem.left
                anchors.right: cueListView.contentItem.right

                height: 30

                Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: 6
                    anchors.rightMargin: 6

                    color: cueListViewDelegatePrivateProperties.calculatedBackgroundColor

                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        id: cueListViewDelegateSelectionMouseArea

                        anchors.fill: parent

                        onClicked: {
                            if(cueListViewDelegate.selected) {
                                cueManager.cueDeselectedOnCueListRequest(cueListViewDelegate.name)
                            } else {
                                cueManager.cueSelectedOnCueListRequest(cueListViewDelegate.name)
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 6
                    anchors.rightMargin: 6

                    height: 1

                    color: "#80000000"
                }

                RowLayout {
                    anchors.fill: parent

                    spacing: 0

                    Text {

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueListView.columnWidths[0]
                        Layout.maximumWidth: cueListView.columnWidths[0]
                        Layout.minimumWidth: cueListView.columnWidths[0]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.family: Fonts.robotoRegular.name
                        font.pixelSize: 10

                        color: cueListViewDelegatePrivateProperties.calculatedTextColor

                        text: cueListViewDelegate.rowIndex
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 4

                        color: "#1FFFFFFF"
                    }

                    TransparentTextField
                    {
                        id: cueListViewDelegateNameTextField

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueListView.columnWidths[1]
                        Layout.maximumWidth: cueListView.columnWidths[1]
                        Layout.minimumWidth: cueListView.columnWidths[1]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        textSize: 10

                        textColor: cueListViewDelegatePrivateProperties.calculatedTextColor

                        text: cueListViewDelegate.name

                        onTextEdited: {
                            if(text.length > 0) {
                                cueManager.cueNameChangeRequest(cueListViewDelegate.id, text)
                            }
                        }

                        Keys.priority: Keys.BeforeItem
                        Keys.onPressed: (keyEvent) => {
                                            if((keyEvent === Qt.Key_Escape) || (keyEvent === Qt.Key_Enter)) {
                                                cueListViewDelegateNameTextField.focus = false;
                                                cueListViewDelegateNameTextField._textItem.focus = false;
                                                keyEvent.accepted = true;
                                                return;
                                            }
                                            keyEvent.accepted = false;
                                        }

                        MouseArea {
                            id: cueListViewDelegateNameTextFieldMouseArea

                            anchors.fill: parent

                            property bool waitingForASecondClick: false
                            property int doubleClickDuration: 300

                            Timer {
                                id: doubleClickTimer

                                interval: cueListViewDelegateNameTextFieldMouseArea.doubleClickDuration
                                running: false
                                repeat: false

                                onTriggered: {
                                    if(cueListViewDelegateNameTextFieldMouseArea.waitingForASecondClick) {
                                        cueListViewDelegateNameTextFieldMouseArea.waitingForASecondClick = false;
                                        cueListViewDelegateSelectionMouseArea.clicked(null)
                                    }
                                }
                            }

                            propagateComposedEvents: false
                            preventStealing: true

                            onClicked: {
                                if(waitingForASecondClick) {
                                    if(doubleClickTimer.running) {
                                        doubleClickTimer.stop()
                                        cueListViewDelegateNameTextField.forceFocus()
                                    }
                                    waitingForASecondClick = false
                                } else {
                                    doubleClickTimer.start()
                                    waitingForASecondClick = true;
                                }
                                mouse.accepted = true
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 4

                        color: "#1FFFFFFF"
                    }

                    Text {

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueListView.columnWidths[2]
                        Layout.maximumWidth: cueListView.columnWidths[2]
                        Layout.minimumWidth: cueListView.columnWidths[2]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.family: Fonts.robotoRegular.name
                        font.pixelSize: 10

                        color: cueListViewDelegatePrivateProperties.calculatedTextColor

                        text: cueListViewDelegate.startTime
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        Layout.maximumWidth: 1
                        Layout.minimumWidth: 1
                        Layout.topMargin: 4
                        Layout.bottomMargin: 4

                        color: "#1FFFFFFF"
                    }

                    Text {

                        Layout.fillHeight: true
                        Layout.preferredWidth: cueListView.columnWidths[3]
                        Layout.maximumWidth: cueListView.columnWidths[3]
                        Layout.minimumWidth: cueListView.columnWidths[3]

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        font.family: Fonts.robotoRegular.name
                        font.pixelSize: 10

                        color: cueListViewDelegatePrivateProperties.calculatedTextColor

                        text: cueListViewDelegate.totalTime
                    }
                }
            }
        }
    }
}
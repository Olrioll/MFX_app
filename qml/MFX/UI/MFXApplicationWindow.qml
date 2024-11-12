import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MFX.UI 1.0 as MFXUI
import MFX.UI.Components.Basic 1.0 as MFXUICB
import MFX.UI.Pages 1.0 as MFXUIP
import MFX.UI.Styles 1.0 as MFXUIS

MFXUICB.FramelessApplicationWindow
{
    id: _applicationWindow

    content: ColumnLayout
    {
        id: _applicationWindowLayout

        anchors.fill: parent

        spacing: 0

        Item
        {
            id: _menuItem

            Layout.fillWidth: true
            Layout.preferredHeight: 28
            Layout.maximumHeight: 28
            Layout.minimumHeight: 28

            MFXUI.MFXApplicationWindowMenuBar
            {
                id: _menuBar

                anchors.fill: parent

                borderRadius: _applicationWindow.borderRadius

                onMinimizeClicked: {}
                onMaximizeClicked: {}
                onCloseClicked: {}
            }
        }

        Item
        {
            id: _contentItem

            Layout.fillWidth: true
            Layout.fillHeight: true

            StackView
            {
                id: _contentStackView

                anchors.fill: parent
                anchors.margins: 2

                initialItem: _startScreenComponent

                Component
                {
                    id: _startScreenComponent

                    MFXUIP.StartScreen
                    {
                        id: _startScreenComponentItem
                    }
                }
            }
        }
    }
}

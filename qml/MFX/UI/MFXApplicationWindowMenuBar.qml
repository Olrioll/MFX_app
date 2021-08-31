import QtQuick 2.15
import QtQuick.Controls 2.15

import MFX.UI.Components.Templates 1.0 as MFXUICT
import MFX.UI.Styles 1.0 as MFXUIS

Control {
    id: _menuBar

    property int borderRadius: 0
    property color backgroundColor: MFXUIS.Theme.applicationWindowMenuBarBackgroundColor

    signal minimizeClicked()
    signal maximizeClicked()
    signal closeClicked()

    background: MFXUICT.RoundedRectangleShape {
        topLeftRadius: _menuBar.borderRadius
        topRightRadius: _menuBar.borderRadius
        fillColor: _menuBar.backgroundColor
    }
}

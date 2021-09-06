pragma Singleton

import QtQuick 2.15

import MFX.UI.Styles 1.0 as MFXUIS

QtObject {
	id: _theme

    //ApplicationWindow
    readonly property color applicationWindowBackgroundColor: "#222222"
    readonly property color applicationWindowMenuBarBackgroundColor: "#111111"

    //StartScreen
    readonly property color startScreenContentBackgroundColor: "#000000"

}

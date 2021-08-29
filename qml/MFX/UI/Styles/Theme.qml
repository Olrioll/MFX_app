pragma Singleton

import QtQuick 2.15

import MFX.UI.Styles 1.0 as MFXUIS

QtObject {
	id: _theme

    property font regularFont
    regularFont.family: MFXUIS.Fonts.robotoRegular

    property font mediumFont
    mediumFont.family: MFXUIS.Fonts.robotoMedium

    property font boldFont
    boldFont.family: MFXUIS.Fonts.robotoBold
}

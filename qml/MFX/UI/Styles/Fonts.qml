pragma Singleton

import QtQuick 2.15

QtObject {
	id: _fonts

    readonly property QtObject robotoRegular: FontLoader {
        source: "qrc:/fonts/Roboto/Roboto-Regular.ttf"
    }

    readonly property QtObject robotoMedium: FontLoader {
        source: "qrc:/fonts/Roboto/Roboto-Medium.ttf"
    }

    readonly property QtObject robotoBold: FontLoader {
        source: "qrc:/fonts/Roboto/Roboto-Bold.ttf"
    }
}

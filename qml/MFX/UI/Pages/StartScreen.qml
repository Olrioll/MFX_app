import QtQuick 2.15
import QtQuick.Controls 2.15

import MFX.UI.Styles 1.0 as MFXUIS

Page {
    id: _page

    background: Item {}

    header: Item {}
    footer: Item {}

    contentItem: Item {
        id: _contentItem

        Rectangle {
            id: _contentBackground

            anchors.fill: parent

            radius: 2
            color: MFXUIS.Theme.startScreenContentBackgroundColor
        }
    }
}

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

Button {
    id: _coloredIcon

    property string source: ""
    property color color: "transparent"

    implicitWidth: _icon.width
    implicitHeight: _icon.width

    QtObject {
        id: _privateProperies

        function isTransparentColor(color) {
            return 0.0 === color.a;
        }
    }

    background: Item {
        anchors.fill: parent

        Image {
            id: _icon

            anchors.centerIn: parent

            cache: false
            asynchronous: true
            fillMode: Image.PreserveAspectFit
            mipmap: true

            visible: _privateProperies.isTransparentColor(_colorOverlay.color)

            source: _coloredIcon.source

            sourceSize: Qt.size(_coloredIcon.width, _coloredIcon.height)
        }

        ColorOverlay {
            id: _colorOverlay

            anchors.fill: _icon

            enabled: !_privateProperies.isTransparentColor(_coloredIcon.color)

            visible: enabled

            source: _icon
            cached: true
            color: enabled ? _coloredIcon.color : "transparent"
            opacity: color.a
        }
    }

    contentItem: Item { }
}

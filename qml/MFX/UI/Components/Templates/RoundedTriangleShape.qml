import QtQuick 2.15
import QtQuick.Shapes 1.15

Shape {
    id: _component

    property int orientation: Qt.RightToLeft
    property color fillColor: _privateProperties.defaultFillColor

    QtObject {
        id: _privateProperties

        readonly property color defaultFillColor: "#000000"
    }

    ShapePath {
        fillColor: _component.fillColor

        strokeWidth: 2
        strokeStyle: ShapePath.SolidLine
        strokeColor: _component.fillColor
        joinStyle: ShapePath.RoundJoin
        capStyle: ShapePath.RoundCap

        startX: 0
        startY: orientation === Qt.LeftToRight ? 0 : _component.height / 2

        PathLine { x: width; y: orientation === Qt.LeftToRight ? _component.height / 2 : 0 }
        PathLine { x: width; y: orientation === Qt.LeftToRight ? _component.height / 2 : height }
        PathLine { x: 0; y: orientation === Qt.LeftToRight ? height : _component.height / 2 }
        PathLine { x: 0; y: orientation === Qt.LeftToRight ? 0 : _component.height / 2 }
    }
}

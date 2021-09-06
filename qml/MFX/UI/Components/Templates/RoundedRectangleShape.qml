import QtQuick 2.15
import QtQuick.Shapes 1.15

Shape {
    id: _component

    property int topLeftRadius: 0
    property int topRightRadius: 0
    property int bottomLeftRadius: 0
    property int bottomRightRadius: 0
    property int borderWidth: 0
    property color fillColor: _privateProperties.defaultFillColor
    property color borderColor: _privateProperties.defaultBorderColor

    QtObject {
        id: _privateProperties

        readonly property color defaultFillColor: "#000000"
        readonly property color defaultBorderColor: "#000000"
    }

    ShapePath {
        fillColor: _component.fillColor

        strokeWidth: _component.borderWidth
        strokeStyle: ShapePath.SolidLine
        strokeColor: _component.borderColor
        joinStyle: ShapePath.RoundJoin
        capStyle: ShapePath.RoundCap

        startX: _component.topLeftRadius
        startY: 0

        PathLine { x: width - topRightRadius; y: 0 }
        PathArc { x: width; y: topRightRadius; radiusX: topRightRadius; radiusY: topRightRadius; useLargeArc: false }
        PathLine { x: width; y: height - bottomRightRadius }
        PathArc { x: width - bottomRightRadius; y: height; radiusX: bottomRightRadius; radiusY: bottomRightRadius; useLargeArc: false }
        PathLine { x: bottomLeftRadius; y: height }
        PathArc { x: 0; y: height - bottomLeftRadius; radiusX: bottomLeftRadius; radiusY: bottomLeftRadius; useLargeArc: false }
        PathLine { x: 0; y: topLeftRadius }
        PathArc { x: topLeftRadius; y: 0; radiusX: topLeftRadius; radiusY: topLeftRadius; useLargeArc: false }
    }
}

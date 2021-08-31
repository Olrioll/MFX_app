import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Controls.Material 2.15
// На длительной дистанции может не работать, так как не является частью API Qt
// Заменить на реализацию собственного шейдера тени ElevationEffect
import QtQuick.Controls.Material.impl 2.15

Window {
    id: _component

    property int elevationLevel: _privateProperties.defaultWindowElevationLevel
    property color backgroundColor: _privateProperties.defaultBackgroundColor
    property int borderRadius: _privateProperties.defaultWindowBorderRadius
    property int shadowVisible: (_component.visibility !== Window.Maximized) || (elevationLevel !== 0)
    property int shadowLayerSize: _privateProperties.defaultShadowLayerSize
    property alias content: _windowContent.data

    QtObject {
        id: _privateProperties

        readonly property int defaultWindowElevationLevel: 5
        readonly property int defaultShadowLayerSize: 10
        readonly property int defaultWindowBorderRadius: 4
        readonly property color defaultBackgroundColor: "#222222"
    }

    width: 1280 + 2 * _component.shadowLayerSize
    height: 1024 + 2 * _component.shadowLayerSize

    flags: Qt.Window | Qt.FramelessWindowHint
    color: "transparent"

    visible: true

    MouseArea {
        id: _resizeMouseArea

        property point startPosition: Qt.point(0,0)

        anchors.fill: parent


        hoverEnabled: true

        // TODO Перевести в enum
        state: "NULL"

        states: [
            State {
                name: "HORIZONTAL"
                PropertyChanges {
                    target: _resizeMouseArea
                    cursorShape: Qt.SizeHorCursor
                }
            },
            State {
                name: "VERTICAL"
                PropertyChanges {
                    target: _resizeMouseArea
                    cursorShape: Qt.SizeVerCursor
                }
            },
            State {
                name: "TOPBOTTOMDIAGONAL"
                PropertyChanges {
                    target: _resizeMouseArea
                    cursorShape: Qt.SizeFDiagCursor
                }
            },
            State {
                name: "BOTTOMTOPDIAGONAL"
                PropertyChanges {
                    target: _resizeMouseArea
                    cursorShape: Qt.SizeBDiagCursor
                }
            },
            // Нельзя менять порядок состояний - важен приоритет диагональных состояний над горизонтальным и вертикальным
            State {
                name: "TOPLEFT"
                when: (_resizeMouseArea.mouseX < (_resizeMouseArea.pressed ? 75 : _component.shadowLayerSize)) &&
                      (_resizeMouseArea.mouseY < (_resizeMouseArea.pressed ? 75 : _component.shadowLayerSize))
                extend: "TOPBOTTOMDIAGONAL"
            },
            State {
                name: "BOTTOMRIGHT"
                when: (_resizeMouseArea.mouseX > _background.width - (_resizeMouseArea.pressed ? 75 : 0)) &&
                      (_resizeMouseArea.mouseY > _background.height - (_resizeMouseArea.pressed ? 75 : 0))
                extend: "TOPBOTTOMDIAGONAL"
            },
            State {
                name: "BOTTOMLEFT"
                when: (_resizeMouseArea.mouseX < (_resizeMouseArea.pressed ? 75 : _component.shadowLayerSize)) &&
                      (_resizeMouseArea.mouseY > _background.height - (_resizeMouseArea.pressed ? 75 : _component.shadowLayerSize))
                extend: "BOTTOMTOPDIAGONAL"
            },
            State {
                name: "TOPRIGHT"
                when: (_resizeMouseArea.mouseX > _background.width - (_resizeMouseArea.pressed ? 75 : 0)) &&
                      (_resizeMouseArea.mouseY < (_resizeMouseArea.pressed ? 75 : _component.shadowLayerSize))
                extend: "BOTTOMTOPDIAGONAL"
            },
            State {
                name: "LEFT"
                when: (_resizeMouseArea.mouseX < _component.shadowLayerSize + (_resizeMouseArea.pressed ? Math.min(100, _background.width) : 0)) &&
                      (_resizeMouseArea.mouseY > _component.shadowLayerSize) &&
                      (_resizeMouseArea.mouseY < _background.width + _component.shadowLayerSize)
                extend: "HORIZONTAL"
            },
            State {
                name: "RIGHT"
                when: (_resizeMouseArea.mouseX > _background.width - (_resizeMouseArea.pressed ? Math.min(100, _background.width) : 0)) &&
                      (_resizeMouseArea.mouseY > _component.shadowLayerSize) &&
                      (_resizeMouseArea.mouseY < _background.width + _component.shadowLayerSize)
                extend: "HORIZONTAL"
            },
            State {
                name: "TOP"
                when: (_resizeMouseArea.mouseY < _component.shadowLayerSize + (_resizeMouseArea.pressed ? Math.min(100, _background.height) : 0))  &&
                      (_resizeMouseArea.mouseX > _component.shadowLayerSize) &&
                      (_resizeMouseArea.mouseX < _background.width + _component.shadowLayerSize)
                extend: "VERTICAL"
            },
            State {
                name: "BOTTOM"
                when: (_resizeMouseArea.mouseY > _background.height - (_resizeMouseArea.pressed ? Math.min(100, _background.width) : 0))  &&
                      (_resizeMouseArea.mouseX > _component.shadowLayerSize) &&
                      (_resizeMouseArea.mouseX < _background.width + _component.shadowLayerSize)
                extend: "VERTICAL"
            },
            State {
                name: "NULL"
            }
        ]

        onPressed: {
            startPosition = Qt.point(mouse.x,mouse.y)
            _component.elevationLevel = 2
        }

        onReleased: {
            _component.elevationLevel = 5
        }

        onPositionChanged: {
            if(_resizeMouseArea.pressed) {
                var deltaPosition = Qt.point(mouseX - startPosition.x,
                                             mouseY - startPosition.y)
                switch(state) {
                case "LEFT" : {
                    _component.x = _component.x + deltaPosition.x
                    _component.width = _component.width - deltaPosition.x
                } break;
                case "RIGHT" : {
                    _component.width = _component.width + deltaPosition.x
                    startPosition = Qt.point(mouseX, mouseY)
                } break;
                case "TOP" : {
                    _component.y = _component.y + deltaPosition.y
                    _component.height = _component.height - deltaPosition.y
                } break;
                case "BOTTOM" : {
                    _component.height = _component.height + deltaPosition.y
                    startPosition = Qt.point(mouseX, mouseY)
                } break;
                case "TOPLEFT" : {
                    _component.x = _component.x + deltaPosition.x
                    _component.width = _component.width - deltaPosition.x
                    _component.y = _component.y + deltaPosition.y
                    _component.height = _component.height - deltaPosition.y
                } break;
                case "BOTTOMRIGHT" : {
                    _component.width = _component.width + deltaPosition.x
                    _component.height = _component.height + deltaPosition.y
                    startPosition = Qt.point(mouseX, mouseY)
                } break;
                case "BOTTOMLEFT" : {
                    _component.x = _component.x + deltaPosition.x
                    _component.width = _component.width - deltaPosition.x
                    _component.height = _component.height + deltaPosition.y
                    startPosition = Qt.point(0, mouseY)
                } break;
                case "TOPRIGHT" : {
                    _component.y = _component.y + deltaPosition.y
                    _component.height = _component.height - deltaPosition.y
                    _component.width = _component.width + deltaPosition.x
                    startPosition = Qt.point(mouseX, 0)
                } break;
                default:
                    state = "NULL"
                }
            }
        }

        onClicked: {
            mouse.accepted = false
        }
    }

    MouseArea {
        anchors.fill: parent
        anchors.margins: _component.shadowLayerSize

        propagateComposedEvents: false
        preventStealing: true

        onClicked: {
            mouse.accepted = true
        }

        onPressed: {
            mouse.accepted = true
        }
    }

    Rectangle {
        id: _background

        anchors.fill: parent
        anchors.margins: _component.shadowLayerSize

        radius: _component.borderRadius

        color: _component.backgroundColor

        layer.enabled: _component.shadowVisible
        layer.effect: ElevationEffect {
            id: _windowShadow

            elevation: _component.elevationLevel
        }

        Item {
            id: _windowContent

            anchors.fill: parent
        }
    }
}

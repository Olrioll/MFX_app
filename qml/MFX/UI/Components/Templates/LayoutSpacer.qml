import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: _component

    property var fixedWidth: undefined
    property var fixedHeight: undefined

    Layout.fillHeight: _component.fixedHeight === undefined
    Layout.fillWidth: _component.fixedWidth === undefined

    Layout.preferredHeight: _component.fixedHeight
    Layout.maximumHeight: _component.fixedHeight
    Layout.minimumHeight: _component.fixedHeight
    Layout.preferredWidth: _component.fixedWidth
    Layout.maximumWidth: _component.fixedWidth
    Layout.minimumWidth: _component.fixedWidth
}

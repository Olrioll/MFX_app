import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "qrc:/"

Item
{
    id: table

    property var columns: []
    property var currentColumnsRoles: []


    function addColumns(columnObject)
    {
        columns.push(columnObject)
    }

    function addColumns(columnList)
    {
        columns.concat(columnList)
    }

    Rectangle
    {
        id: mainBackground
        anchors.fill: parent
        color: "#444444"
        radius: 2
    }

    Rectangle
    {
        id: rowsArea
        anchors.topMargin: 30
        anchors.leftMargin: 2
        anchors.rightMargin: 2
        anchors.bottomMargin: 2
        anchors.fill: parent
        color: "#222222"
        radius: 2
    }

    ListView
    {
        id: header
        height: 30
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    ListView
    {
        id: rows
        anchors.fill: rowsArea

        model: ListModel
        {
            id: rowsModel
        }

        delegate: Item
        {
            id: row

        }
    }
}

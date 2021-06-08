import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

Item
{
    height: collapsedHeight

    property int collapsedHeight: 10
    property int expandedHeight: 36
    property int position // в мсек
    property int duration  // в мсек

    Rectangle
    {
        id: frame
        anchors.fill: parent

        radius: 4
        color: "#7F27AE60"
        border.width: 2
        border.color: "#27AE60"

    }
}

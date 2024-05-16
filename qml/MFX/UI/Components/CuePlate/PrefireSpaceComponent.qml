import QtQuick 2.15

Component
{
    Item
    {
        height: cuePlate.height
        width: msecToPixels( prefire )
        visible: !cuePlate.isExpanded
        x: calcX()
        y: 0

        property double position: 0 // в мсек
        property double prefire: 0 // в мсек

        function calcX()
        {
            let x = msecToPixels( position - prefire - cuePlate.position )
            if( x < frameBorderWidth )
                x = frameBorderWidth

            return x
        }

        Rectangle
        {
            color: "red"
            anchors.fill: parent
            anchors.topMargin: frameBorderWidth
            anchors.bottomMargin: frameBorderWidth
        }
    }
}
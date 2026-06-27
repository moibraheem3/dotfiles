import QtQuick
import QtQuick.Layouts

// Reusable pill-shaped widget for bar right section: icon + optional label.
Rectangle {
    id: root

    property string icon: ""
    property string label: ""
    property color  iconColor: Theme.text
    property bool   hoverable: false

    signal clicked(var mouse)
    signal scrolled(int delta)   // +1 = up, -1 = down

    implicitWidth:  row.implicitWidth + 14
    implicitHeight: 24
    radius: 6
    color: (hoverable && hov.containsMouse) ? Theme.surface1 : Theme.surface0
    Behavior on color { ColorAnimation { duration: 120 } }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 5

        Text {
            text: root.icon
            font.pixelSize: 13
            color: root.iconColor
            visible: root.icon !== ""
        }

        Text {
            text: root.label
            font.pixelSize: 11
            color: Theme.text
            visible: root.label !== ""
        }
    }

    MouseArea {
        id: hov
        anchors.fill: parent
        hoverEnabled: root.hoverable
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: root.hoverable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: mouse => root.clicked(mouse)
        onWheel:   wheel => root.scrolled(wheel.angleDelta.y > 0 ? 1 : -1)
    }
}

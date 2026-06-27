import QtQuick

Rectangle {
    id: root

    property string label: ""

    signal triggered()

    width: 28; height: 28; radius: 14
    color: hov.containsMouse ? Theme.surface1 : "transparent"
    opacity: root.enabled ? 1.0 : 0.35
    Behavior on color { ColorAnimation { duration: 120 } }

    Text {
        anchors.centerIn: parent
        text: root.label
        font.pixelSize: 13
        color: Theme.text
    }

    MouseArea {
        id: hov
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
        onClicked: root.triggered()
    }
}

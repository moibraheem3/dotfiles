import QtQuick

Rectangle {
    id: root

    property string label: "›"
    signal triggered()

    width: 28; height: 28; radius: 14
    color: hov.containsMouse ? Theme.surface1 : "transparent"
    Behavior on color { ColorAnimation { duration: 120 } }

    Text {
        anchors.centerIn: parent
        text: root.label
        font.pixelSize: 18
        color: Theme.subtext
    }

    MouseArea {
        id: hov
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.triggered()
    }
}

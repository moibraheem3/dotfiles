import QtQuick

Rectangle {
    id: root

    property string label: ""
    property bool   active: false
    property color activeColor: Theme.accent
    property color inactiveColor: Theme.surface1

    signal triggered()

    width: 34
    height: 34
    radius: 8
    color: active ? activeColor : (hov.containsMouse ? Qt.lighter(inactiveColor, 1.2) : inactiveColor)

    Behavior on color { ColorAnimation { duration: 150 } }

    Text {
        anchors.centerIn: parent
        text: root.label
        font.pixelSize: 15
        color: root.active ? Theme.bg : Theme.text
    }

    MouseArea {
        id: hov
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.triggered()
    }
}

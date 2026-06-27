import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import Quickshell.Widgets

Rectangle {
    id: root

    required property var notification

    signal dismissRequested()

    implicitHeight: inner.implicitHeight + 20
    radius: 10
    color: Theme.surface0
    clip: true

    // Left urgency stripe
    property color urgencyColor: {
        switch (notification.urgency) {
            case NotificationUrgency.Critical: return Theme.red
            case NotificationUrgency.Low:      return Theme.subtext
            default:                           return Theme.blue
        }
    }

    Rectangle {
        x: 0; y: 8
        width: 3
        height: parent.height - 16
        radius: 2
        color: root.urgencyColor
    }

    // Slide in from the configured side (right by default, left if toast is on the left)
    property real slideX: Config.toastOnLeft ? -(width + 20) : (width + 20)
    transform: Translate { x: root.slideX }

    NumberAnimation {
        id: entryAnim
        target: root
        property: "slideX"
        to: 0
        duration: 260
        easing.type: Easing.OutCubic
    }

    Component.onCompleted: entryAnim.start()

    // Content
    ColumnLayout {
        id: inner
        anchors { left: parent.left; leftMargin: 14; right: parent.right; rightMargin: 10; top: parent.top; topMargin: 10 }
        spacing: 5

        // App row + close
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Loader {
                active: notification.appIcon !== ""
                sourceComponent: IconImage {
                    width: 16; height: 16
                    source: notification.appIcon
                    smooth: true
                }
            }

            Text {
                text: notification.appName || "Notification"
                font.pixelSize: 11
                font.bold: true
                color: Theme.subtext
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            MouseArea {
                width: 18; height: 18
                cursorShape: Qt.PointingHandCursor
                onClicked: root.dismissRequested()

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    font.pixelSize: 10
                    color: Theme.subtext
                }
            }
        }

        // Summary
        Text {
            text: notification.summary || ""
            font.pixelSize: 13
            font.bold: true
            color: Theme.text
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            visible: text !== ""
        }

        // Body (max 3 lines)
        Text {
            text: notification.body || ""
            font.pixelSize: 12
            color: Theme.subtext
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            textFormat: Text.StyledText
            visible: text !== ""
            maximumLineCount: 3
            elide: Text.ElideRight
        }

        Item { Layout.fillWidth: true; height: 2 }
    }
}

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import Quickshell.Widgets

Item {
    id: root

    required property var notification

    implicitHeight: card.implicitHeight + 10

    property color urgencyColor: {
        switch (notification.urgency) {
            case NotificationUrgency.Critical: return Theme.red
            case NotificationUrgency.Low:      return Theme.subtext
            default:                           return Theme.blue
        }
    }

    property real revealX: width
    transform: Translate { x: root.revealX }

    NumberAnimation {
        id: entryAnim
        target: root
        property: "revealX"
        from: width; to: 0
        duration: 220
        easing.type: Easing.OutCubic
    }

    Component.onCompleted: entryAnim.start()

    // Card background
    Rectangle {
        id: card
        anchors {
            left:   parent.left;  leftMargin:  10
            right:  parent.right; rightMargin: 10
            top:    parent.top;   topMargin:   5
        }
        implicitHeight: cardLayout.implicitHeight + 16
        radius: 8
        color: Theme.surface0

        // Left urgency stripe
        Rectangle {
            x: 0; y: 8
            width: 3
            height: parent.height - 16
            radius: 2
            color: root.urgencyColor
        }

        ColumnLayout {
            id: cardLayout
            anchors { left: parent.left; leftMargin: 14; right: parent.right; rightMargin: 10; top: parent.top; topMargin: 8 }
            spacing: 6

            // App row: icon + name + dismiss
            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                // App icon
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

                // Dismiss
                Rectangle {
                    width: 20; height: 20; radius: 10
                    color: dismissHov.containsMouse ? Theme.surface1 : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: ""
                        font.pixelSize: 10
                        color: Theme.subtext
                    }

                    MouseArea {
                        id: dismissHov
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: notification.dismiss()
                    }
                }
            }

            // Notification image
            Loader {
                active: notification.image !== ""
                Layout.fillWidth: true
                sourceComponent: Image {
                    fillMode: Image.PreserveAspectFit
                    source: {
                        const img = notification.image
                        if (!img) return ""
                        if (img.startsWith("/")) return "file://" + img
                        return img
                    }
                    height: 80
                    width: parent ? parent.width : 0
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

            // Body
            Text {
                text: notification.body || ""
                font.pixelSize: 12
                color: Theme.subtext
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                textFormat: Text.StyledText
                visible: text !== ""
                maximumLineCount: 4
                elide: Text.ElideRight
            }

            // Action buttons
            Flow {
                Layout.fillWidth: true
                spacing: 6
                visible: notification.actions && notification.actions.length > 0

                Repeater {
                    model: notification.actions
                    delegate: Rectangle {
                        required property var modelData
                        height: 26
                        width: Math.max(60, actionLabel.implicitWidth + 20)
                        radius: 6
                        color: actionHov.containsMouse ? Theme.surface1 : Theme.bg

                        Text {
                            id: actionLabel
                            anchors.centerIn: parent
                            text: modelData.text || modelData.identifier
                            font.pixelSize: 11
                            color: Theme.blue
                        }

                        MouseArea {
                            id: actionHov
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modelData.invoke()
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true; height: 2 }
        }
    }
}

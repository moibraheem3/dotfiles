import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris

PanelWindow {
    id: root

    required property bool isOpen
    required property bool doNotDisturb
    required property var notifServer

    signal closeRequested()
    signal doNotDisturbToggled()
    signal clearAllRequested()

    // Full-screen overlay so we can show backdrop and capture outside clicks
    anchors.left: true
    anchors.right: true
    anchors.top: true
    anchors.bottom: true
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-notif-center"
    WlrLayershell.keyboardFocus: root._panelOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // Animation state
    property bool _panelOpen: false
    property bool _panelVisible: false

    visible: _panelVisible

    onIsOpenChanged: {
        if (isOpen) {
            hideTimer.stop()
            _panelVisible = true
            _panelOpen = true
        } else {
            _panelOpen = false
            hideTimer.restart()
        }
    }

    Timer {
        id: hideTimer
        interval: 350
        onTriggered: root._panelVisible = false
    }

    // ── transparent backdrop ──────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        opacity: root._panelOpen ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }

        MouseArea {
            anchors.fill: parent
            onClicked: root.closeRequested()
        }
    }

    // ── Sliding panel ──────────────────────────────────────────────────────
    Rectangle {
        id: panel
        width: Config.centerWidth
        anchors.top:          parent.top
        anchors.topMargin:    Config.centerPaddingTop
        anchors.bottom:       parent.bottom
        anchors.bottomMargin: Config.centerPaddingBottom
        anchors.right:        Config.centerOnRight ? parent.right : undefined
        anchors.rightMargin:  Config.centerOnRight ? Config.centerPaddingSide : 0
        anchors.left:         Config.centerOnLeft  ? parent.left  : undefined
        anchors.leftMargin:   Config.centerOnLeft  ? Config.centerPaddingSide : 0
        color: Theme.bg
        focus: true
        Keys.onEscapePressed: root.closeRequested()

        // Slide direction: right side slides from +width, left side from -width
        // Include side padding so the panel fully exits the screen when closed
        property real _closedX: Config.centerOnLeft
            ? -(Config.centerWidth + Config.centerPaddingSide)
            :  (Config.centerWidth + Config.centerPaddingSide)
        property real slideX: root._panelOpen ? 0 : _closedX
        transform: Translate { x: panel.slideX }
        Behavior on slideX {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }

        // Prevent backdrop click-through
        MouseArea { anchors.fill: parent; onClicked: {} }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // ── Header ────────────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 58
                color: Theme.bgAlt

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 10
                    spacing: 6

                    Text {
                        text: "Notification Center"
                        font.pixelSize: 14
                        font.bold: true
                        color: Theme.text
                        Layout.fillWidth: true
                    }

                    // DND toggle
                    HeaderButton {
                        active: root.doNotDisturb
                        activeColor: Theme.accent
                        inactiveColor: Theme.surface1
                        label: root.doNotDisturb ? "󰂛 " : "󰂚 "
                        onTriggered: root.doNotDisturbToggled()
                    }

                    // Clear all (visible only if notifications exist)
                    HeaderButton {
                        visible: root.notifServer.trackedNotifications.values.length > 0
                        active: false
                        activeColor: Theme.surface1
                        inactiveColor: Theme.surface1
                        label: " "
                        onTriggered: root.clearAllRequested()
                    }

                    // Close
                    HeaderButton {
                        active: false
                        activeColor: Theme.surface1
                        inactiveColor: Theme.surface1
                        label: "X"
                        onTriggered: root.closeRequested()
                    }
                }
            }

            // ── Scrollable body ────────────────────────────────────────────
            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: width
                contentHeight: bodyCol.implicitHeight
                clip: true
                boundsMovement: Flickable.StopAtBounds

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    width: 4
                }

                Column {
                    id: bodyCol
                    width: parent.width
                    spacing: 0

                    // Clock + Calendar
                    CalendarWidget {
                        width: parent.width
                    }

                    // MPRIS player (shown when any player exists)
                    Loader {
                        width: parent.width
                        active: Mpris.players.values.length > 0
                        sourceComponent: MprisControls {
                            width: parent.width
                            player: Mpris.players.values.length > 0
                                    ? Mpris.players.values[0] : null
                        }
                    }

                    // Separator
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.surface0
                    }

                    // Notification count header
                    Item {
                        width: parent.width
                        height: 34
                        visible: root.notifServer.trackedNotifications.values.length > 0

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            property int cnt: root.notifServer.trackedNotifications.values.length
                            text: cnt + " notification" + (cnt !== 1 ? "s" : "")
                            font.pixelSize: 11
                            color: Theme.subtext
                        }
                    }

                    // Notification list
                    Repeater {
                        model: root.notifServer.trackedNotifications

                        NotifItem {
                            required property var modelData
                            width: panel.width
                            notification: modelData
                        }
                    }

                    // Empty state
                    Item {
                        width: parent.width
                        height: 120
                        visible: root.notifServer.trackedNotifications.values.length === 0

                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "󰂚 "
                                font.pixelSize: 32
                                color: Theme.surface1
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "No notifications"
                                font.pixelSize: 13
                                color: Theme.overlay0
                            }
                        }
                    }

                    Item { width: parent.width; height: 16 }
                }
            }
        }
    }
}

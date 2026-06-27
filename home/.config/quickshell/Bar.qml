import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Services.Mpris

PanelWindow {
    id: root

    anchors.top:    true
    anchors.bottom: true
    anchors.right:  true

    exclusionMode: ExclusionMode.Normal
    implicitWidth: Config.barWidth
    color: Theme.bgAlt

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell-bar"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.exclusiveZone: Config.barWidth

    signal notifToggleRequested()

    // ── Clock ──────────────────────────────────────────────────────────────
    SystemClock { id: clock; precision: SystemClock.Minutes }

    // ── Volume ─────────────────────────────────────────────────────────────
    property real volume: 1.0
    property bool muted:  false

    function _parseVolume(line) {
        const m = line.match(/Volume:\s+([\d.]+)(\s+\[MUTED\])?/)
        if (!m) return
        volume = parseFloat(m[1])
        muted  = m[2] !== undefined
    }

    function volIcon() {
        if (muted)          return "󰝟"
        if (volume <= 0.33) return "󰕿"
        if (volume <= 0.66) return "󰖀"
        return "󰕾"
    }

    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser { onRead: data => root._parseVolume(data) }
    }

    Process {
        id: volAdjProc
        onExited: volProc.running = true
    }

    Process {
        id: volMuteProc
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        onExited: volProc.running = true
    }

    Timer {
        interval: 3000; running: true; repeat: true
        triggeredOnStart: true
        onTriggered: volProc.running = true
    }

    // ── Battery ────────────────────────────────────────────────────────────
    property bool   hasBattery: false
    property int    batPct:     0
    property string batStatus:  "Discharging"

    function _parseBattery(line) {
        const parts = line.trim().split(" ")
        if (parts.length < 2) return
        const pct = parseInt(parts[0])
        if (isNaN(pct)) return
        batPct    = pct
        batStatus = parts[1]
        hasBattery = true
    }

    function batIcon(pct, status) {
        if (status === "Charging")  return "󰂄"
        if (status === "Full")      return "󰁹"
        if (pct > 80) return "󰂂"
        if (pct > 60) return "󰂁"
        if (pct > 40) return "󰁾"
        if (pct > 20) return "󰁽"
        return "󰁺"
    }

    function batColor(pct, status) {
        if (status === "Charging") return Theme.green
        if (pct <= 20) return Theme.red
        if (pct <= 40) return Theme.yellow
        return Theme.green
    }

    Process {
        id: batProc
        command: ["bash", "-c",
            "for d in /sys/class/power_supply/BAT*; do " +
            "[ -f \"$d/capacity\" ] && echo \"$(cat $d/capacity) $(cat $d/status)\"; break; " +
            "done 2>/dev/null"]
        stdout: SplitParser { onRead: data => root._parseBattery(data) }
    }

    Timer {
        interval: 30000; running: true; repeat: true
        triggeredOnStart: true
        onTriggered: batProc.running = true
    }

    // ── Workspaces ─────────────────────────────────────────────────────────
    property var workspaces: {
        const ws = Hyprland.workspaces.values.slice()
        ws.sort((a, b) => a.id - b.id)
        return ws
    }

    Rectangle {
        anchors.fill: parent
        border.width: 1
        border.color: Theme.overlay0
        color: "transparent"

        // ── Layout ─────────────────────────────────────────────────────────────
        ColumnLayout {
            anchors { fill: parent; topMargin: 8; bottomMargin: 8 }
            spacing: 0

            // Workspaces
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Repeater {
                    model: root.workspaces

                    delegate: Rectangle {
                        required property var modelData

                        readonly property bool occupied: modelData.toplevels.values.length > 0
                        readonly property bool focused:  modelData.focused

                        implicitWidth:  25
                        implicitHeight: 25
                        radius: 5
                        Layout.alignment: Qt.AlignHCenter
                        border.width: focused ? 1 : 0

                        color: focused ? Theme.accent
                        : occupied ? Theme.surface1
                        : Theme.surface0

                        Behavior on color          { ColorAnimation  { duration: 150 } }

                        Text {
                            anchors.centerIn: parent
                            text: modelData.id
                            font.pixelSize: 12
                            font.bold: parent.focused
                            color: parent.focused ? Theme.bg : Theme.subtext
                            visible: parent.focused || parent.occupied
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modelData.activate()
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }

            // Bottom system section
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8

                // System tray
                Repeater {
                    model: SystemTray.items

                    delegate: Item {
                        required property var modelData

                        implicitWidth:  22
                        implicitHeight: 22
                        Layout.alignment: Qt.AlignHCenter

                        IconImage {
                            anchors.centerIn: parent
                            width: 16; height: 16
                            source: modelData.icon
                            smooth: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            cursorShape: Qt.PointingHandCursor
                            onClicked: mouse => {
                                const needMenu = mouse.button === Qt.RightButton
                                || modelData.onlyMenu
                                if (needMenu && modelData.hasMenu) {
                                    const pos = mapToGlobal(0, 0)
                                    modelData.display(root, -pos.x, pos.y)
                                } else {
                                    modelData.activate()
                                }
                            }
                        }
                    }
                }

                // Separator
                Rectangle {
                    width: 20; height: 1
                    Layout.alignment: Qt.AlignHCenter
                    color: Theme.surface1
                    opacity: 0.6
                }

                // Volume
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: root.volIcon()
                    font.pixelSize: 16
                    color: root.muted ? Theme.subtext : Theme.blue

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton
                        onClicked: volMuteProc.running = true
                        onWheel: wheel => {
                            volAdjProc.command = wheel.angleDelta.y > 0
                            ? ["wpctl", "set-volume", "-l", "1.5", "@DEFAULT_AUDIO_SINK@", "5%+"]
                            : ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]
                            volAdjProc.running = true
                        }
                    }
                }

                // Battery
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    visible: root.hasBattery
                    text:    root.batIcon(root.batPct, root.batStatus)
                    font.pixelSize: 16
                    color:   root.batColor(root.batPct, root.batStatus)
                }

                // Clock
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 1

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: Qt.formatTime(clock.date, "HH")
                        font.pixelSize: 15
                        font.bold: true
                        color: Theme.accent
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.notifToggleRequested()
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: Qt.formatTime(clock.date, "mm")
                        font.pixelSize: 15
                        font.bold: true
                        color: Theme.text
                    }

                    Item { width: 1; height: 4 }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: Qt.formatDate(clock.date, "ddd")
                        font.pixelSize: 9
                        color: Theme.subtext
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: Qt.formatDate(clock.date, "d")
                        font.pixelSize: 9
                        color: Theme.subtext
                    }
                }
            }
        }
   }
}

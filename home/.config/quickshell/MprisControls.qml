import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

Rectangle {
    id: root

    required property var player

    height: 92
    visible: !!player
    color: Theme.surface0

    RowLayout {
        anchors { fill: parent; margins: 12 }
        spacing: 12

        // Album art
        Rectangle {
            width: 66; height: 66
            radius: 8
            color: Theme.surface1
            clip: true

            Image {
                id: albumArt
                anchors.fill: parent
                source: root.player ? root.player.trackArtUrl : ""
                fillMode: Image.PreserveAspectCrop
                visible: source !== "" && status === Image.Ready
            }

            // Fallback music note (shown when no art)
            Text {
                anchors.centerIn: parent
                text: "♪"
                font.pixelSize: 26
                color: Theme.subtext
                visible: albumArt.source === "" || albumArt.status !== Image.Ready
            }
        }

        // Info + controls
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            // Track title
            Text {
                text: root.player ? root.player.trackTitle : ""
                font.pixelSize: 13
                font.bold: true
                color: Theme.text
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            // Artist
            Text {
                text: root.player ? root.player.trackArtist : ""
                font.pixelSize: 11
                color: Theme.subtext
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            // Playback controls
            RowLayout {
                spacing: 4

                MediaButton {
                    label: "⏮"
                    enabled: root.player && root.player.canGoPrevious
                    onTriggered: root.player.previous()
                }

                // Play/Pause (larger, accented)
                Rectangle {
                    width: 32; height: 32; radius: 16
                    color: Theme.accent
                    opacity: (root.player && root.player.canTogglePlaying) ? 1.0 : 0.4

                    Text {
                        anchors.centerIn: parent
                        text: root.player && root.player.isPlaying ? "⏸" : "▶"
                        font.pixelSize: 13
                        color: Theme.bg
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        enabled: root.player && root.player.canTogglePlaying
                        onClicked: root.player.togglePlaying()
                    }
                }

                MediaButton {
                    label: "⏭"
                    enabled: root.player && root.player.canGoNext
                    onTriggered: root.player.next()
                }

                // Shuffle indicator
                Text {
                    text: (root.player && root.player.shuffle) ? "⇌" : ""
                    font.pixelSize: 12
                    color: Theme.accent
                    visible: text !== ""
                }
            }
        }
    }
}

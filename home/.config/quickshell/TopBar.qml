import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets

PanelWindow {
    required property var modelData
    required property var windowHeight

    windowHeight: 30
    screen: modelData
    anchors {
        top: true
        left: true
        right: true
        bottom: false
    }
    implicitHeight: windowHeight

    Rectangle {
        anchors.fill: parent
        color: Theme.get.colBg

        border.width: 1
        border.color: Theme.get.col0

        RowLayout {
            anchors.fill: parent
            spacing: 8

            Item { width: 0 }

            Repeater {
                model: 6

                Rectangle {
                    implicitWidth: 15
                    implicitHeight: (windowHeight/2)
                    color: "transparent"
                    Text {
                        property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                        property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                        text: index + 1
                        color: isActive ? Theme.get.colFg : (ws ? Theme.get.col7 : Theme.get.col0)
                        font { family: Theme.get.fontFamily; pixelSize: Theme.get.fontSize; bold: true }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Hyprland.dispatch("workspace " + (index + 1))
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true }

            TrayMenu { id: trayMenu }
            TrayIcons {}

            Text {
                id: clock
                color: Theme.get.colFg
                font { family: Theme.get.fontFamilyAR; pixelSize: Theme.get.fontSize; bold: true }
                text: new Date().toLocaleString(Qt.locale("ar_EG"), "dddd dd MMM hh:mm AP")
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clock.text = new Date().toLocaleString(Qt.locale("ar_EG"), "dddd dd MMM hh:mm AP")
                }
            }

            Item { width: 0 }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: trayMenu.visible

        onClicked: {
            if(trayMenu.visible) {
                trayMenu.hideMenu()
            }
        }
    }
}

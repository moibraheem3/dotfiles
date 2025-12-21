import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Repeater {
    property var systemTray: SystemTray

    model: systemTray.items
    delegate: Item {
        width: 16
        height: 16
        Rectangle {
            anchors.centerIn: parent
            width: 16
            height: 16
            radius: 0
            color: "transparent"
            clip: true

            IconImage {
                id: trayIcon
                anchors.centerIn: parent
                width: 13
                height: 13
                smooth: false
                asynchronous: true
                backer.fillMode: Image.PreserveAspectFit
                source: {
                    let icon = modelData?.icon || ""
                    if (!icon) return ""
                    if (icon.includes("?path=")) {
                        const [name, path] = icon.split("?path=")
                        const fileName = name.substring(name.lastIndexOf("/") + 1)
                        return `file://${path}/${fileName}`
                    }
                    return icon
                }

                opacity: status === Image.Ready ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }

                Component.onCompleted: { }
            }

            MouseArea {
                id: trayMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                onClicked: (mouse) => {
                    if(!modelData || !trayMenu) return

                    if(mouse.button === Qt.LeftButton) {
                        if(trayMenu.visible) {
                            trayMenu.hideMenu()
                        }
                        modelData.activate()
                    } else if(mouse.button === Qt.RightButton) {
                        if (trayMenu.visible) {
                            trayMenu.hideMenu()
                        } else if(modelData.hasMenu && modelData.menu) {
                            const menuX = (width / 2) - (trayMenu.width / 2)
                            const menuY = 0
                            trayMenu.menu = modelData.menu
                            trayMenu.showAt(parent, menuX, menuY)
                        } else {
                            console.error("No menu available for", modelData.id, "or trayMenu not set")
                        }
                    }
                }
            }
        }
        Component.onDestruction: { }
    }
}


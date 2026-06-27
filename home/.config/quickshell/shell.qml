//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

ShellRoot {
    id: root

    // DND and theme survive reloads; panel always starts closed
    PersistentProperties {
        id: persist
        property bool doNotDisturb: false
        property string themeName: "gruvbox-dark"
    }

    // Keep Theme singleton in sync with the persisted name
    Binding { target: Theme; property: "name"; value: persist.themeName }

    property bool notifCenterOpen: false

    // Built-in QuickShell IPC — no socat/nc needed.
    // Toggle:    quickshell ipc call notifications toggle
    // Theme:     quickshell ipc call notifications setTheme catppuccin-latte
    IpcHandler {
        target: "notifications"

        function toggle() { root.notifCenterOpen = !root.notifCenterOpen }
        function open()   { root.notifCenterOpen = true }
        function close()  { root.notifCenterOpen = false }
        function dnd()    { persist.doNotDisturb = !persist.doNotDisturb }
        function setTheme(name: string) { persist.themeName = name }
    }

    // Notification server — receives and tracks all notifications
    NotificationServer {
        id: notifServer
        keepOnReload: true
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true
        inlineReplySupported: true

        onNotification: function(notif) {
            notif.tracked = true
            if (!persist.doNotDisturb)
                toastPanel.addToast(notif)
        }
    }

    // Top bar
    Bar { onNotifToggleRequested: root.notifCenterOpen = !root.notifCenterOpen }

    // Floating toast popups
    ToastPanel { id: toastPanel }

    // Notification center side panel
    NotifCenter {
        isOpen: root.notifCenterOpen
        doNotDisturb: persist.doNotDisturb
        notifServer: notifServer

        onCloseRequested:        root.notifCenterOpen = false
        onDoNotDisturbToggled:   persist.doNotDisturb = !persist.doNotDisturb
        onClearAllRequested: {
            const all = notifServer.trackedNotifications.values.slice()
            all.forEach(n => n.dismiss())
        }
    }
}

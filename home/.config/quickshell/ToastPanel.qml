import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

PanelWindow {
    id: root

    // Anchors driven by Config.toastPosition
    anchors.top:    Config.toastOnTop
    anchors.bottom: Config.toastOnBottom
    anchors.left:   Config.toastOnLeft
    anchors.right:  Config.toastOnRight

    exclusionMode:  ExclusionMode.Ignore
    color:          "transparent"
    implicitWidth:  Config.toastWidth
    implicitHeight: toastColumn.implicitHeight
    visible:        toastModel.count > 0

    // Margins push the window away from the anchored screen edge
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-toasts"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.margins {
        top:    Config.toastOnTop    ? Config.paddingTop    : 0
        bottom: Config.toastOnBottom ? Config.paddingBottom : 0
        left:   Config.toastOnLeft   ? Config.paddingLeft   : 0
        right:  Config.toastOnRight  ? Config.paddingRight  : 0
    }

    ListModel { id: toastModel }

    function addToast(notification) {
        toastModel.append({
            notifId:  notification.id,
            notifRef: notification,
            timeout:  notification.expireTimeout > 0
                      ? notification.expireTimeout * 1000
                      : 5000
        })
    }

    function removeToast(notifId) {
        for (let i = 0; i < toastModel.count; i++) {
            if (toastModel.get(i).notifId === notifId) {
                toastModel.remove(i)
                break
            }
        }
    }

    Column {
        id: toastColumn
        width: parent.width
        spacing: 8

        Repeater {
            model: toastModel

            delegate: ToastItem {
                required property int notifId
                required property var notifRef
                required property int timeout

                width: Config.toastWidth
                notification: notifRef

                onDismissRequested: root.removeToast(notifId)

                Timer {
                    interval: timeout
                    running: true
                    onTriggered: root.removeToast(parent.notifId)
                }
            }
        }
    }
}

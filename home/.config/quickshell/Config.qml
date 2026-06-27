pragma Singleton

import QtQuick
import Quickshell

// User configuration — edit the values below to customise layout.
Singleton {
    id: root

    // ── Toast notification position ────────────────────────────────────────
    // "topright" | "topleft" | "topcenter" | "bottomright" | "bottomleft"
    property string toastPosition: "bottomright"

    // ── Notification center side ───────────────────────────────────────────
    // "right" | "left"
    property string centerSide: "right"

    // ── Padding from screen edges (pixels) ────────────────────────────────
    property int paddingTop:    8
    property int paddingBottom: 8
    property int paddingLeft:   8
    property int paddingRight:  34

    // ── Bar ───────────────────────────────────────────────────────────────
    property int barWidth: 32

    // ── Toast size ────────────────────────────────────────────────────────
    property int toastWidth: 380

    // ── Notification center width ──────────────────────────────────────────
    property int centerWidth: 400

    // ── Notification center padding from screen edges (pixels) ────────────
    property int centerPaddingTop:    0
    property int centerPaddingBottom: 0
    property int centerPaddingSide:   32   // gap from the anchored left/right edge

    // ─────────────────────────────────────────────────────────────────────
    // Derived helpers — do not edit below this line
    // ─────────────────────────────────────────────────────────────────────
    readonly property bool toastOnRight:  toastPosition === "topright"    || toastPosition === "bottomright"
    readonly property bool toastOnLeft:   toastPosition === "topleft"     || toastPosition === "bottomleft"
    readonly property bool toastOnTop:    toastPosition === "topright"    || toastPosition === "topleft"  || toastPosition === "topcenter"
    readonly property bool toastOnBottom: toastPosition === "bottomright" || toastPosition === "bottomleft"
    readonly property bool toastCentered: toastPosition === "topcenter"

    readonly property bool centerOnRight: centerSide !== "left"
    readonly property bool centerOnLeft:  centerSide === "left"
}

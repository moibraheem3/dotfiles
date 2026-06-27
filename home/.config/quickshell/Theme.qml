pragma Singleton

import QtQuick
import Quickshell

// Global theme singleton — reference colors anywhere as Theme.bg, Theme.accent, etc.
// Switch theme:  quickshell ipc call notifications setTheme catppuccin-latte
Singleton {
    id: root

    // ── Active theme name ──────────────────────────────────────────────────
    property string name

    onNameChanged: _apply()
    Component.onCompleted: _apply()

    // ── Color properties (initialized to mocha, never undefined) ──────────
    property color bg:       "#1e1e2e"
    property color bgAlt:    "#181825"
    property color surface0: "#313244"
    property color surface1: "#45475a"
    property color overlay0: "#6c7086"
    property color subtext:  "#a6adc8"
    property color text:     "#cdd6f4"
    property color accent:   "#cba6f7"
    property color blue:     "#89b4fa"
    property color green:    "#a6e3a1"
    property color yellow:   "#f9e2af"
    property color red:      "#f38ba8"
    property color peach:    "#fab387"

    // ── Theme catalogue ────────────────────────────────────────────────────
    readonly property var _themes: ({
        "catppuccin-mocha": {
            bg:       "#1e1e2e",
            bgAlt:    "#181825",
            surface0: "#313244",
            surface1: "#45475a",
            overlay0: "#6c7086",
            subtext:  "#a6adc8",
            text:     "#cdd6f4",
            accent:   "#cba6f7",
            blue:     "#89b4fa",
            green:    "#a6e3a1",
            yellow:   "#f9e2af",
            red:      "#f38ba8",
            peach:    "#fab387",
        },
        "catppuccin-latte": {
            bg:       "#eff1f5",
            bgAlt:    "#e6e9ef",
            surface0: "#ccd0da",
            surface1: "#bcc0cc",
            overlay0: "#9ca0b0",
            subtext:  "#6c6f85",
            text:     "#4c4f69",
            accent:   "#8839ef",
            blue:     "#1e66f5",
            green:    "#40a02b",
            yellow:   "#df8e1d",
            red:      "#d20f39",
            peach:    "#fe640b",
        },
        "catppuccin-macchiato": {
            bg:       "#24273a",
            bgAlt:    "#1e2030",
            surface0: "#363a4f",
            surface1: "#494d64",
            overlay0: "#6e738d",
            subtext:  "#b8c0e0",
            text:     "#cad3f5",
            accent:   "#c6a0f6",
            blue:     "#8aadf4",
            green:    "#a6da95",
            yellow:   "#eed49f",
            red:      "#ed8796",
            peach:    "#f5a97f",
        },
        "gruvbox-dark": {
            bg:       "#282828",
            bgAlt:    "#1d2021",
            surface0: "#3c3836",
            surface1: "#504945",
            overlay0: "#7c6f64",
            subtext:  "#a89984",
            text:     "#ebdbb2",
            accent:   "#d3869b",
            blue:     "#83a598",
            green:    "#b8bb26",
            yellow:   "#fabd2f",
            red:      "#fb4934",
            peach:    "#fe8019",
        },
        "gruvbox-light": {
            bg:       "#fbf1c7",
            bgAlt:    "#f2e5bc",
            surface0: "#d5c4a1",
            surface1: "#bdae93",
            overlay0: "#928374",
            subtext:  "#7c6f64",
            text:     "#3c3836",
            accent:   "#b16286",
            blue:     "#076678",
            green:    "#79740e",
            yellow:   "#b57614",
            red:      "#9d0006",
            peach:    "#af3a03",
        },
        "nord": {
            bg:       "#2e3440",
            bgAlt:    "#242933",
            surface0: "#3b4252",
            surface1: "#434c5e",
            overlay0: "#4c566a",
            subtext:  "#7b88a1",
            text:     "#eceff4",
            accent:   "#b48ead",
            blue:     "#5e81ac",
            green:    "#a3be8c",
            yellow:   "#ebcb8b",
            red:      "#bf616a",
            peach:    "#d08770",
        },
        "rose-pine": {
            bg:       "#191724",
            bgAlt:    "#1f1d2e",
            surface0: "#26233a",
            surface1: "#403d52",
            overlay0: "#6e6a86",
            subtext:  "#908caa",
            text:     "#e0def4",
            accent:   "#c4a7e7",
            blue:     "#9ccfd8",
            green:    "#31748f",
            yellow:   "#f6c177",
            red:      "#eb6f92",
            peach:    "#ebbcba",
        },
        "tokyo-night": {
            bg:       "#1a1b26",
            bgAlt:    "#16161e",
            surface0: "#24283b",
            surface1: "#292e42",
            overlay0: "#565f89",
            subtext:  "#9aa5ce",
            text:     "#c0caf5",
            accent:   "#bb9af7",
            blue:     "#7aa2f7",
            green:    "#9ece6a",
            yellow:   "#e0af68",
            red:      "#f7768e",
            peach:    "#ff9e64",
        },
        "dracula": {
            bg:       "#282a36",
            bgAlt:    "#21222c",
            surface0: "#343746",
            surface1: "#424450",
            overlay0: "#6272a4",
            subtext:  "#8be9fd",
            text:     "#f8f8f2",
            accent:   "#bd93f9",
            blue:     "#6272a4",
            green:    "#50fa7b",
            yellow:   "#f1fa8c",
            red:      "#ff5555",
            peach:    "#ffb86c",
        },
    })

    // All registered theme names (useful for a picker UI)
    readonly property var available: Object.keys(_themes)

    function _apply() {
        const t = _themes[name] || _themes["gruvbox-dark"]
        bg       = t.bg
        bgAlt    = t.bgAlt
        surface0 = t.surface0
        surface1 = t.surface1
        overlay0 = t.overlay0
        subtext  = t.subtext
        text     = t.text
        accent   = t.accent
        blue     = t.blue
        green    = t.green
        yellow   = t.yellow
        red      = t.red
        peach    = t.peach
    }
}

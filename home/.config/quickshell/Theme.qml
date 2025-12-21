pragma Singleton

import Quickshell
import QtQuick

Singleton {
    property Item get: normal 

    Item {
        id: normal
        property color colBg: "#1d2021"
        property color colFg: "#ebdbb2"
        property color col0: "#404040"
        property color col1: "#ea6962"
        property color col2: "#a9b665"
        property color col3: "#d8a657"
        property color col4: "#7daea3"
        property color col5: "#d3869b"
        property color col6: "#89b482"
        property color col7: "#ada4a4"
        property color col8: "#8e7575"
        property color col9: "#d6a3a1"
        property color col10: "#c0cb87"
        property color col11: "#d0b891"
        property color col12: "#8fcfc1"
        property color col13: "#d9a8b5"
        property color col14: "#9dd195"
        property color col15: "#cfcfcf"

        property string fontFamily: "FantasqueSansM Nerd Font"
        property string fontFamilyAR: "Vazirmatn"
        property int fontSize: 16
    }
}

import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root

    implicitHeight: col.implicitHeight + 16

    // Clock updated every minute
    SystemClock {
        id: clk
        enabled: true
        precision: SystemClock.Minutes
    }

    // Calendar navigation state (init from today)
    property int viewYear:  clk.date.getFullYear()
    property int viewMonth: clk.date.getMonth() + 1   // 1–12
    property int todayDay:  clk.date.getDate()
    property int todayMon:  clk.date.getMonth() + 1
    property int todayYear: clk.date.getFullYear()

    // Recomputed when month/year changes
    property int calFirstWeekday: {
        const d = new Date(viewYear, viewMonth - 1, 1).getDay()
        return d
    }
    property int calDaysInMonth: new Date(viewYear, viewMonth, 0).getDate()
    property int calPrevMonthDays: {
        const pm = viewMonth === 1 ? 12 : viewMonth - 1
        const py = viewMonth === 1 ? viewYear - 1 : viewYear
        return new Date(py, pm, 0).getDate()
    }

    // Reset view to today when date changes (new day)
    onTodayDayChanged: {
        viewYear  = todayYear
        viewMonth = todayMon
    }

    readonly property var monthNames: [
        "January","February","March","April","May","June",
        "July","August","September","October","November","December"
    ]
    readonly property var dayHeaders: ["Su", "Mo","Tu","We","Th","Fr","Sa"]

    ColumnLayout {
        id: col
        width: parent.width
        anchors { top: parent.top; topMargin: 14 }
        spacing: 0

        // ── Clock ──────────────────────────────────────────────────────────
        Item {
            Layout.fillWidth: true
            height: 82

            Column {
                anchors.centerIn: parent
                spacing: 2

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatTime(clk.date, "h:mma")
                    font.pixelSize: 46
                    font.bold: true
                    color: Theme.text
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDate(clk.date, "dddd, dd MMMM(MM) yyyy")
                    font.pixelSize: 12
                    color: Theme.subtext
                }
            }
        }

        // ── Month navigation ───────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 14
            Layout.rightMargin: 14
            Layout.topMargin: 10

            MonthNavButton {
                label: "‹"
                onTriggered: {
                    if (root.viewMonth === 1) { root.viewMonth = 12; root.viewYear-- }
                    else root.viewMonth--
                }
            }

            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: root.monthNames[root.viewMonth - 1] + "  " + root.viewYear
                font.pixelSize: 13
                font.bold: true
                color: Theme.text
            }

            MonthNavButton {
                label: "›"
                onTriggered: {
                    if (root.viewMonth === 12) { root.viewMonth = 1; root.viewYear++ }
                    else root.viewMonth++
                }
            }
        }

        // ── Day-of-week headers ────────────────────────────────────────────
        Row {
            Layout.fillWidth: true
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 8

            Repeater {
                model: root.dayHeaders
                Text {
                    width: (parent.width) / 7
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    font.pixelSize: 10
                    color: Theme.subtext
                }
            }
        }

        // ── Calendar grid (6 rows × 7 columns = 42 cells) ─────────────────
        Item {
            Layout.fillWidth: true
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.topMargin: 4
            height: 6 * 34

            Grid {
                id: calGrid
                width: parent.width
                columns: 7
                rowSpacing: 2
                columnSpacing: 0

                Repeater {
                    model: 42

                    Item {
                        id: dayCell
                        width: calGrid.width / 7
                        height: 32

                        property int cellCol: index % 7   // 0=Mon … 6=Sun
                        property int dayNum:    index - root.calFirstWeekday + 1
                        property bool inMonth:  dayNum >= 1 && dayNum <= root.calDaysInMonth
                        property bool isToday:  inMonth
                            && dayNum         === root.todayDay
                            && root.viewMonth === root.todayMon
                            && root.viewYear  === root.todayYear

                        property string displayText: {
                            if (dayNum < 1)
                                return (root.calPrevMonthDays + dayNum).toString()
                            if (dayNum > root.calDaysInMonth)
                                return (dayNum - root.calDaysInMonth).toString()
                            return dayNum.toString()
                        }

                        Rectangle {
                            anchors.centerIn: parent
                            width: 28; height: 28; radius: 14
                            color: dayCell.isToday ? Theme.accent
                                 : (dayHov.containsMouse && dayCell.inMonth ? Theme.surface1 : "transparent")
                            Behavior on color { ColorAnimation { duration: 120 } }

                            Text {
                                anchors.centerIn: parent
                                text: dayCell.displayText
                                font.pixelSize: 12
                                font.bold: dayCell.isToday
                                color: {
                                    if (dayCell.isToday)  return Theme.bg
                                    if (!dayCell.inMonth) return Theme.surface1
                                    if (dayCell.cellCol >= 5) return Theme.accent  // Sat/Sun
                                    return Theme.text
                                }
                            }

                            MouseArea {
                                id: dayHov
                                anchors.fill: parent
                                hoverEnabled: true
                            }
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true; height: 12 }
    }
}

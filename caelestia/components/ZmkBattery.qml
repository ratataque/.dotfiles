import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Caelestia.Config
import qs.components
import qs.services

Column {
    id: root
    // width: content.width + 16
    // height: parent.height + 27
    property color colour: Colours.palette.m3tertiary

    property list<string> batteryLevels: ["--%", "--%"]
    // spacing: Appearance.spacing.small

    // MaterialIcon {
    //     anchors.horizontalCenter: parent.horizontalCenter
    //     text: "battery_horiz_075"
    //     color: root.colour
    // }

    ColumnLayout {
        id: content
        // anchors.centerIn: parent
        // anchors.horizontalCenter: parent.horizontalCenter
        // anchors.verticalCenter: parent.bottom

        Repeater {
            model: root.batteryLevels

            StyledText {
                text: modelData
                font.pointSize: Tokens.font.size.smaller
                font.family: Tokens.font.family.mono
                color: root.colour
            }
        }
    }

    Timer {
        id: timer
        running: true
        repeat: true
        interval: 5000 // 15 seconds
        onTriggered: process.running = true
    }

    Process {
        id: process
        command: ["python3", "/home/ewan/.config/caelestia/scripts/zmk-battery.py"]

        stdout: StdioCollector {
            onStreamFinished: {
                const levels = this.text.trim().split(" / ");
                if (levels.length > 0) {
                    root.batteryLevels = levels;
                } else {
                    root.batteryLevels = ["N/A"];
                }
            }
        }
    }
}

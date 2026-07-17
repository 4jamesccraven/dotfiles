import Quickshell
import Quickshell.Io
import QtQuick

import "../state"
import "../widgets"

PopupWrapper {
    implicitHeight: opts.implicitHeight + 20
    implicitWidth: 300

    Column {
        id: opts
        anchors.centerIn: parent
        width: parent.width - 20
        spacing: 8

        ShellButton {
            text: "Logout"
            command: ["hyprctl", "dispatch", "hl.dsp.exec_cmd 'hyprshutdown -t \"Logging Out...\"'"]
        }

        ShellButton {
            text: "Shutdown"
            command: ["shutdown", "now"]
        }

        ShellButton {
            text: "Reboot"
            command: ["reboot"]
        }
    }
}

pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string repoPath: "/home/jamescraven/nixos"
    property int daysSinceUpdate: 0
    property bool outOfSync: false

    function refresh() {
        updateProc.running = true
        checkProc.running = true
    }

    Timer {
        interval: 3600000 // Every hour
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()

    Process {
        id: updateProc
        command: ["bash", "-c", `
            last_update=$(
                git log --format="%ad %s" --date="format:%D" |
                    grep -i "chore: system update" |
                    head -n 1 |
                    awk '{print $1}'
            )

            days=$(( ($(date +%s) - $(date +%s -ud "$last_update")) / 3600 / 24 ))
            echo "$days"
        `]
        workingDirectory: repoPath
        stdout: StdioCollector {
            onStreamFinished: {
                const days = Number(this.text.trim())
                root.daysSinceUpdate = Number.isNaN(days) ? -1 : days
            }
        }
    }

    Process {
        id: checkProc
        command: ["bash", "-c", `
            git fetch --quiet
            [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ] && echo 'behind'
        `]
        workingDirectory: repoPath
        stdout: StdioCollector {
            onStreamFinished: root.outOfSync = this.text.trim() === "behind"
        }
    }
}

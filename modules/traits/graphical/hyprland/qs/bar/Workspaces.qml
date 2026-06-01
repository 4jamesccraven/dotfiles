import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

import "../state"
import "../widgets"

Item {
    property var monitor: null

    implicitWidth: parent.width
    implicitHeight: column.implicitHeight + 15

    Pill {
        color: Theme.mantle
    }

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: 10

            Item {
                required property int index
                readonly property int wsNumber: index + 1
                readonly property var ws: Hyprland.workspaces.values.find(w => w.id === wsNumber)
                readonly property bool occupied: ws !== undefined
                readonly property bool focused: ws !== undefined && ws.focused

                implicitWidth: 12
                implicitHeight: 12

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: focused ? Theme.accent : "transparent"
                    border.color: mouseArea.containsMouse ? Theme.text
                        : (focused || occupied) ? Theme.accent
                        : Theme.surface2
                    border.width: 1.5
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch(`hl.dsp.focus { workspace = ${wsNumber} }`)
                }
            }
        }
    }
}

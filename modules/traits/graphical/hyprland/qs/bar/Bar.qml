import Quickshell
import Quickshell.Wayland
import QtQuick

import "../state"
import "../menus"

PanelWindow {
    id: root
    required property var modelData
    property bool powerMenuShown: false
    property bool calendarShown: false
    property bool networkShown: false
    property int barWidth: 50
    property int arcRadius: 15

    screen: modelData

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    anchors {
        top: true
        left: true
        bottom: true
    }

    color: "transparent"
    implicitWidth: barWidth + arcRadius

    Rectangle {
        width: barWidth
        height: parent.height
        color: Theme.base

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 8
            width: parent.width
            spacing: 8

            Bluetooth {}
            NetworkButton {
                onClicked: {
                    // if (Network.ethernetConnected) return
                    if (!networkShown) Network.refreshNetworks()
                    networkShown = !networkShown
                }
            }
            Volume {}
        }

        // Modules centre
        Column {
            anchors.centerIn: parent
            width: parent.width
            spacing: 8

            PrivacyIndicator {}
            Workspaces {
                monitor: root.monitor
            }
            NixIndicator {}
            LockButton {}
        }

        // Modules bottom
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            width: parent.width
            spacing: 8

            KeyboardLayout {}
            BatteryIndicator {}
            Clock {
                onClicked: {
                    powerMenuShown = false
                    calendarShown = !calendarShown
                }
            }
            PowerButton {
                onClicked: {
                    calendarShown = false
                    powerMenuShown = !powerMenuShown
                }
            }
        }

        // Popups
        PowerMenu {
            barWindow: root
            visible: powerMenuShown
        }
        Calendar  {
            barWindow: root
            visible: calendarShown
        }
        WifiApplet {
            barWindow: root
            visible: networkShown
        }
    }

    Canvas {
        x: barWidth
        width: arcRadius
        height: parent.height

        onPaint: {
            var ctx = getContext("2d")
            const radius = width - 3
            const stop = height - 10
            ctx.clearRect(0, 0, width, height)
            ctx.fillStyle = Theme.base

            ctx.beginPath();
            ctx.moveTo(0,0)
            ctx.lineTo(width, 0)
            ctx.arc(width, radius, radius, -Math.PI/2, Math.PI, true);
            ctx.lineTo(3, stop);
            ctx.arc(width, stop, radius, Math.PI, (Math.PI / 2), true);
            ctx.lineTo(0, height)
            ctx.closePath();
            ctx.fill();

            ctx.beginPath()
            ctx.moveTo(width, 0)
            ctx.arc(width, radius, radius, -Math.PI/2, Math.PI, true);
            ctx.lineTo(3, stop);
            ctx.arc(width, stop, radius, Math.PI, (Math.PI / 2), true);
            ctx.strokeStyle = Theme.crust
            ctx.lineWidth = 4
            ctx.stroke()
        }
    }
}

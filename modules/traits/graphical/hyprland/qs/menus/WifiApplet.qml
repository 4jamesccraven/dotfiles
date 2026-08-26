import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

import "../state"
import "../widgets"

PopupWrapper {
    id: root
    anchorY: 0

    property string selectedSsid: ""
    property bool selectedSecured: false
    property string password: ""
    property bool connecting: false
    property bool disconnecting: false

    function resetSelected() {
        selectedSsid = ""
        password = ""
        connecting = false
        disconnecting = false
    }

    onVisibleChanged: {
        if (!visible) {
            root.resetSelected()
        }
    }

    Process {
        id: connectProc
        property string targetSsid: ""
        property string targetPassword: ""
        command: targetPassword.length > 0
            ? ["nmcli", "dev", "wifi", "connect", targetSsid, "password", targetPassword]
            : ["nmcli", "con", "up", targetSsid]
        onExited: {
            root.connecting = false
            Network.refresh()
            Network.refreshNetworks()
        }
    }

    Process {
        id: disconnectProc
        property string targetSsid: ""
        command: ["nmcli", "con", "down", targetSsid]
        onExited: {
            root.disconnecting = false
            Network.refresh()
            Network.refreshNetworks()
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6

        // HEADER
        Text {
            width: parent.width
            text: Network.ethernetConnected ? "󰈀  Ethernet"
                : Network.connected ? "󰖩  " + Network.ssid
                : "󰖪  Not connected"
            color: Theme.accent
            font.family: FontTheme.icon
            font.pixelSize: Qt.application.font.pixelSize
            horizontalAlignment: Text.AlignHCenter
            bottomPadding: 4
        }

        // NETWORKS LIST
        ListView {
            id: networkList
            model: Network.networks

            width: parent.width
            height: Math.min(contentHeight, 200)
            clip: true
            spacing: 2

            delegate: Item {
                required property var modelData
                width: networkList.width
                height: 28

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: mouseArea.containsMouse || modelData.ssid === root.selectedSsid
                        ? Theme.mantle : "transparent"

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }
                }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 6

                    Text {
                        text: modelData.active ? "󰖩" : "󰖰"
                        font.family: FontTheme.icon
                        font.pixelSize: Qt.application.font.pixelSize * 0.9
                        color: modelData.active ? Theme.accent : Theme.surface2
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: modelData.ssid
                        font.family: FontTheme.sans
                        font.pixelSize: Qt.application.font.pixelSize * 0.95
                        color: modelData.active ? Theme.accent : Theme.text
                        anchors.verticalCenter: parent.verticalCenter
                        elide: Text.ElideRight
                        width: parent.width - 40
                    }

                    Text {
                        text: modelData.security ? "󰌾" : ""
                        font.family: FontTheme.icon
                        font.pixelSize: Qt.application.font.pixelSize * 0.85
                        color: Theme.surface2
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (modelData.ssid === root.selectedSsid) {
                            root.resetSelected()
                            return
                        }
                        root.selectedSsid = modelData.ssid
                        root.selectedSecured = modelData.security.length > 0
                        root.password = ""
                    }
                }
            }
        }

        // DIVIDER
        Rectangle {
            width: parent.width
            height: 1
            color: Theme.surface0
            visible: root.selectedSsid.length > 0
        }

        // PASSWORD INPUT
        Rectangle {
            width: parent.width
            height: 30
            radius: 8
            color: Theme.text
            visible: root.selectedSsid.length > 0
                && root.selectedSecured
                && !Network.networks.find(n => n.ssid === root.selectedSsid)?.active
                && !Network.savedNetworks.includes(root.selectedSsid)

                TextField {
                    id: passwordField
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    verticalAlignment: TextField.AlignVCenter
                    font.family: FontTheme.sans
                    font.pixelSize: Qt.application.font.pixelSize * 0.95
                    echoMode: TextField.Password
                    placeholderText: "Password for " + root.selectedSsid
                    background: null
                    onTextChanged: root.password = text
            }
        }

        // CONNECT BUTTON
        Item {
            width: parent.width
            height: 30
            visible: root.selectedSsid.length > 0

            Rectangle {
                anchors.fill: parent
                radius: 8
                color: connectMouseArea.containsMouse ? Theme.surface0 : Theme.mantle

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }
            }

            Text {
                anchors.centerIn: parent
                text: root.connecting ? "Connecting..."
                    : root.disconnecting ? "Disconnecting..."
                    : Network.networks.find(n => n.ssid === root.selectedSsid)?.active ? "Disconnect from " + root.selectedSsid
                    : "Connect to " + root.selectedSsid
                font.family: FontTheme.sans
                font.pixelSize: Qt.application.font.pixelSize * 0.95
                color: Theme.accent
            }

            MouseArea {
                id: connectMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (Network.networks.find(n => n.ssid === root.selectedSsid)?.active) {
                        root.disconnecting = true
                        disconnectProc.targetSsid = root.selectedSsid
                        disconnectProc.running = true
                    } else {
                        root.connecting = true
                        connectProc.targetSsid = root.selectedSsid
                        connectProc.targetPassword = root.password
                        connectProc.running = true
                    }
                }
            }
        }
    }
}

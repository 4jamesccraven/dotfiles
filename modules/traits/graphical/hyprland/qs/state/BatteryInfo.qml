pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    id: root

    readonly property UPowerDevice bat: UPower.displayDevice
    readonly property bool available: bat.ready && bat.isLaptopBattery
    readonly property bool charging: !UPower.onBattery
    readonly property int capacity: Math.round(100 * bat.energy / bat.energyCapacity)

    readonly property string statusIcon: {
        const batteryIcons = [
            [10,       "󰁺", "󰢜"],
            [20,       "󰁻", "󰂆"],
            [30,       "󰁼", "󰂇"],
            [40,       "󰁽", "󰂈"],
            [50,       "󰁾", "󰢝"],
            [60,       "󰁿", "󰂉"],
            [70,       "󰂀", "󰢞"],
            [80,       "󰂁", "󰂊"],
            [90,       "󰂂", "󰂋"],
            [Infinity, "󰁹", "󰂅"],
        ];

        const iconIdx = root.charging ? 2 : 1;
        return batteryIcons.find(([threshold]) => root.capacity <= threshold)[iconIdx];
    }
}

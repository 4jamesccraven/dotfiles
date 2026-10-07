import "../state"
import "../widgets"

ShellButton {
    visible: BatteryInfo.available

    icon: true
    text: BatteryInfo.statusIcon + "\n" + BatteryInfo.capacity + "%"
    textScale: 0.85
    color: BatteryInfo.charging ? Theme.green
        : BatteryInfo.capacity <= 25 ? Theme.red
        : Theme.text
    bgColor: Theme.mantle
}

import Quickshell
import QtQuick
import QtQuick.Controls

import "../state"
import "../widgets"

PopupWrapper {
    property int displayMonth: new Date().getMonth()
    property int displayYear: new Date().getFullYear()

    onVisibleChanged: {
        displayMonth = new Date().getMonth()
        displayYear = new Date().getFullYear()
    }

    Column {
        anchors.centerIn: parent
        width: parent.width - 20
        spacing: 8

        Text {
            width: parent.width
            text: Time.fullTime
            color: Theme.text
            font.family: FontTheme.mono
            font.pixelSize: Qt.application.font.pixelSize * 0.9
            horizontalAlignment: Text.AlignHCenter
        }

        Row {
            width: parent.width

            ShellButton {
                width: parent.width * 0.2
                text: "←"
                onClicked: {
                    if (displayMonth === 0) {
                        displayMonth = 11
                        displayYear -= 1
                    } else {
                        displayMonth -= 1
                    }
                }
            }

            Text {
                width: parent.width * 0.6
                text: Qt.locale().standaloneMonthName(displayMonth) + " " + displayYear
                color: Theme.text
                font.family: FontTheme.sans
                font.pixelSize: Qt.application.font.pixelSize * 1.2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                height: parent.height
            }

            ShellButton {
                width: parent.width * 0.2
                text: "→"
                onClicked: {
                    if (displayMonth === 11) {
                        displayMonth = 0
                        displayYear += 1
                    } else {
                        displayMonth += 1
                    }
                }
            }
        }

        DayOfWeekRow {
            width: parent.width
            locale: Qt.locale()

            delegate: Text {
                required property string shortName
                text: shortName
                color: Theme.text
                font.family: FontTheme.sans
                font.pixelSize: Qt.application.font.pixelSize * 0.85
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        MonthGrid {
            width: parent.width
            month: displayMonth
            year: displayYear
            locale: Qt.locale()

            delegate: Rectangle {
                required property var model

                property bool isToday: {
                    void(Time.fullTime)
                    const today = new Date()
                    return model.year === today.getFullYear() &&
                           model.month === today.getMonth() &&
                           model.day === today.getDate()
                }

                property bool isCurrentMonth: model.month === displayMonth

                implicitWidth: label.implicitWidth
                implicitHeight: label.implicitHeight + 4
                radius: height / 2

                color: isToday ? Theme.accent : "transparent"

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: model.day
                    color: {
                        if (parent.isToday) return Theme.base
                        if (!parent.isCurrentMonth) return Theme.surface2
                        return Theme.text
                    }
                    font.family: FontTheme.sans
                    font.pixelSize: Qt.application.font.pixelSize * 1.1
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}


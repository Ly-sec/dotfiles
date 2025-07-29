import QtQuick
import Quickshell.Services.UPower
import QtQuick.Layouts
import qs.Settings
import qs.Components

Item {
    id: batteryWidget
    
    property var battery: UPower.displayDevice
    property bool isReady: battery && battery.ready && battery.isLaptopBattery && battery.isPresent
    property real percent: isReady ? (battery.percentage * 100) : 0
    property bool charging: isReady ? battery.state === UPowerDeviceState.Charging : false
    property bool show: isReady && percent > 0

    // Choose icon based on charge and charging state
    function batteryIcon() {
        if (!show) return "";
        if (percent >= 95) return "battery_full";
        if (percent >= 80) return "battery_80";
        if (percent >= 60) return "battery_60";
        if (percent >= 50) return "battery_50";
        if (percent >= 30) return "battery_30";
        if (percent >= 20) return "battery_20";
        return "battery_alert";
    }

    visible: isReady && battery.isLaptopBattery
    width: 22
    height: 36

    RowLayout {
        anchors.fill: parent
        spacing: 4
        visible: show
        Item {
            height: 22
            width: 22
            Text {
                text: batteryIcon()
                font.family: "Material Symbols Outlined"
                font.pixelSize: 14
                color: charging ? Theme.accentPrimary : Theme.textPrimary
                verticalAlignment: Text.AlignVCenter
                anchors.centerIn: parent
            }
            MouseArea {
                id: batteryMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onEntered: batteryWidget.containsMouse = true
                onExited: batteryWidget.containsMouse = false
                cursorShape: Qt.PointingHandCursor
            }
        }
    }

    property bool containsMouse: false

    StyledTooltip {
        id: batteryTooltip
        text: {
            let lines = [];
            if (batteryWidget.isReady) {
                lines.push(batteryWidget.charging ? "Charging" : "Discharging");
                lines.push(Math.round(batteryWidget.percent) + "%");
                if (batteryWidget.battery.changeRate !== undefined)
                    lines.push("Rate: " + batteryWidget.battery.changeRate.toFixed(2) + " W");
                if (batteryWidget.battery.timeToEmpty > 0)
                    lines.push("Time left: " + Math.floor(batteryWidget.battery.timeToEmpty / 60) + " min");
                if (batteryWidget.battery.timeToFull > 0)
                    lines.push("Time to full: " + Math.floor(batteryWidget.battery.timeToFull / 60) + " min");
                if (batteryWidget.battery.healthPercentage !== undefined)
                    lines.push("Health: " + Math.round(batteryWidget.battery.healthPercentage) + "%");
            }
            return lines.join("\n");
        }
        tooltipVisible: batteryWidget.containsMouse
        targetItem: batteryWidget
        delay: 200
    }
}
import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Timezone 1.0

Dialog {
    id: clockCreator
    property bool edit: false;
    property int clockId: 0;
    property int utcHours: 0; //hours offset
    property int utcMinutes: 0; //minutes offset
    property string timezone: ""; //timezone
    property string name: "";
    property bool timeOffsetPositive: utcHours >= 0;
    property string timeOffsetSignText: timeOffsetPositive ? "+" : "-";
    property bool useTimezone: true;
    canAccept: customTimeSwitch.checked ? true : (timezone !== "")
    Component {
        id: tzModelComponent
        TimezoneModel {}
    }

    Component.onCompleted: {
        customTimeSwitch.checked = !useTimezone;
        var tzModel = tzModelComponent.createObject(clockCreator)
        for(var key in tzModel) {
            console.log(key + " = " + tzModel[key])
        }
    }

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height
        contentWidth: parent.width
        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium
            Component.onCompleted: console.log("spacing = " + Theme.paddingMedium)
            DialogHeader {
                title: edit ? "Edit Clock" : "Create Clock"
            }
            TextField {
                id: nameField
                placeholderText: "Clock name"
                text: name;
                width: parent.width
                label: "Clock name"
            }
            ValueButton {
                id: timezoneButton
                label: "Time zone"
                value: (timezone == "") ? "Set time zone" : localizer.country + ", " + localizer.city;
                onClicked: {
                    pageStack.push(timezonePickerComponent);
                }
                enabled: !customTimeSwitch.checked
            }
            Component {
                id: timezonePickerComponent
                TimezonePicker {
                    onTimezoneClicked: {
                        console.log(name);
                        clockCreator.timezone = name; //TimezonePicker.name
                        if(nameField.text === "") {
                            nameField.text = localizer.city;
                        }
                        pageStack.pop();
                    }
                }
            }
            TextSwitch {
                id: customTimeSwitch
                checked: false;
                text: "Use custom offset from " + settingsObject.timestandard
                onCheckedChanged: {
                    useTimezone = !checked;
                }
                onClicked: if(checked) flickable.scrollToBottom()
            }
            Item {
                anchors {
                    left: parent.left
                    right: parent.right
                }
                height: Theme.itemSizeMedium
                Label {
                    id: leftPickerLabel
                    anchors.verticalCenter: iconButton.verticalCenter
                    x: Theme.paddingLarge
                    color: customTimeSwitch.checked ? Theme.primaryColor : Theme.secondaryColor
                    text: "Current offset: "
                }
                Label {
                    id: rightPickerLabel
                    anchors.left: leftPickerLabel.right
                    anchors.verticalCenter: iconButton.verticalCenter
                    color: customTimeSwitch.checked ? Theme.highlightColor : Theme.secondaryHighlightColor
                    text: iconButton.positiveOffset ? settingsObject.timestandard + "+" + timePicker.hour + ":" + timePicker.minuteText
                                                    :settingsObject.timestandard + "-" + timePicker.hour + ":" + timePicker.minuteText
                }

                IconButton {
                    id: iconButton
                    property bool positiveOffset: utcHours >= 0
                    icon.source: positiveOffset ? "image://theme/icon-m-add" : "image://theme/icon-m-remove"
                    anchors.right: parent.right
                    onClicked: positiveOffset = !positiveOffset
                }
            }

            TimePicker {
                id: timePicker
                property string minuteText: minute < 10 ? "0" + minute : minute
                hourMode: DateTime.TwentyFourHours
                hour: Math.abs(utcHours)
                minute: Math.abs(utcMinutes)
                anchors.horizontalCenter: parent.horizontalCenter
            }
            TimezoneLocalizer {
                id: localizer
                timezone: clockCreator.timezone
            }
        }
    }
    onAccepted: {
        name = nameField.text;
        if(customTimeSwitch.checked) {
            var sign = 0;
            if(iconButton.positiveOffset) {
                 sign = 1;
            } else {
                sign = -1;
            }

            utcHours = sign*timePicker.hour;
            utcMinutes = sign*timePicker.minute;
        }
        console.log("name = " + name, "utcHours = " + utcHours, "utcMinutes = " + utcMinutes, "timezone = " + timezone, "usetimezone = " + !customTimeSwitch.checked);
        if(edit) {
            clockModel.changeClock(clockId, name, utcHours, utcMinutes, timezone, !customTimeSwitch.checked);
        }
        else {
            clockModel.addClock(name, utcHours, utcMinutes, timezone, !customTimeSwitch.checked);
        }
    }
}

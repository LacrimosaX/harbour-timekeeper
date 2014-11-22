import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    property string clockName: ""
    property var localizer
    property date convertedTime: localizer.getTime()
    property bool twentyFourHourClock: Format.formatDate(new Date(), Format.TimeValue) === Format.formatDate(new Date(), Format.TimeValueTwentyFourHours)

    Row {
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: timeLabel
            text: {
                if(twentyFourHourClock) {
                    return Format.formatDate(convertedTime, Format.TimeValueTwentyFourHours)
                } else {
                    var time = Format.formatDate(convertedTime, Format.TimeValueTwelveHours)
                    return time.slice(0, time.length - 3)
                }
            }

            color: Theme.highlightColor
            font {
                pixelSize: 124/480 * root.width
                family: Theme.fontFamilyHeading
            }
        }
        Label {
            y: timeLabel.font.pixelSize - font.pixelSize
            visible: !twentyFourHourClock
            opacity: 0.4
            color: Theme.highlightColor
            text: Qt.formatTime(convertedTime, "AP")
            font {
                pixelSize: timeLabel.font.pixelSize / 2.5
                weight: Font.Bold
            }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: Theme.paddingMedium
        Label {
            id: dateLabel
            width: parent.width
            text: Qt.formatDate(convertedTime, "dddd, d MMMM, yyyy")
            horizontalAlignment: Text.AlignHCenter
        }
        Label {
            id: offsetLabel
            property string offsetText: localizer.getOffsetText()
            text: settingsObject.timestandard + offsetText
            font.pixelSize: Theme.fontSizeLarge
        }
    }

    Label {
        id: nameText
        text: clockName
        horizontalAlignment: Text.AlignHCenter
        font {
            pixelSize: Theme.fontSizeHuge
        }
        anchors {
            bottom: parent.bottom
            bottomMargin: Theme.paddingLarge
            horizontalCenter: parent.horizontalCenter
        }
    }

    Timer {
        running: true; interval: 1000; repeat: true
        onTriggered: { convertedTime = localizer.getTime(); offsetLabel.offsetText = localizer.getOffsetText() }
    }
}

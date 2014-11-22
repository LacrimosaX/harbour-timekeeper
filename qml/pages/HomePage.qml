import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Timezone 1.0
//import Sailfish.Timezone 1.0 use TimezoneModel{} for all country information -- more under /usr/lib/qt5/Sailfish/Timezone/
//also use momentjs.com/timezone/ for Timezone rules
//use QTimeZone once Qt 5.2 is available

Page {
    id: page
    property bool showSeconds: false

    SilicaGridView {
        id: gridView

        anchors.fill: parent
        model: clockModel
        cellWidth: gridView.width / itemsPerRow
        cellHeight: cellWidth

        property int itemsPerRow: 3
        property int expandedIndex: -1
        property int minOffsetIndex: expandedIndex !== -1 ? expandedIndex + itemsPerRow - (expandedIndex % itemsPerRow) : 0
        property int offset: 0

        delegate: Item {
            id: delegateContainer
            BackgroundItem {
                id: listItem
                y: doOffset ? gridView.offset : 0
                //Component.onCompleted: console.log(utcHours, utcMinutes, Qt.formatDateTime(localizer.getTime, "hh:mm"))
                onClicked: pageStack.push(Qt.resolvedUrl("IndividualClockPage.qml"), { clockName: name, localizer: localizer } )
                property bool doOffset: gridView.expandedIndex !== -1 && index >= gridView.minOffsetIndex
                onPressAndHold: {
                    contextMenu.show(listItem);
                    gridView.expandedIndex = index;
                }
                width: gridView.cellHeight
                height: contextMenu.height + contentItem.height
                contentHeight: gridView.cellHeight
                contentWidth: gridView.cellWidth
                Column {
                        anchors.centerIn: parent
                    Label {
                        width: listItem.contentWidth
                        text: (name === "") ? "Clock" : name
                        font.pixelSize: Theme.fontSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        truncationMode: TruncationMode.Fade
                        horizontalAlignment: (contentWidth > width) ? Text.AlignLeft : Text.AlignHCenter
                    }

                    Label {
                        width: listItem.contentWidth
                        text: Format.formatDate(time, Format.TimeValue) //time is now a string
                        //font.family: Theme.fontFamilyHeading
                        font.pixelSize: (contentWidth > width) ? Theme.fontSizeLarge : Theme.fontSizeHuge
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Label {
                        width: listItem.contentWidth
                        text: settingsObject.timestandard + offsetText;
                        font.pixelSize: Theme.fontSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                ContextMenu {
                    id: contextMenu
                    onHeightChanged: gridView.offset = height
                    onClosed: gridView.expandedIndex = -1
                    MenuItem {
                        text: "Edit"
                        onClicked: pageStack.push(Qt.resolvedUrl("ClockCreator.qml"),
                                                  { edit: true, name: name, utcHours: localizer.hoursOffset, utcMinutes : localizer.minutesOffset,
                                                      clockId: clockId, timezone: timezone, useTimezone: localizer.useIanaId })
                    }
                    MenuItem {
                        text: "Delete"
                        onClicked: remove()
                    }
                }
            }


            ListView.onRemove: animateRemoval(listItem)
            RemorseItem { id: remorse; wrapMode: Text.Wrap }
            function remove() {
                remorse.execute(listItem, "Deleting", function() { clockModel.removeClock(clockId)})
            }
        }


        PullDownMenu {
            MenuItem {
                text: "Settings"
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
            MenuItem {
                text: "Add clock"
                onClicked: pageStack.push(Qt.resolvedUrl("ClockCreator.qml"))
            }
            MenuLabel {
                id: menuLabel
                visible: parseInt(settingsObject.showcurrenttime) === 1
                property string timeText: Format.formatDate(new Date(), Format.TimeValue)
                function updateTimeText() {
                    Format.formatDate(new Date(), Format.TimeValue)
                }
                function getTimezoneOffsetText() {
                    var offset = new Date().getTimezoneOffset();
                    if(offset === 0) return;
                    var sign = (offset > 0) ? "-" : "+"
                    var hours = Math.floor(offset/60)
                    var minutes = offset % 60;
                    var minutesText = "";
                    if(minutes != 0) {
                        minutesText = ":" + Math.abs(minutes);
                    } else {
                        minutesText = "";
                    }

                    return sign + Math.abs(hours) + minutesText;
                }

                Connections {
                    target: timeUpdater
                    onTriggered: menuLabel.updateTimeText();
                }
                text: timeText  + " (" + settingsObject.timestandard + getTimezoneOffsetText() + ")"
            }
        }

        header: PageHeader {
            title: "Timekeeper"
        }

        ViewPlaceholder {
            enabled: gridView.count == 0
            text: "Add a clock"
        }

        VerticalScrollDecorator {
            flickable: gridView
        }
    }
}

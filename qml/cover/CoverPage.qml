import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Component.onCompleted: console.log("cover status: " + status)
    CoverPlaceholder {
        text: "Timekeeper"
        //icon.source: "image/harbour-timekeeper"
        visible: clockModel.count === 0
    }

    Label {
        id: header
        text: "Timekeeper"; visible: listView.model.count > 0;
        font.pixelSize: Theme.fontSizeLarge; font.family: Theme.fontFamilyHeading; color: Theme.highlightColor; horizontalAlignment: Text.AlignRight
        anchors {
            top: parent.top
            topMargin: Theme.paddingMedium
            left: parent.left
            right: parent.right
            rightMargin: Theme.paddingMedium
        }
    }

    SilicaListView {
        id: listView
        model: clockModel
        anchors {
            top: header.bottom
            topMargin: Theme.paddingMedium
            left: parent.left
            right: parent.right
        }
        clip: true
        height: count > 0 ? 4*currentItem.height : 0
        delegate: ListItem {
            id: listItem
            contentHeight: timeLabel.height + infoLabel.height + Theme.paddingSmall
            Label {
                id: timeLabel
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
                truncationMode: TruncationMode.Fade
                text: Format.formatDate(time, Format.TimeValue)
                horizontalAlignment: Text.AlignRight;
            }
            Label {
                id: infoLabel
                anchors {
                    top: timeLabel.bottom
                    left: parent.left
                    right: parent.right
                    leftMargin: (listItem.width - Theme.paddingMedium - infoLabel.contentWidth > Theme.paddingMedium) ?
                                    listItem.width - Theme.paddingMedium - infoLabel.contentWidth : Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
                truncationMode: TruncationMode.Fade
                font.pixelSize: Theme.fontSizeTiny
                text: name + " (" + settingsObject.timestandard + offsetText + ")";
            }
        }
    }
}


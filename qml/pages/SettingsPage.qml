import QtQuick 2.0
import Sailfish.Silica 1.0
import "database.js" as Database

Page {
    SilicaFlickable {
        anchors.fill: parent
        Column {
            anchors.fill: parent
            PageHeader {
                title: "Settings"
            }

            ComboBox {
                function getTimeStandardIndex() {
                    switch(settingsObject.timestandard) {
                    case "GMT":
                        return 0;
                    case "UTC":
                        return 1;
                    default:
                        return -1;
                    }
                }
                currentIndex: getTimeStandardIndex()
                label: "Time standard"
                menu: ContextMenu {
                    MenuItem { text: "GMT" }
                    MenuItem { text: "UTC" }
                }
                onValueChanged: {
                    Database.changeSetting("timestandard", value);
                    updateSettingsObject();
                }
            }
            TextSwitch {
                function getShowCurrentTimeBool() {
                    return parseInt(settingsObject.showcurrenttime) === 1;
                }
                text: "Show current time"
                description: "Show current time in pulley menu on main page"
                checked: getShowCurrentTimeBool()
                onCheckedChanged: {
                    Database.changeSetting("showcurrenttime", checked);
                    updateSettingsObject();
                }
            }
        }
    }
}

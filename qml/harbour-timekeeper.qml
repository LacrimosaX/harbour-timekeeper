import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "pages/database.js" as Database
import "cover"
import harbour.timekeeper 1.0

ApplicationWindow
{
    id: root
    property var settingsObject: ({})
    Component.onCompleted: updateSettingsObject()
    function updateSettingsObject() {
        var obj = Database.getSettings();
        for(var key in obj) {
            console.log(key + " = " + obj[key])
        }

        settingsObject = obj;
    }

    ClockModel {
        id: clockModel
    }
    Component {
        id: localizerComponent
        TimeLocalizer { }
    }
    initialPage: Component { HomePage { } }
    cover: CoverPage {
        id: coverPage
    }

    Timer {
        //flaw is that second is not 100% accurate
        id: timeUpdater
        running: Qt.ApplicationActive || coverPage.status === Cover.Active;
        triggeredOnStart: true; interval: 1000; repeat: true;
        onTriggered: clockModel.updateTime()
    }
}



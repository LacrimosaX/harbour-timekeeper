import QtQuick 2.0
import "database.js" as Database
//test changes that prepare for QTimezone implementation

ListModel {
    id: root
    signal modelChanged
    onModelChanged: {
        //console.log("model changed");
        updateTime();
    }
    function calculateUtcHours(convertedDate, currentDate) {
        var timeDifference = convertedDate.getTime() - currentDate.getTime();
        return Math.floor(timeDifference/(1000*60*60));
    }
    function calculateUtcMinutes(convertedDate, currentDate) {
        var timeDifference = convertedDate.getTime() - currentDate.getTime();
        return (timeDifference - calculateUtcHours(convertedDate, currentDate)*1000*60*60)/(1000*60);
    }

    function addClock(name, utcHours, utcMinutes, timezone, usetimezone) {
        var clockId = Database.addClock(name, utcHours, utcMinutes, timezone, usetimezone);
        var localizer = localizerComponent.createObject(root, { ianaId: timezone, useIanaId: usetimezone, hoursOffset: utcHours, minutesOffset: utcMinutes });
        var d = new Date();

        var obj = {
            "clockId" : clockId,
            "name": name,
            "utcHours" : utcHours,
            "utcMinutes" : utcMinutes,
            "timezone" : timezone,
            "usetimezone" : usetimezone,
            "localizer" : localizer,
            "time" : localizer.getTime(),
            "offsetText" : localizer.getOffsetText()
        }
        append(obj);
        modelChanged();
    }
    function changeClock(clockId, name, utcHours, utcMinutes, timezone, usetimezone) {
        console.log("changing clock")
        Database.changeClock(clockId, name, utcHours, utcMinutes, timezone, usetimezone);
        var d = new Date();
        for(var i = 0; i < count; i++) {
            if(get(i).clockId === clockId) {
                get(i).name = name;
                get(i).utcHours = utcHours;
                get(i).utcMinutes = utcMinutes;
                get(i).timezone = timezone;
                get(i).usetimezone = usetimezone;
                get(i).localizer.ianaId = timezone;
                get(i).localizer.useIanaId = usetimezone;
                get(i).localizer.hoursOffset = utcHours;
                get(i).localizer.minutesOffset = utcMinutes;
                get(i).time = get(i).localizer.getTime();
                get(i).offsetText = get(i).localizer.getOffsetText();
                console.log("new useIanaId = " + get(i).localizer.useIanaId, usetimezone)
                break;
            }
        }

        updateTime();
    }

    function removeClock(clockId) {
        Database.removeClock(clockId);
        for (var i = 0; i < count; i++) {
            if (get(i).clockId === clockId) {
                remove(i);
                break;
            }
        }

        modelChanged();
    }

    function updateTime() { //needs to be updated
        var d = new Date();
        for(var i = 0; i < count; i++) {
            get(i).time = get(i).localizer.getTime();
            var offset = get(i).localizer.getOffsetText();
            if(offset !== get(i).offsetText) {
                get(i).offsetText = offset;
            }
        }
    }

    Component.onCompleted: {
        var clocks = Database.getClocks();
        for(var i = 0; i < clocks.length; i++) {
            var localizer = localizerComponent.createObject(root, { ianaId: clocks[i].timezone, useIanaId: clocks[i].usetimezone,
                                                                hoursOffset: clocks[i].utcHours, minutesOffset: clocks[i].utcMinutes });

            clocks[i].localizer = localizer;
            clocks[i].time = clocks[i].localizer.getTime();
            clocks[i].offsetText = clocks[i].localizer.getOffsetText();
            append(clocks[i]);
        }


        modelChanged();
    }
}

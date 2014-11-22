.pragma library
.import QtQuick.LocalStorage 2.0 as Sql

var REVISION = 0;

var database = Sql.LocalStorage.openDatabaseSync("TimekeeperDB", "1.0", "Data for Timekeeper application");

database.transaction(migrate);

function migrate(tx) {
    tx.executeSql("CREATE TABLE IF NOT EXISTS status (" +
                  " keyname TEXT," +
                  " value TEXT" +
                  ")");
    var res = tx.executeSql("SELECT value FROM status WHERE keyname = ?",
                            ["revision"]);
    if(res.rows.length < 1) {
        //new database, set up schema
        console.log("setting up database")
        createSchema(tx)
        tx.executeSql("INSERT INTO status (keyname, value) VALUES (?, ?)",
                      ["revision", REVISION]);
    }
}

function createSchema(tx) {
    tx.executeSql("CREATE TABLE clocks (" +
                  " name TEXT," +
                  " utchours INT," +
                  " utcminutes INT," +
                  " timezone TEXT," +
                  " usetimezone BOOL," +
                  " clockid INT" +
                  ")" );

    tx.executeSql("CREATE TABLE settings (" +
                  " keyname TEXT," +
                  " value TEXT" +
                  ")" );
    tx.executeSql("INSERT INTO settings (keyname, value) VALUES (?, ?)", ["timestandard", "GMT"])
    tx.executeSql("INSERT INTO settings (keyname, value) VALUES (?, ?)", ["showcurrenttime", true])
    tx.executeSql("INSERT INTO settings (keyname, value) VALUES (?, ?)", ["showseconds", true])
}

function getClocks() {
    //returns array of clocks
    var result = [];
    function f(tx) {
        var res = tx.executeSql("SELECT name, utchours, utcminutes, timezone, usetimezone, clockid "
                                + "FROM clocks");
        for (var i = 0; i < res.rows.length; i++)
        {
            var item = res.rows.item(i);
            result.push({
                            "utcHours" : item.utchours,
                            "utcMinutes" : item.utcminutes,
                            "name" : item.name,
                            "clockId" : item.clockid,
                            "timezone" : item.timezone,
                            "usetimezone" : item.usetimezone
                        });
        }
    }
    database.transaction(f);
    return result;
}

function addClock(name, utcHours, utcMinutes, timezone, usetimezone) {
    var nextId = 0;
    function f(tx) {
        var res = tx.executeSql("SELECT max(clockid) as clockid FROM clocks");
                if (res.rows.length) {
                    nextId = res.rows.item(0).clockid + 1;
                } else {
                    nextId = 0;
                }
        tx.executeSql("INSERT INTO clocks (clockid, name, utchours, utcminutes, timezone, usetimezone) "
                      + "VALUES (?, ?, ?, ?, ?, ? )",
                      [nextId, name, utcHours, utcMinutes, timezone, usetimezone]);
    }
    database.transaction(f);

    return nextId;
}

function changeClock(clockId, name, utcHours, utcMinutes, timezone, usetimezone) {
    function f(tx) {
        tx.executeSql("UPDATE clocks SET name = ?, utchours = ?, utcminutes = ?, timezone = ?, usetimezone = ? "
                      + "WHERE clockid = ?",
                      [name, utcHours, utcMinutes, timezone, usetimezone, clockId]);
    }

    database.transaction(f);
}

function removeClock(clockId) {

    function f(tx) {
        tx.executeSql("DELETE FROM clocks WHERE clockid = ?",
                      [clockId]);
    }

   database.transaction(f);
}

function getSettings() {
    //returns settings as an object
    var result = {};
    function f(tx) {
        var res = tx.executeSql("SELECT keyname, value "
                                + "FROM settings");
        for (var i = 0; i < res.rows.length; i++)
        {
            var item = res.rows.item(i);
            result[item.keyname] = item.value;
        }
    }
    database.transaction(f);
    return result;
}

function getSetting(keyname) {
    var result = 0;
    function f(tx) {
    var res = tx.executeSql("SELECT value FROM settings WHERE keyname = ?",
                            [keyname]);
        if(res.rows.length > 1) {
            console.log("Error: too many values set for the setting " + keyname);
            result = res.rows;
            return;
        }
        if(res.rows.length < 1) {
            return; //result stays 0
        }
        result = res.rows.item(0).value;
    }
    database.transaction(f);
    return result;
}

function changeSetting(keyname, value) {
    function f(tx) {
        tx.executeSql("UPDATE settings SET value = ?"
                      + " WHERE keyname = ?",
                      [value, keyname]);
    }
    database.transaction(f);
}

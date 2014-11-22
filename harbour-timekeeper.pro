# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-timekeeper

CONFIG += sailfishapp

SOURCES += src/harbour-timekeeper.cpp \
    src/timelocalizer.cpp

OTHER_FILES += qml/harbour-timekeeper.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-timekeeper.changes.in \
    rpm/harbour-timekeeper.spec \
    rpm/harbour-timekeeper.yaml \
    translations/*.ts \
    harbour-timekeeper.desktop \
    qml/pages/ClockModel.qml \
    qml/pages/database.js \
    qml/pages/SettingsPage.qml \
    qml/pages/HomePage.qml \
    qml/pages/ClockCreator.qml \
    qml/pages/IndividualClockPage.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-timekeeper-de.ts

HEADERS += \
    src/timelocalizer.h


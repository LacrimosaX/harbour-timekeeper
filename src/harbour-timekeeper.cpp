#include <QtQuick>
#include <QtQml>
#include <sailfishapp.h>
#include "timelocalizer.h"


int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).
    qmlRegisterType<TimeLocalizer>("harbour.timekeeper", 1, 0, "TimeLocalizer");

    return SailfishApp::main(argc, argv);
}


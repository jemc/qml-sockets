
#include <QQmlExtensionPlugin>

#include <qqml.h>

#include "socket.h"

class ChartsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
    
public:
    
    void registerTypes(const char *uri)
    {
        qmlRegisterType<SomeSocket>(uri, 1, 0, "Socket");
    };
};

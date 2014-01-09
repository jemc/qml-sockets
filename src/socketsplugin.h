
#include <QQmlExtensionPlugin>

#include <qqml.h>

#include "socket.h"

class SocketsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.jemc.qml.Sockets")
    
public:
    
    void registerTypes(const char *uri)
    {
        qmlRegisterType<TCPSocket>(uri, 1, 0, "TCPSocket");
    };
};

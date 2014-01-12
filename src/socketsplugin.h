
#include <QQmlExtensionPlugin>
#include <qqml.h>


#include "tcp.h"
#include "udp_multicast.h"


class SocketsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
    
public:
    void registerTypes(const char *uri)
    {
        qmlRegisterType<TCPSocket>(uri, 1, 0, "TCPSocket");
        qmlRegisterType<UDPMulticastSocket>(uri, 1, 0, "UDPMulticastSocket");
    };
};

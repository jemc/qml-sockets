
#include <QQmlExtensionPlugin>
#include <qqml.h>


#include "tcp.h"
#include "tcp_server.h"
#include "udp_multicast.h"


class QmlSocketsPlugin : public QQmlExtensionPlugin
{
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
  
public:
  void registerTypes(const char *uri)
  {
    qmlRegisterType<TCPSocket>(uri,          1, 0, "AbstractTCPSocket");
    qmlRegisterType<TCPServer>(uri,          1, 0, "TCPServer");
    qmlRegisterType<UDPMulticastSocket>(uri, 1, 0, "UDPMulticastSocket");
  };
};

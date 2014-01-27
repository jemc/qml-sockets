
#ifndef QML_SOCKETS_TCP_SERVER
#define QML_SOCKETS_TCP_SERVER

#include <QtNetwork>

#include "tcp.h"


class TCPServer : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(uint port MEMBER m_port NOTIFY portChanged)
    
signals:
    void portChanged();
    
    void clientRead(TCPSocket* client, const QString &message);
    void clientConnected(TCPSocket* client);
    void clientDisconnected(TCPSocket* client);
    
public:
    TCPServer(QObject* parent = 0)
    {
        (void)parent;
        m_server = new QTcpServer(this);
        
        QObject::connect(m_server, &QTcpServer::newConnection,
        [=]() {
            TCPSocket *client = new TCPSocket(this);
            client->assignSocket(m_server->nextPendingConnection());
            
            QObject::connect(client, &TCPSocket::read,
            [=](const QString &message) {
                emit clientRead(client, message);
            });
            
            QObject::connect(client, &TCPSocket::disconnected,
            [=]() {
                emit clientDisconnected(client);
                delete client;
            });
            
            emit clientConnected(client);
        });
    };
    
    ~TCPServer()
    { delete m_server; m_server = NULL; }
    
public slots:
    void listen()
    { m_server->listen(QHostAddress::Any, m_port); }
    
public:
    uint m_port;
    QTcpServer *m_server = NULL;
};

#endif

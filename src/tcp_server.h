
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
    TCPServer()
    {
        m_server = new QTcpServer(this);
        
        QObject::connect(m_server, &QTcpServer::newConnection,
        [=]() {
            if(m_client)     delete m_client;
            if(m_qml_client) delete m_qml_client;
            
            m_client = m_server->nextPendingConnection();
            m_qml_client = new TCPSocket(m_client);
            
            QObject::connect(m_qml_client, &TCPSocket::read,
            [=](const QString &message) {
                emit clientRead(m_qml_client, message);
            });
            
            QObject::connect(m_qml_client, &TCPSocket::disconnected,
            [=]() {
                emit clientDisconnected(m_qml_client);
            });
            
            emit clientConnected(m_qml_client);
        });
        
    };
    
    ~TCPServer()
    {
    }
    
public slots:
    void listen()
    { m_server->listen(QHostAddress::Any, m_port); }
    
public:
    uint m_port;
    QTcpServer *m_server = NULL;
    QTcpSocket *m_client = NULL;
    TCPSocket *m_qml_client = NULL;
};

#endif

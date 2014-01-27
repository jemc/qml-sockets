
#ifndef QML_SOCKETS_TCP_SERVER
#define QML_SOCKETS_TCP_SERVER

#include <QtNetwork>
#include <QQmlComponent>

#include "tcp.h"


class TCPServer : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(uint port MEMBER m_port NOTIFY portChanged)
    Q_PROPERTY(TCPSocket* clientModel MEMBER m_clientModel NOTIFY clientModelChanged)
    
signals:
    void portChanged();
    void clientModelChanged();
    
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
            TCPSocket *client = NULL;
            
            if(m_clientModel!=NULL)
            {
                // client = qobject_cast<TCPSocket*>(m_clientModel->create());
                client = m_clientModel;
                if(client==NULL)
                    printf("WARNING: TCPServer's clientModel component must be"\
                           " a TCPSocket.  Using default TCPSocket instead.\n");
            };
            
            if(client==NULL)
                client = new TCPSocket(this);
            
            client->assignSocket(m_server->nextPendingConnection());
            
            QObject::connect(client, &TCPSocket::read,
            [=](const QString &message) {
                emit clientRead(client, message);
            });
            
            QObject::connect(client, &TCPSocket::disconnected,
            [=]() {
                emit clientDisconnected(client);
                client->deleteLater();
            });
            
            emit clientConnected(client);
            client->connected();
        });
    };
    
    ~TCPServer()
    { delete m_server; m_server = NULL; }
    
public slots:
    void listen()
    { m_server->listen(QHostAddress::Any, m_port); }
    
public:
    uint m_port;
    QTcpServer* m_server = NULL;
    TCPSocket* m_clientModel = NULL;
};

#endif

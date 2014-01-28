
#ifndef QML_SOCKETS_TCP_SERVER
#define QML_SOCKETS_TCP_SERVER

#include <QtNetwork>
#include <QQmlComponent>

#include "tcp.h"


class TCPServer : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(uint port MEMBER m_port NOTIFY portChanged)
    Q_PROPERTY(uint maxClients MEMBER m_maxClients NOTIFY maxClientsChanged)
    Q_PROPERTY(QQmlListProperty<TCPSocket> clients READ clients)
    // Q_PROPERTY(QList<TCPSocket*> m_clients MEMBER m_clients NOTIFY clientsChanged)
    Q_PROPERTY(TCPSocket* clientModel MEMBER m_clientModel NOTIFY clientModelChanged)
    
signals:
    void portChanged();
    void maxClientsChanged();
    // void clientsChanged();
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
            QTcpSocket *client_sock = NULL;
            TCPSocket *client = NULL;
            
            // Forget the new client if client count is already at max
            if(m_maxClients!=0 && (uint)m_clients.count()>=m_maxClients)
                return;
            
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
            
            // Get the next connection, and return if it didn't come through
            if((client_sock=m_server->nextPendingConnection())==NULL)
                return;
            
            // Assign the new connection to inside the client wrapper object
            client->assignSocket(client_sock);
            
            QObject::connect(client, &TCPSocket::read,
            [=](const QString &message) {
                emit clientRead(client, message);
            });
            
            QObject::connect(client, &TCPSocket::disconnected,
            [=]() {
                m_clients.removeAll(client);
                
                emit clientDisconnected(client);
                client->deleteLater();
                
                m_server->newConnection();
            });
            
            m_clients.append(client);
            
            emit clientConnected(client);
            client->connected();
        });
    };
    
    ~TCPServer()
    { delete m_server; m_server = NULL; }
    
    QQmlListProperty<TCPSocket> clients()
    { return QQmlListProperty<TCPSocket>(
        (QObject*)this, 
        (void*)&m_clients, 
        [=](QQmlListProperty<TCPSocket> *prop) 
            { return static_cast< QList<TCPSocket *> *>(prop->data)->count(); },
        [=](QQmlListProperty<TCPSocket> *prop, int index) 
            { return static_cast< QList<TCPSocket *> *>(prop->data)->at(index); }); }
    
    // int clientsCount(QQmlListProperty<TCPSocket> *prop)
    // { return static_cast< QList<TCPSocket *> *>(prop->data)->count(); }
    
    // TCPSocket* clientsAtIndex(QQmlListProperty<TCPSocket> *prop, int index)
    // { return static_cast< QList<TCPSocket *> *>(prop->data)->at(index); }
    
    
public slots:
    void listen()
    { m_server->listen(QHostAddress::Any, m_port); }
    
public:
    uint m_port;
    uint m_maxClients = 0;
    QList<TCPSocket*> m_clients;
    QTcpServer* m_server = NULL;
    TCPSocket* m_clientModel = NULL;
};

#endif

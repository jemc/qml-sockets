
#ifndef QML_SOCKETS_UDP_MULTICAST
#define QML_SOCKETS_UDP_MULTICAST

#include <QtNetwork>


class UDPMulticastSocket : public QObject
{
    Q_OBJECT
    Q_ENUMS(QAbstractSocket::SocketState)
    
    Q_PROPERTY(QString group   MEMBER m_group   NOTIFY groupChanged)
    Q_PROPERTY(uint    port    MEMBER m_port    NOTIFY portChanged)
    Q_PROPERTY(QAbstractSocket::SocketState state \
                               MEMBER m_state   NOTIFY stateChanged)
    
signals:
    void groupChanged();
    void portChanged();
    void stateChanged();
    
    void read(const QString &message);
    void connected();
    void disconnected();
    
public:
    UDPMulticastSocket()
    {
        m_socket = new QUdpSocket(this);
        
        QObject::connect(m_socket, &QAbstractSocket::stateChanged,
            [=](QAbstractSocket::SocketState state)
            {
                setProperty("state", state);
                if(state==QAbstractSocket::BoundState) emit connected();
            });
        
        QObject::connect(m_socket, &QAbstractSocket::readyRead,
            [=]()
            {
                while(m_socket->hasPendingDatagrams()) {
                    QByteArray datagram;
                    datagram.resize(m_socket->pendingDatagramSize());
                    m_socket->readDatagram(datagram.data(), datagram.size());
                    emit read(datagram.data());
                } 
            });
        
        QObject::connect(m_socket, &QAbstractSocket::disconnected,
            [=]() { emit disconnected(); });
    };
    
    ~UDPMulticastSocket()
    { delete m_socket; m_socket = NULL; }
    
public slots:
    void connect()
    {
        m_socket->bind(QHostAddress::AnyIPv4, m_port, QUdpSocket::ShareAddress);
        m_socket->joinMulticastGroup(QHostAddress(m_group));
    }
    
    void disconnect()
    {
        m_socket->leaveMulticastGroup(QHostAddress(m_group));
        m_socket->disconnectFromHost();
    }
    
    void write(QString message)
    {
        QByteArray datagram = message.toLocal8Bit();
        m_socket->writeDatagram(datagram.data(), datagram.size(),
                                QHostAddress(m_group), m_port);
    }
    
public:
    QString m_group;
    uint    m_port;
    QAbstractSocket::SocketState m_state;
    QUdpSocket *m_socket = NULL;
};

#endif

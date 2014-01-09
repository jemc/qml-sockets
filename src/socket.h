
#include <QtNetwork>

#include <unistd.h>

class SomeSocket : public QObject
{
    Q_OBJECT
    Q_ENUMS(QAbstractSocket::SocketState)
    
    Q_PROPERTY(QString host    MEMBER m_host    NOTIFY hostChanged)
    Q_PROPERTY(uint    port    MEMBER m_port    NOTIFY portChanged)
    
    Q_PROPERTY(QAbstractSocket::SocketState state MEMBER m_state NOTIFY stateChanged)
    
signals:
    void hostChanged();
    void portChanged();
    void stateChanged();
    
    void error(int socketError, const QString &message);
    void log(const QString &message);
    
    void read(const QString &message);
    void connected();
    void disconnected();
    
    
private slots:
    void privStateChanged(QAbstractSocket::SocketState socketState)
    {   setProperty("state", socketState); };
    
    void privReadyRead()
    {   emit read(m_socket->readAll()); }
    
    void privConnected()
    {   emit connected(); }
    
    void privDisconnected()
    {   emit disconnected(); }
    
public slots:
    void connect()
    {
        m_socket = new QTcpSocket(this);
        
        QObject::connect(m_socket, &QAbstractSocket::stateChanged,
                         this,      &SomeSocket::privStateChanged);
        QObject::connect(m_socket, &QAbstractSocket::readyRead,
                         this,      &SomeSocket::privReadyRead);
        QObject::connect(m_socket, &QAbstractSocket::connected,
                         this,      &SomeSocket::privConnected);
        QObject::connect(m_socket, &QAbstractSocket::disconnected,
                         this,      &SomeSocket::privDisconnected);
        
        m_socket->connectToHost(m_host, m_port);
        
        if (!m_socket->waitForConnected(5000)) {
            emit error(m_socket->error(), m_socket->errorString());
        }
    }
    
    void write(QString message)
    {
        m_socket->write(message.toLocal8Bit());
    }
    
public:
    QString m_host;
    uint    m_port;
    
    QAbstractSocket::SocketState m_state;
    
    QAbstractSocket *m_socket;
};


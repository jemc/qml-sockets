
#include <QtNetwork>

class SomeSocket : public QThread
{
    Q_OBJECT
    
    Q_PROPERTY(bool    enabled MEMBER m_enabled NOTIFY enabledChanged)
    Q_PROPERTY(QString host    MEMBER m_host    NOTIFY hostChanged)
    Q_PROPERTY(uint    port    MEMBER m_port    NOTIFY portChanged)
    
signals:
    void enabledChanged();
    void hostChanged();
    void portChanged();
    
    void error(int socketError, const QString &message);
    void log(const QString &message);
    
public:
    bool    m_enabled;
    QString m_host;
    uint    m_port;
    
    void run() {
        emit log("Starting the socket thread...");
        setProperty("enabled", true);
        emit error(0, "The socket thread isn't implemented yet...");
    };
};



#include <QtNetwork>

class SomeSocket : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(bool    enabled MEMBER m_enabled NOTIFY enabledChanged)
    Q_PROPERTY(QString host    MEMBER m_host    NOTIFY hostChanged)
    Q_PROPERTY(uint    port    MEMBER m_port    NOTIFY portChanged)
    
signals:
    void enabledChanged();
    void hostChanged();
    void portChanged();
    
public:
    bool    m_enabled;
    QString m_host;
    uint    m_port;
};


#include <QtNetwork>

class SomeSocket : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString host MEMBER m_host NOTIFY hostChanged)
    
signals:
    void hostChanged();
    
public:
    QString m_host;
};

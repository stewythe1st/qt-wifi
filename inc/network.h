/******************************************************************************
 * network.h
 *
 * Stuart Miller
 * 2022
 *****************************************************************************/
#ifndef NETWORK_H
#define NETWORK_H

/* Qt includes */
#include <QObject>
#include <QString>

class Network : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
    Q_PROPERTY(int strength READ strength WRITE setStrength NOTIFY strengthChanged)
    Q_PROPERTY(bool secured READ secured WRITE setSecured NOTIFY securedChanged)
    Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged)
public:
    explicit Network(QObject * parent = nullptr);
    Network(QString name, int strength, bool secured);
    Network(QString name, QString password);
    Network(const Network& other);
    ~Network() override;
    inline const QString name() const { return m_name; }
    inline const QString password() const { return m_password; }
    inline int strength() const { return qMin(qMax(m_strength, 1), 4); }
    inline bool secured() const { return m_secured; }
    inline QString message() const { return m_message; }
public slots:
    void setName(QString name);
    void setPassword(QString name);
    void setStrength(int strength);
    void setSecured(bool secured);
    void setMessage(QString message);
signals:
    void nameChanged();
    void passwordChanged();
    void strengthChanged();
    void securedChanged();
    void messageChanged();
private:
    QString m_name;
    QString m_password;
    int m_strength;
    bool m_secured;
    QString m_message;
};

#endif /* NETWORK_H */

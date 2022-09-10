/******************************************************************************
 * connectionManager.h
 *
 * Stuart Miller
 * 2022
 *****************************************************************************/
#ifndef CONNECTIONMANAGER_H
#define CONNECTIONMANAGER_H

/* Qt includes */
#include <QList>
#include <QObject>
#include <QQmlListProperty>

/* Application inclues */
#include "network.h"

namespace ConnectionState {
    Q_NAMESPACE
    enum ConnectionStateEnum {
        Unknown,
        Failed,
        Success
    };
    Q_ENUM_NS(ConnectionStateEnum)
}
Q_DECLARE_METATYPE(ConnectionState::ConnectionStateEnum)

class ConnectionManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Network> networks READ networks NOTIFY networksChanged)
    Q_PROPERTY(ConnectionState::ConnectionStateEnum state READ state NOTIFY stateChanged)
public:
    ConnectionManager(QObject *parent = nullptr);
    ~ConnectionManager();
    QQmlListProperty<Network> networks();
    inline ConnectionState::ConnectionStateEnum state() const { return m_state; }
    void addNetwork(QString name);
    Q_INVOKABLE void connect(QString name, QString password);
signals:
    bool connectToServer(QString name, QString password);
    void networksChanged();
    void stateChanged();
private:
    static void appendNetwork(QQmlListProperty<Network> *networks, Network *network);
    static int networkCount(QQmlListProperty<Network> *networks);
    static Network *network(QQmlListProperty<Network> *networks, int index);
    static void clearNetworks(QQmlListProperty<Network> *networks);

    QList<Network*> m_networks;
    ConnectionState::ConnectionStateEnum m_state;
};

#endif /* CONNECTIONMANAGER_H */

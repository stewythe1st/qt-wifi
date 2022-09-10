/******************************************************************************
 * network.h
 *
 * Stuart Miller
 * 2022
 *****************************************************************************/
#ifndef SERVER_H
#define SERVER_H

/* Qt includes */
#include <QObject>
#include <QString>
#include <QUrl>

#include "network.h"

class Server : public QObject {
    Q_OBJECT
public:
    Server(QObject * parent = nullptr);
    ~Server();
    bool readJson(QString fileName);
    QStringList networkNames();
public slots:
    bool validateConnection(QString name, QString password);
signals:
private:
    QList<Network*> m_networks;
};

#endif /* SERVER_H */

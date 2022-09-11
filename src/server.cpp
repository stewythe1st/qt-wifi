/******************************************************************************
 * server.cpp
 *
 * Stuart Miller
 * 2022
 *****************************************************************************/

/* Qt includes */
#include <QFile>
#include <QObject>
#include <QString>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>

/* Application includes */
#include "network.h"
#include "server.h"


Server::Server(QObject* parent) : QObject(parent) {
  Q_UNUSED(parent)
}

Server::~Server() {
  qDeleteAll(m_networks);
};

QStringList Server::networkNames() {
  QStringList networkNames;
  foreach(const Network *network, m_networks) {
    networkNames.append(network->name());
  }
  return networkNames;
}

bool Server::validateConnection(QString name, QString password) {
//  qDebug() << name << password;
  foreach(const Network* network, m_networks) {
      if(network->name() == name) {
        return (password == network->password());
      }
  }
  return false;
}

bool Server::readJson(QString fileName) {
  QFile file(fileName);
  if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
    return false;
  }
  QString contents = file.readAll();
  file.close();
  QJsonDocument json = QJsonDocument::fromJson(contents.toUtf8());
  if(json.isNull()) {
    return false;
  }
  QJsonObject object = json.object();
  if(!object.keys().contains("wifi_params")) {
    return false;
  }
  QJsonArray networks = object["wifi_params"].toArray();
  foreach(const QJsonValue &value, networks) {
      QJsonObject obj = value.toObject();
      Network* network = new Network(obj["id"].toString(), obj["auth"].toString());
//      qDebug() << network->name() << network->password();
      m_networks.append(network);
  }
  return true;
}

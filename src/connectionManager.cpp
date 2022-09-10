/******************************************************************************
 * connectionManager.cpp
 *
 * Stuart Miller
 * 2022
 *****************************************************************************/

/* Standard includes */
#include <algorithm> /* for std::sort() since qSort() is deprecated */

/* Qt includes */
#include <QQmlListProperty>
#include <QRandomGenerator>

/* Application includes */
#include "connectionManager.h"
#include "network.h"

ConnectionManager::ConnectionManager(QObject *parent) : QObject(parent) {
  Q_UNUSED(parent)
  m_state = ConnectionState::ConnectionStateEnum::Unknown;
};

ConnectionManager::~ConnectionManager() {
  qDeleteAll(m_networks);
}

struct {
    inline bool operator()(Network* a, Network* b) const {
      return a->strength() > b->strength();
    }
} NetworkSort;

void ConnectionManager::addNetwork(QString name) {
  Network* network = new Network(name, QRandomGenerator::global()->bounded(1, 4), true);
  m_networks.append(network);
  std::sort(m_networks.begin(), m_networks.end(), NetworkSort);
}

QQmlListProperty<Network> ConnectionManager::networks() {
  return QQmlListProperty<Network>(this, this, &ConnectionManager::appendNetwork,
                                   &ConnectionManager::networkCount,
                                   &ConnectionManager::network,
                                   &ConnectionManager::clearNetworks);
}

void ConnectionManager::connect(QString name, QString password) {
  Network* connectedNetwork = nullptr;
  foreach(Network* network, m_networks) {
    if(network->name() == name) {
      connectedNetwork = network;
    } else {
      if(network->message() == "Connected") {
        network->setMessage("Saved");
      }
    }
  }
  if(connectedNetwork != nullptr) {
    bool result = emit connectToServer(name, password);
    if(result) {
      m_state = ConnectionState::ConnectionStateEnum::Success;
      connectedNetwork->setMessage("Connected");
      connectedNetwork->setPassword(password);
    } else {
      m_state = ConnectionState::ConnectionStateEnum::Failed;
      connectedNetwork->setMessage("Incorrect password");
    }
    emit stateChanged();
  }
}

void ConnectionManager::appendNetwork(QQmlListProperty<Network> *networks,
                                            Network *network) {
  /* No need for UI to append to this list */
  Q_UNUSED(networks)
  Q_UNUSED(network)
}
int ConnectionManager::networkCount(QQmlListProperty<Network> *networks) {
  return reinterpret_cast<ConnectionManager *>(networks->data)
      ->m_networks.count();
}
Network* ConnectionManager::network(QQmlListProperty<Network> *networks, int index) {
  return reinterpret_cast<ConnectionManager *>(networks->data)
           ->m_networks.at(index);
}
void ConnectionManager::clearNetworks(QQmlListProperty<Network> *networks) {
  Q_UNUSED(networks)
  // Don't actually want QML to clear
}

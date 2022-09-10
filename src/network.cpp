/******************************************************************************
 * network.cpp
 *
 * Stuart Miller
 * 2022
 *****************************************************************************/

/* Qt includes */
#include <QString>
#include <QObject>

/* Application includes */
#include "network.h"

Network::Network(QObject * parent) : QObject(parent) {
  Q_UNUSED(parent);
}

Network::Network(QString name, int strength, bool secured) {
  m_name = name;
  m_strength = strength;
  m_secured = secured;
  m_message = QString();
}

Network::Network(QString name, QString password) {
  m_name = name;
  m_password = password;
  m_strength = 1;
  m_secured = true;
  m_message = QString();
}

Network::~Network() {

}

Network::Network(const Network& other) {
  m_name = other.m_name;
  m_password = QString();
  m_strength = other.m_strength;
  m_secured = other.m_secured;
  m_message = QString();
}

void Network::setName(QString name) {
  if(name != m_name) {
    m_name = name;
    emit nameChanged();
  }
}
void Network::setPassword(QString password) {
  if(password != m_password) {
    m_password = password;
    emit passwordChanged();
  }
}
void Network::setStrength(int strength) {
  if(strength != m_strength)
  { m_strength = strength;
    emit strengthChanged();
  }
}
void Network::setSecured(bool secured) {
  if(secured != m_secured) {
    m_secured = secured;
    emit securedChanged();
  }
}
void Network::setMessage(QString message) {
  if(message != m_message) {
    m_message = message;
    emit messageChanged();
  }
}

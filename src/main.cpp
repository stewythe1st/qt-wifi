/******************************************************************************
 * main.cpp
 *
 * Stuart Miller
 * 2022
 *****************************************************************************/

/* Qt includes */
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>

/* Application includes */
#include "connectionManager.h"
#include "network.h"
#include "server.h"

int main(int argc, char *argv[]) {

  /* Setup application */
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QGuiApplication app(argc, argv);
  app.setWindowIcon(QIcon(":/img/wifi_4.png"));

  /* Setup QML */
  QQmlApplicationEngine engine;
  const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
  QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                   &app, [url](QObject *obj, const QUrl &objUrl) {
    if (!obj && url == objUrl)
      QCoreApplication::exit(-1);
  }, Qt::QueuedConnection);

  /* Setup data layer - server */
  Server* server = new Server();
  const QString jsonFileName(":/data/networks2.json");
  if(!server->readJson(jsonFileName)) {
    qWarning() << QString("Unable to read network definition file '%1'.").arg(jsonFileName);
    return 1;
  }

  /* Setup data layer - client */
  qmlRegisterUncreatableMetaObject(ConnectionState::staticMetaObject, "Networking", 1, 0, "ConnectionState", "");
  qmlRegisterType<Network>("Networking", 1, 0, "Network");
  ConnectionManager* connectionManager = new ConnectionManager();
  engine.rootContext()->setContextProperty("ConnectionManager", connectionManager);
  foreach(QString name, server->networkNames()) {
    connectionManager->addNetwork(name);
  }
  QObject::connect(connectionManager, &ConnectionManager::connectToServer,
                   server, &Server::validateConnection);

  /* Run */
  engine.load(url);
  return app.exec();
}

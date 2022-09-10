###############################################################################
# wifi.pro
#
# Stuart Miller
# 2022
###############################################################################

QT += quick

SOURCES += \
    src/main.cpp \
    src/network.cpp \
    src/connectionManager.cpp \
    src/server.cpp

HEADERS += \
    inc/network.h \
    inc/connectionManager.h \
    inc/server.h

RESOURCES += \
    wifi.qrc

INCLUDEPATH += \
    inc

OTHER_FILES += \
    instructions.pdf

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = qml/

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

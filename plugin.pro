
TEMPLATE = lib

CONFIG += plugin \
          c++11
QT += qml quick

TARGET = $$qtLibraryTarget(socketsplugin)

DESTDIR = $$PWD/Sockets
SRCDIR  = $$PWD/src

OBJECTS_DIR = $$DESTDIR/.obj
MOC_DIR     = $$DESTDIR/.moc
RCC_DIR     = $$DESTDIR/.rcc
UI_DIR      = $$DESTDIR/.ui

HEADERS += $$SRCDIR/socketsplugin.h \
           $$SRCDIR/tcp.h           \
           $$SRCDIR/udp_multicast.h

target.path  = $$DESTDIR
qmldir.files = $$PWD/qmldir
qmldir.path  = $$DESTDIR

INSTALLS    += target qmldir

OTHER_FILES += $$SRCDIR/qmldir

# Copy the qmldir file to the same folder as the plugin binary
QMAKE_POST_LINK += $$QMAKE_COPY $$replace($$list($$quote($$SRCDIR/qmldir) $$DESTDIR), /, $$QMAKE_DIR_SEP)

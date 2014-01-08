TEMPLATE = lib
CONFIG += plugin
QT += qml quick

TARGET = $$qtLibraryTarget(chartsplugin)

DESTDIR = Charts

OBJECTS_DIR = $$DESTDIR/.obj
MOC_DIR = $$DESTDIR/.moc
RCC_DIR = $$DESTDIR/.rcc
UI_DIR = $$DESTDIR/.ui

HEADERS += src/chartsplugin.h \
           src/socket.h

target.path=$$DESTDIR
qmldir.files=$$PWD/qmldir
qmldir.path=$$DESTDIR
INSTALLS += target qmldir

OTHER_FILES += src/qmldir

# Copy the qmldir file to the same folder as the plugin binary
QMAKE_POST_LINK += $$QMAKE_COPY $$replace($$list($$quote($$PWD/src/qmldir) $$DESTDIR), /, $$QMAKE_DIR_SEP)

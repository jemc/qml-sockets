TEMPLATE = lib
CONFIG += plugin
QT += qml quick

TARGET = $$qtLibraryTarget(chartsplugin)

DESTDIR = Charts
OBJECTS_DIR = Charts/.obj
MOC_DIR = Charts/.moc
RCC_DIR = Charts/.rcc
UI_DIR = Charts/.ui

HEADERS += src/piechart.h \
           src/pieslice.h \
           src/chartsplugin.h

SOURCES += src/piechart.cpp \
           src/pieslice.cpp \
           src/chartsplugin.cpp

target.path=$$DESTDIR
qmldir.files=$$PWD/qmldir
qmldir.path=$$DESTDIR
INSTALLS += target qmldir

OTHER_FILES += src/qmldir

# Copy the qmldir file to the same folder as the plugin binary
QMAKE_POST_LINK += $$QMAKE_COPY $$replace($$list($$quote($$PWD/src/qmldir) $$DESTDIR), /, $$QMAKE_DIR_SEP)

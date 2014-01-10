
# QML Sockets

Exposing Qt's C++ socket objects to QML for declarative use.

## Overview

Qt [says][QmlLang]:

> QML offers a highly readable, declarative, JSON-like syntax with support for
> imperative JavaScript expressions combined with dynamic property bindings.

Qt also provides some very useful socket objects in their [QtNetwork] C++ API.

However, Qt does not provide these objects in a QML API. This plugin is an 
attempt do so in order to simplify socket programming for basic applications.
The QML API provided may not be able to handle some of the more advanced use
cases, but the lowered ceremony it brings to socket programming can get you 
from idea to implementation in just a few lines:

```qml
import Sockets 1.0

TCPSocket {
    host: "www.the-world.com"
    port: 1025
    
    Component.onCompleted: connect()
    
    onConnected: write("Hello, World!")
    
    onRead: console.log("The World says:", message)
    
    onDisconnected: console.log("Goodbye, Cruel World...")
}
```

[QmlLang]: http://qt-project.org/doc/qt-5/qmlapplications.html
[QtNetwork]: http://qt-project.org/doc/qt-5/qtnetwork-programming.html

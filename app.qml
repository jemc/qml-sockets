
import QtQuick 2.0
import Sockets 1.0

Rectangle {
    width: 300; height: 200
    color: "black"
    
    Socket {
        id: socket
        host: "127.0.0.1"
        port: 4998
        
        onError: console.log("ERROR: %1".arg(message))
        onLog:   console.log("LOG:   %1".arg(message))
        
        Component.onCompleted: start()
    }
    
    
    Column {
        Text { font.pointSize:20; color:"yellow"; text:socket.enabled }
        Text { font.pointSize:20; color:"yellow"; text:socket.host }
        Text { font.pointSize:20; color:"yellow"; text:socket.port }
    }
}


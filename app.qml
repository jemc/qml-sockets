
import QtQuick 2.0
import Sockets 1.0

Rectangle {
    width: 300; height: 200
    color: "black"
    
    Socket {
        id: socket
        host: "www.google.com"
        port: 80
        
        onError: 
            console.log("ERROR: %1".arg(message))
        onLog:   
            console.log("LOG:   %1".arg(message))
        onRead:  
            console.log("READ:  %1".arg(message))
        
        onConnected: {
            console.log("CONNECTED")
            write("HEAD / HTTP/1.0\r\n\r\n\r\n\r\n")
        }
        
        onDisconnected:
            console.log("DISCONNECTED")
        
        Component.onCompleted: 
            connect()
    }
    
    Column {
        Text { font.pointSize:20; color:"yellow"; text:socket.host }
        Text { font.pointSize:20; color:"yellow"; text:socket.port }
        Text { font.pointSize:20; color:"yellow"; text:socket.state }
    }
}


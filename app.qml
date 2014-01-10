
import QtQuick 2.0
import QtQuick.Controls 1.1

import Sockets 1.0

Rectangle {
    width: 300; height: 200
    color: "black"
    
    UDPMulticastSocket {
        id: socket
        group: "239.255.250.250"
        port: 9131
        
        property var latest: ""
        
        onError: 
            console.log("ERROR: %1".arg(message))
            
        onRead: {
            console.log("READ:  %1".arg(message))
            latest = message
        }
        
        onConnected:
            console.log("CONNECTED")
        
        onDisconnected:
            console.log("DISCONNECTED")
        
        Component.onCompleted: 
            connect()
    }
    
    Column {
        Text { font.pointSize:20; color:"yellow"; text:socket.group }
        Text { font.pointSize:20; color:"yellow"; text:socket.port }
        Text { font.pointSize:20; color:"yellow"; text:socket.state }
        Text { font.pointSize:20; color:"yellow"; text:socket.latest }
        Button { text: "Connect"; onClicked: socket.connect() }
        Button { text: "Write";   onClicked: socket.write("LOOK AT ME") }
    }
    
}


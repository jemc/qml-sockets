
import QtQuick 2.0
import Sockets 1.0

Item {
    width: 300; height: 200
    
    Socket {
        id:socket
        host:"127.0.0.1"
    }
    
    Text { text:socket.host }
}


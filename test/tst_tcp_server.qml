
import QtTest 1.0
import QtQuick 2.0

import org.jemc.qml.Sockets 1.0

TestCase {
    id: test
    name: "TCPSocket"
    
    TCPServer {
        id: server
        port: 4998
        
        maxClients: 3
        
        property var response: ""
        property var expected: /Thanks/
        
        onClientConnected: {
            client.write("Welcome")
        }
        onClientRead: {
            response += message
            client.disconnect()
        }
        onClientDisconnected: {
            test.verify(response!=undefined, "No response received")
            test.verify(response.search(expected)>=0, 
                           "Unrecognized response received: %1".arg(response))
        }
    }
    
    TCPSocket {
        id: socket
        host: "localhost"
        port: server.port
        
        property var response: ""
        property var expected: /Welcome/
        
        onRead: {
            response += message
            write("Thanks, Server!")
        }
        onDisconnected: {
            test.verify(response!=undefined, "No response received")
            test.verify(response.search(expected)>=0, 
                           "Unrecognized response received: %1".arg(response))
        }
    }
    
    function wait_for_disconnect() { while(socket.state!=0) { wait(0) } }
    
    function test_it() {
        socket.connect()
        wait_for_disconnect()
    }
}

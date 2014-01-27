
import QtTest 1.0
import QtQuick 2.0

import org.jemc.qml.Sockets 1.0

TestCase {
    id: test
    name: "TCPServer"
    
    TCPServer {
        id: server
        port: 4998
        
        property var verified: false
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
            test.verify(response!="", "No response from client")
            test.verify(response.search(expected)>=0, 
                           "Unrecognized response from client: %1".arg(response))
            verified = true
        }
    }
    
    TCPSocket {
        id: socket
        host: "localhost"
        port: server.port
        
        property var verified: false
        property var response: ""
        property var expected: /Welcome/
        
        onRead: {
            response += message
            write("Thanks, Server!")
        }
        onDisconnected: {
            test.verify(response!="", "No response from server")
            test.verify(response.search(expected)>=0, 
                           "Unrecognized response from server: %1".arg(response))
            verified = true
        }
    }
    
    function wait_for_disconnect() { while(socket.state!=0) { wait(0) } }
    
    function test_it() {
        server.listen()
        socket.connect()
        wait_for_disconnect()
        verify(socket.verified, "Disconnect hook never ran on socket.")
        verify(server.verified, "Disconnect hook never ran on server.")
    }
}

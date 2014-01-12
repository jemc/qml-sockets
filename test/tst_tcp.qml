
import QtTest 1.0
import QtQuick 2.0

import org.jemc.qml.Sockets 1.0

TestCase {
    id: test
    name: "TCPSocket"
    
    TCPSocket {
        id: socket
        host: "www.example.com"
        port: 80
        
        property var response: ""
        property var expected: /HTTP\/[^\n]* OK/
        
        onConnected: write("GET / HTTP/1.1\r\nHost: %1\r\nConnection: close\r\n\r\n".arg(host))
        onRead: response += message
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


import QtTest 1.0
import QtQuick 2.0

import org.jemc.qml.Sockets 1.0

TestCase {
    id: test
    name: "UDPMulticastSocket"
    
    UDPMulticastSocket {
        id: socket
        group: "239.255.250.250"
        port: 9131
        
        property var verified: false
        property var response: ""
        property var expected: /HTTP\/[^\n]* OK/
        
        onRead: response += message
    }
    
    function wait_for_connect()    { while(socket.state!=4) { wait(0) } }
    function wait_for_disconnect() { while(socket.state!=0) { wait(0) } }
    
    function test_it() {
        socket.connect()
        wait_for_connect()
        
        compare(socket.response, "")
        socket.write("test")
        wait(100)
        compare(socket.response, "test")
        
        socket.disconnect()
        wait_for_disconnect()
    }
}

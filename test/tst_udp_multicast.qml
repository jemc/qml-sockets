
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
        
        property var lastRead
        property var readCount: 0
        
        onRead: { lastRead = message; readCount += 1 }
    }
    
    function wait_for_connect()    { while(socket.state!=4) { wait(0) } }
    function wait_for_disconnect() { while(socket.state!=0) { wait(0) } }
    
    function test_it() {
        socket.connect()
        wait_for_connect()
        
        compare(socket.lastRead, undefined)
        compare(socket.readCount, 0)
        socket.write("test")
        wait(100)
        compare(socket.lastRead, "test")
        compare(socket.readCount, 1)
        socket.write("other")
        wait(100)
        compare(socket.lastRead, "other")
        compare(socket.readCount, 2)
        
        socket.disconnect()
        wait_for_disconnect()
    }
}

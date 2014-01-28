
import QtTest 1.0
import QtQuick 2.0

import org.jemc.qml.Sockets 1.0

TestCase {
    id: test
    name: "TCPServer#maxClients"
    
    TCPServer {
        id: server
        port: 4998
        
        maxClients: 3
        
        property var verified_count: 0
        property var response: ""
        property var expected: /Thanks/
        property var expected_con_counts: [1,2,3,3,3]
        property var expected_dis_counts: [2,2,2,1,0]
        
        onClientConnected: {
            test.verify(clients.length==expected_con_counts.shift())
            client.write("Welcome")
        }
        onClientRead: {
            response += message
            client.disconnect()
        }
        onClientDisconnected: {
            test.verify(clients.length==expected_dis_counts.shift())
            
            test.verify(response!="", "No response from client")
            test.verify(response.search(expected)>=0, 
                           "Unrecognized response from client: %1".arg(response))
            verified_count += 1
        }
        
        // This tests that using a delegate doesn't break with multiple clients
        clientDelegate: TCPSocket { }
    }
    
    ServerTestSocket { id:socket1; test:test }
    ServerTestSocket { id:socket2; test:test }
    ServerTestSocket { id:socket3; test:test }
    ServerTestSocket { id:socket4; test:test }
    ServerTestSocket { id:socket5; test:test }
    
    function wait_for_disconnect() { 
        while(socket1.state!=0 ||
              socket2.state!=0 ||
              socket3.state!=0 ||
              socket4.state!=0 ||
              socket5.state!=0) { wait(0) }
    }
    
    function test_it() {
        server.listen()
        socket1.connect()
        socket2.connect()
        socket3.connect()
        socket4.connect()
        socket5.connect()
        wait_for_disconnect()
        verify(socket1.verified, "Disconnect hook never ran on socket1.")
        verify(socket2.verified, "Disconnect hook never ran on socket2.")
        verify(socket3.verified, "Disconnect hook never ran on socket3.")
        verify(socket4.verified, "Disconnect hook never ran on socket4.")
        verify(socket5.verified, "Disconnect hook never ran on socket5.")
        verify(server.verified_count==5, "The 5 disconnect hooks didn't run.")
    }
}

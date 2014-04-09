
import QtTest 1.0
import QtQuick 2.0

import org.jemc.qml.Sockets 1.0

TestCase {
  id: test
  name: "TCPServer#clientDelegate"
  
  TCPServer {
    id: server
    port: 4998
    
    property var verified: false
    
    clientDelegate: TCPSocket {
      property var response: ""
      property var expected: /Thanks/
      
      onConnected: write("Welcome")
      
      onRead: {
        response += message
        disconnect()
      }
      onDisconnected: {
        test.verify(response!="", "No response from client")
        test.verify(response.search(expected)>=0, 
                 "Unrecognized response from client: %1".arg(response))
        server.verified = true
      }
    }
  }
  
  ServerTestSocket { id: socket; test: test }
  
  function wait_for_disconnect() { while(socket.state!=0) { wait(0) } }
  
  function test_it() {
    server.listen()
    socket.connect()
    wait_for_disconnect()
    verify(socket.verified, "Disconnect hook never ran on socket.")
    verify(server.verified, "Disconnect hook never ran on server.")
  }
}

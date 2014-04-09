
import QtTest 1.0
import QtQuick 2.0

import org.jemc.qml.Sockets 1.0

TCPSocket {
  host: "localhost"
  port: server.port
  
  property var test
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


import QtTest 1.0
import QtQuick 2.0

import org.jemc.qml.Sockets 1.0

TestCase {
  id: test
  name: "TCPSocket initial"
  
  TCPSocket {
    id: socket
  }
  
  function test_state() {
    compare(socket.state, 0)
  }
}

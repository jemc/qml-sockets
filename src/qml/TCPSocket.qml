
import QtQuick 2.1

import org.jemc.qml.Sockets 1.0


AbstractTCPSocket {
  
  // The expression to scan for in the incoming buffer
  property var expression: /(.*?)[\r\n]+/
  
  // When the expression is matched in the buffer,
  // match is signalled with the matching string
  signal match(var matchString)
  
  property string matchBuffer: ""
  
  onRead: {
    matchBuffer += message
    var str
    
    while(str = matchBuffer.match(expression)) {
      str = str[0]
      matchBuffer = matchBuffer.slice(str.length)
      match(str)
    }
  }
  
  onConnected: {
    matchBuffer = ""
  }
}

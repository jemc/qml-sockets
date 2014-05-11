
import QtQuick 2.1

import org.jemc.qml.Sockets 1.0


AbstractTCPSocket {
  
  // When the expression is matched in the buffer,
  // match is signalled with the matching string
  signal match(string matchString, var matchCaptures, string preMatchString)
  
  onRead: {
    // Expression matching is disabled by default to save memory (matchBuffer)
    if(expression.source !== '(?:)') {
      // Append the new message to the buffer
      matchBuffer += message
      
      // Pull out each match and pre-match and trigger the signal
      var data, idx, str, pre
      while(data = matchBuffer.match(expression)) {
        idx = matchBuffer.search(expression)
        str = data[0]
        pre = matchBuffer.slice(0, idx)
        matchBuffer = matchBuffer.slice(str.length+idx)
        match(str, data.slice(1), pre)
      }
    }
  }
}

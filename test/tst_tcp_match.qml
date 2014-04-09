
import QtTest 1.0
import QtQuick 2.0

import org.jemc.qml.Sockets 1.0

TestCase {
  id: test
  name: "TCPSocket#match"
  
  TCPServer {
    id: server
    port: 4998
    
    property string welcome
    property string welcome2
    
    function reset() { welcome  = ""; welcome2 = "" }
    Component.onCompleted: {
      reset()
      compare(socket.expression,
              undefined, "expression matching is disabled by default")
    }
    
    onClientConnected: {
      client.write(welcome)
      test.wait(15) // Space between messages to separate as packets
      client.write(welcome2)
      client.disconnect()
    }
  }
  
  TCPSocket {
    id: socket
    host: "127.0.0.1"
    port: 4998
    
    property var matches
    property var preMatches
    property var captures
    
    function reset() { matches = []; preMatches = []; captures = [] }
    Component.onCompleted: reset()
    
    onMatch: {
      matches   .push(   matchString  )
      preMatches.push(preMatchString  )
      captures  .push(   matchCaptures)
    }
    
    onConnected: {
      test.compare(socket.matchBuffer, "", "matchBuffer reset on connect")
    }
  }
  
  function initTestCase() { server.listen() }
  
  function wait_for_connect()    { while(socket.state!==2) { wait(0) } }
  function wait_for_disconnect() { while(socket.state!==0) { wait(0) } }
  
  function test_match() {
    socket.reset()
    server.reset()
    
    socket.expression = /(.*?)[\r\n]+/
    
    server.welcome  = "Welcome\nthe\rlovely "
    server.welcome2 = "new\n\rclient\r\nthe_rest"
    
    socket.connect()
    wait_for_disconnect()
    
    compare(socket.matches, ["Welcome\n","the\r","lovely new\n\r","client\r\n"])
    compare(socket.matchBuffer, "the_rest")
  }
  
  function test_prematch() {
    socket.reset()
    server.reset()
    
    socket.expression = /[a-z]+(?=[^a-z])/
    server.welcome  = "!foo_ba"
    server.welcome2 = "r_99_baz!!!"
    
    socket.connect()
    wait_for_disconnect()
    
    compare(socket.matches,    ["foo","bar","baz"])
    compare(socket.preMatches, ["!","_","_99_"])
    compare(socket.captures,   [[],[],[]])
    compare(socket.matchBuffer, "!!!")
  }
  
  function test_captures() {
    socket.reset()
    server.reset()
    
    socket.expression = /([a-z]+)_([a-z]+)[\r\n]+/
    server.welcome  = "foo_ba"
    server.welcome2 = "r\nfoo_baz\n"
    
    socket.connect()
    wait_for_disconnect()
    
    compare(socket.matches,    ["foo_bar\n","foo_baz\n"])
    compare(socket.preMatches, ["",""])
    compare(socket.captures,   [["foo","bar"],["foo","baz"]])
    compare(socket.matchBuffer, "")
  }
}

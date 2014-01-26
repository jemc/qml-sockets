
import QtQuick 2.0
import QtQuick.Controls 1.1

import org.jemc.qml.Sockets 1.0

Rectangle {
  width: 800; height: 1000
  color: "black"
  
  UDPMulticastSocket {
    group: "239.255.250.250"
    port: 9131
  // TCPSocket {
  //     host: "localhost"
  //     port: 4998
    
    id: socket
    
    onRead: listModel.insert(0, {"type": message})
    
    Component.onCompleted: connect()
  }
  
  ListModel{ id: listModel }
  
  Row {
    height: parent.height
    Column {
      width: 600
      height: parent.height
      Text { font.pointSize:20; color:"yellow"; text:socket.group }
      Text { font.pointSize:20; color:"yellow"; text:socket.port }
      Text { font.pointSize:20; color:"yellow"; text:socket.state }
      Text { font.pointSize:20; color:"yellow"; text:socket.latest }
      Button { text: "Connect";    onClicked: socket.connect() }
      Button { text: "Disconnect"; onClicked: socket.disconnect() }
      Button { text: "Write";      onClicked: socket.write("LOOK AT ME") }
    }
    
    Column {
      width: 50
      height: parent.height
      ListView {
        anchors.fill: parent
        model: listModel
        delegate: Rectangle {
          height: 40
          width: 600
          color: "purple"
          Text { font.pointSize:20; color:"white"; text:model.type }
        }
      }
    }
  }
  
}


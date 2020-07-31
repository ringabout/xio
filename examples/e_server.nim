import net


var socket = newSocket()
socket.bindAddr(Port(5000))
socket.listen()

var client: Socket
var address = ""
while true:
  socket.acceptAddr(client, address)
  echo("Client connected from: ", address)
  client.send("from socket")

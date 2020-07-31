import net


var socket = newSocket()
socket.bindAddr(Port(5000))
socket.listen()

var client: Socket
var address = ""
while true:
  socket.acceptAddr(client, address)
  echo("Client connected from: ", address)
  echo(client.recvLine)
  client.send("from socket")

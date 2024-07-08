import ../src/xio/windows/[wsadata, winsock2]
import ../src/xio/windows/base/[ws2types, ws2tcpip, ws2def]

block:
  proc main =
    var wsa: WSAData

    if WSAStartup(0x0101, addr wsa) != 0:
      doAssert false

    var
      address = "127.0.0.1"
      port = "5000"

    var hints: AddrInfoA
    var result: PAddrInfoA

    zeroMem(addr hints, sizeof(hints))

    hints.aiFamily = AF_INET
    hints.aiSocktype = 1
    hints.aiProtocol = 6

    echo getAddrInfo(cstring(address), cstring(port), addr hints, addr result)

    var connectSocket = socket(result.aiFamily, result.aiSocktype,
        result.aiProtocol)
    discard bindAddr(connectSocket, result.aiAddr, cast[cint](result.aiAddrLen))
    discard listen(connectSocket, SOMAXCONN)


    while true:
      var address: SockAddr
      var addressLen = sizeof(address).cint
      var client = accept(connectSocket, addr address, addressLen)
      var text = "This is a test!\n"
      doAssert client.send(cstring(text), text.len.cint, 0) == text.len

    freeAddrInfo(result)


  main()

# import net


# var socket = newSocket()
# socket.bindAddr(Port(5000))
# socket.listen()

# var client: Socket
# var address = ""
# while true:
#   socket.acceptAddr(client, address)
#   echo("Client connected from: ", address)
#   echo(client.recvLine)
#   client.send("from socket")

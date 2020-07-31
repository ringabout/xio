import ../src/xio/iokit/iocp
import ../src/xio/iokit/iocp/wsadata
import ../src/xio/iokit/iocp/winsock2
import ../src/xio/iokit/iocp/base/ws2types
import ../src/xio/iokit/iocp/base/bsdtypes
import ../src/xio/iokit/iocp/base/ws2tcpip
import ../src/xio/iokit/iocp/base/ws2def

# proc getAddrInfo*(
#   pNodeName: PCSTR,
#   pServiceName: PCSTR,
#   pHints: ptr AddrInfoA,
#   ppResult: var PAddrInfoA
# ): cint {.libWs2_32, importc: "getaddrinfo"}

block:
  # echo inet_addr("127.0.0.1")
  # echo inet_addr("1.0.0.127")
  # echo htons(0x1)
  # echo htons(256)
  # echo htonl(1)

  var wsa: WSAData
  if WSAStartup(0x0101, addr wsa) != 0: 
    doAssert false
  let 
    address = "www.baidu.com"
    port = "80"

  var hints: AddrInfoA
  var result: ptr AddrInfoA

  zeroMem(addr hints, sizeof(hints))

  hints.aiFamily = AF_INET
  hints.aiSocktype = 1
  hints.aiProtocol = 6

  echo getAddrInfo(address, port, addr hints, result)
  echo result.repr

  var connectSocket = socket(result.aiFamily, result.aiSocktype, result.aiProtocol)
  echo connect(connectSocket, result.aiAddr[], cast[cint](result.aiAddrlen))

  freeAddrInfo(result)
  discard WSACleanup()

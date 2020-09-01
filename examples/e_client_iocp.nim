import ../src/xio/windows/iocp
import ../src/xio/windows/wsadata
import ../src/xio/windows/winsock2
import ../src/xio/windows/base/ws2types
import ../src/xio/windows/base/bsdtypes
import ../src/xio/windows/base/ws2tcpip
import ../src/xio/windows/base/ws2def
import ../src/xio/windows/base/sockettypes

import os


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

  proc main =
    var queue = createIoCompletionPort(INVALID_HANDLE_VALUE, cast[Handle](0), 0, 1)

    if queue == nil:
      raiseOSError(osLastError())

    var wsa: WSAData

    if WSAStartup(0x0101, addr wsa) != 0: 
      doAssert false

    let 
      address = "127.0.0.1"
      port = "5000"

    var hints: AddrInfoA
    var result: PAddrInfoA

    zeroMem(addr hints, sizeof(hints))

    hints.aiFamily = AF_INET
    hints.aiSocktype = 1
    hints.aiProtocol = 6

    echo getAddrInfo(address, port, addr hints, addr result)
    echo result.repr

    var connectSocket = socket(result.aiFamily, result.aiSocktype, result.aiProtocol)
    echo connect(connectSocket, result.aiAddr, cast[cint](result.aiAddrlen))

    # var s = "This is a test!\n"
    # echo send(connectSocket, s, s.len.cint, 0)
    # let ires = shutdown(connectSocket, SD_SEND)
    # if ires == SOCKET_ERROR:
    #   echo "shutdown failed: ", WSAGetLastError()
    #   discard closeSocket(connectSocket)
    #   discard WSACleanup()
    #   return

    var recvBuf = newString(16)

    var buffer: array[200, char]
    var b = WSABUF(len: 200, buf: buffer.addr)

    var nums: culong
    var over: WSAOVERLAPPED


  # LPWSABUF* = ptr WSABUF


  # lpFlags: LPDWORD,
  # lpOverlapped: LPWSAOVERLAPPED,
  # lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE

    var flag = cast[DWORD](0)

    let res = WSARecv(connectSocket, addr b, 1, nums, flag, addr over, nil)

    discard createIoCompletionPort(over.hevent, queue, 0, 1)

    var data: DWORD
    var key: ULONG_PTR

    # while true:
  # completionPort: Handle,
  # lpNumberOfBytesTransferred: var DWORD,
  # lpCompletionKey: var ULONG_PTR,
  # lpOverlapped: var OVERLAPPED,
  # dwMilliseconds: DWORD

      # getQueuedCompletionStatus(queue, data, key, over, 10)

    # let res = recv(connectSocket, recvBuf, recvBuf.len.cint, 0)

    # echo WSAGetLastError()

    echo res
    echo recvBuf
    echo "done"


    freeAddrInfo(result)
    discard closeSocket(connectSocket)
    # discard WSACleanup()

  main()

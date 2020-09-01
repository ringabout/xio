import wsadata, guiddef
import base / [ntdef, minwinbase, sockettypes, winnt, ws2types, minwindef, qos, bsdtypes, inaddr]


{.pragma: libWs2_32, stdcall, dynlib: "Ws2_32.dll".}


const
  MAX_PROTOCOL_CHAIN = 7
  WSAPROTOCOL_LEN = 255

type
  GROUP* = uint32

  WSAPROTOCOLCHAIN* = object
    chainLen*: cint
    chainEntries*: array[MAX_PROTOCOL_CHAIN, DWORD]
  
  LPWSAPROTOCOLCHAIN* = ptr WSAPROTOCOLCHAIN

  WSAPROTOCOL_INFOW* = object
    dwServiceFlags1*: DWORD
    dwServiceFlags2*: DWORD
    dwServiceFlags3*: DWORD
    dwServiceFlags4*: DWORD
    dwProviderFlags*: DWORD
    providerId*: GUID
    dwCatalogEntryId*: DWORD
    protocolChain*: WSAPROTOCOLCHAIN
    iVersion*: cint
    iAddressFamily*: cint
    iMaxSockAddr*: cint
    iMinSockAddr*: cint
    iSocketType*: cint
    iProtocol*: cint
    iProtocolMaxOffset*: cint
    iNetworkByteOrder*: cint
    iSecurityScheme*: cint
    dwMessageSize*: DWORD
    dwProviderReserved*: DWORD
    szProtocol*: array[WSAPROTOCOL_LEN + 1, WChar]
  
  LPWSAPROTOCOL_INFOW* = ptr WSAPROTOCOL_INFOW

  QOS* = object
    sendingFlowspec*: FLOWSPEC
    receivingFlowspec*: FLOWSPEC
    providerSpecific*: WSABUF

  LPQOS* = ptr QOS


const
  WSA_IO_PENDING* = 997'i32
  INFINITE* = -1'i32

  AF_UNSPEC* = 0
  AF_UNIX* = 1
  AF_INET* = 2
  AF_IMPLINK* = 3
  AF_PUP* = 4
  AF_CHAOS* = 5
  AF_NS* = 6
  AF_IPX* = AF_NS
  AF_ISO* = 7
  AF_OSI* = AF_ISO
  AF_ECMA* = 8
  AF_DATAKIT* = 9
  AF_CCITT* = 10
  AF_SNA* = 11
  AF_DECnet* = 12
  AF_DLI* = 13
  AF_LAT* = 14
  AF_HYLINK* = 15
  AF_APPLETALK* = 16
  AF_NETBIOS* = 17
  AF_VOICEVIEW* = 18
  AF_FIREFOX* = 19
  AF_UNKNOWN1* = 20
  AF_BAN* = 21
  AF_ATM* = 22
  AF_INET6* = 23
  AF_CLUSTER* = 24
  AF_12844* = 25
  AF_IRDA* = 26
  AF_NETDES* = 28
  AF_TCNPROCESS* = 29
  AF_TCNMESSAGE* = 30
  AF_ICLFXBM* = 31
  AF_BTH* = 32
  AF_MAX* = 33


  SD_RECEIVE* = 0 ## Shutdown receive operations.
  SD_SEND* = 1    ## Shutdown send operations.
  SD_BOTH* = 2    ## Shutdown both send and receive operations.

  SOL_SOCKET* = 0xffff
  SOMAXCONN* = 0x7fffffff

proc WSAStartup*(wVersionRequested: Word, 
                 lpWSAData: LPWSADATA): cint {.libWs2_32, importc: "WSAStartup".}

proc WSASocket*(
  af: cint,
  theType: cint,
  protocol: cint,
  lpProtocolInfo: LPWSAPROTOCOL_INFOW,
  g: GROUP,
  dwFlags: DWORD
): SocketHandle {.libWs2_32, importc: "WSASocketW".}

proc socket*(af, typ, protocol: cint): SocketHandle {.libWs2_32, importc: "socket".}

proc accept*(s: SocketHandle, a: ptr SockAddr, 
             addrlen: var cint): SocketHandle {.libWs2_32, importc: "accept".}

proc bindAddr*(s: SocketHandle, name: ptr SockAddr, 
               namelen: cint): cint {.libWs2_32, importc: "bind".}
  # SOMAXCONN

proc closeSocket*(s: SocketHandle): cint {.libWs2_32, importc: "closesocket".}

proc connect*(s: SocketHandle, name: ptr SockAddr, 
              namelen: cint): cint {.libWs2_32, importc: "connect".}
  ## The client connects to an address.

proc recv*(s: SocketHandle, buf: cstring, len, flags: cint): cint {.libWs2_32, importc: "recv".}

proc recvfrom*(s: SocketHandle, buf: cstring, len, flags: cint,
               fromm: ptr SockAddr, fromlen: var cint): cint {.libWs2_32, importc: "recvfrom".}

# proc select*(nfds: cint, readfds, writefds, exceptfds: ptr TFdSet,
#              timeout: ptr Timeval): cint

proc send*(s: SocketHandle, buf: cstring, 
           len, flags: cint): cint {.libWs2_32, importc: "send".}

proc sendto*(s: SocketHandle, buf: pointer, len, flags: cint,
             to: ptr SockAddr, tolen: cint): cint {.libWs2_32, importc: "sendto".}

proc shutdown*(s: SocketHandle, how: cint): cint {.libWs2_32, importc: "shutdown".}

proc ioctlsocket*(s: SocketHandle, cmd: clong, 
                  argp: var uulong): cint {.libWs2_32, importc: "ioctlsocket".}

proc getsockname*(s: SocketHandle, name: ptr SockAddr,
                  namelen: var cint): cint {.libWs2_32, importc: "getsockname".}

proc getpeername*(s: SocketHandle, name: ptr SockAddr,
                  namelen: var cint): cint {.libWs2_32, importc: "getpeername".}

proc getsockopt*(s: SocketHandle, level, optname: cint, optval: cstring,
                 optlen: var cint): cint {.libWs2_32, importc: "getsockopt".}

proc setsockopt*(s: SocketHandle, level, optname: cint, optval: cstring,
                 optlen: cint): cint {.libWs2_32, importc: "setsockopt".}

proc htonl*(hostlong: uulong): uulong {.libWs2_32, importc: "htonl".} =
  ## Converts a uulong from host to TCP/IP network byte order (which is big-endian).
  runnableExamples:
    doAssert htonl(0x1) == 16777216

proc htons*(hostshort: uushort): uushort {.libWs2_32, importc: "htons".} =
  ## Converts a uushort from host to TCP/IP network byte order (which is big-endian).
  runnableExamples:
    doAssert htons(0x1) == 256

proc inet_addr*(cp: cstring): culong {.libWs2_32, importc: "inet_addr".} =
  ## Converts an IPv4 address from dotted-quad string to 32-bit packed binary format.
  ## 
  ## Notes:
  ##       Pays attenetion to byte order (which is the same as host).
  runnableExamples:
    # Only in Intel
    doAssert inet_addr("127.0.0.1") == 16777343
    doAssert inet_addr("1.0.0.127") == 2130706433

proc inet_ntoa*(inAddr: InAddr): cstring {.libWs2_32, importc: "inet_ntoa".}

proc listen*(s: SocketHandle, backlog: cint): cint {.libWs2_32, importc: "listen".}

proc WSAConnect*(
  s: SocketHandle,
  name: ptr SockAddr,
  namelen: cint,
  lpCallerData: LPWSABUF, # LPWSABUF
  lpCalleeData: LPWSABUF, #LPWSABUF
  lpSQOS: LPQOS, # LPQOS
  lpGQOS: LPQOS  # LPQOS
): cint {.libWs2_32, importc: "WSAConnect".}

proc WSAIoctl*(
  s: SocketHandle, 
  dwIoControlCode: DWORD, lpvInBuffer: LPVOID,
  cbInBuffer: DWORD, lpvOutBuffer: LPVOID, cbOutBuffer: DWORD,
  lpcbBytesReturned: var DWORD, # LPDWORD
  lpOverlapped: LPOVERLAPPED, # LPOVERLAPPED
  lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE
): cint {.libWs2_32, importc: "WSAIoctl".}

proc WSASend*(
  s: SocketHandle,
  lpBuffers: LPWSABUF, # LPWSABUF
  dwBufferCount: DWORD,
  lpNumberOfBytesSent: var DWORD, # LPDWORD
  dwFlags: DWORD, 
  lpOverlapped: LPWSAOVERLAPPED, # LPWSAOVERLAPPED
  lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE
): cint {.libWs2_32, importc: "WSASend".}

proc WSARecv*(
  s: SocketHandle,
  lpBuffers: LPWSABUF, # LPWSABUF
  dwBufferCount: DWORD,
  lpNumberOfBytesRecvd: var DWORD, # LPDWORD
  lpFlags: var DWORD, # LPDWORD
  lpOverlapped: LPWSAOVERLAPPED, # LPWSAOVERLAPPED
  lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE
): cint {.libWs2_32, importc: "WSARecv".}

proc WSACleanup*(): cint {.libWs2_32, importc: "WSACleanup".}

proc WSAGetLastError*(): cint {.libWs2_32, importc: "WSAGetLastError".}

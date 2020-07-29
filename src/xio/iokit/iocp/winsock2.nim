import wsadata, guiddef, winnt, types
import base / [ntdef, sockettypes, ws2types, minwindef, qos, bsdtypes]


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



proc shutdown*(s: SocketHandle, how: cint): cint {.libWs2_32, importc: "shutdown".}

proc WSAStartup*(wVersionRequested: Word, 
                 lpWSAData: LPWSADATA): cint {.libWs2_32, importc: "WSAStartup".}

proc WSASocket*(
  af: cint,
  theType: cint,
  protocol: cint,
  lpProtocolInfo: var WSAPROTOCOL_INFOW,
  g: GROUP,
  dwFlags: DWORD
): SocketHandle {.libWs2_32, importc: "WSASocketW".}

proc accept*(s: SocketHandle, a: var SockAddr, 
             addrlen: var cint): SocketHandle {.libWs2_32, importc: "accept".}

proc bindAddr*(s: SocketHandle, name: var SockAddr, 
               namelen: cint): cint {.libWs2_32, importc: "bind".}

proc closeSocket*(s: SocketHandle): cint {.libWs2_32, importc: "closesocket".}

proc connect*(s: SocketHandle, name: var SockAddr, 
              namelen: cint): cint {.libWs2_32, importc: "connect".}

proc ioctlsocket*(s: SocketHandle, cmd: clong, 
                  argp: var uulong): cint {.libWs2_32, importc: "ioctlsocket".}

proc getsockname*(s: SocketHandle, name: var SockAddr,
                  namelen: var cint): cint {.libWs2_32, importc: "getsockname".}

proc getpeername*(s: SocketHandle, name: var SockAddr,
                  namelen: var cint): cint {.libWs2_32, importc: "getpeername".}

proc getsockopt*(s: SocketHandle, level, optname: cint, optval: cstring,
                 optlen: var cint): cint {.libWs2_32, importc: "getsockopt".}

proc setsockopt*(s: SocketHandle, level, optname: cint, optval: cstring,
                 optlen: cint): cint {.libWs2_32, importc: "getsockopt".}

proc listen*(s: SocketHandle, backlog: cint): cint {.libWs2_32, importc: "listen".}

proc WSAConnect*(
  s: SocketHandle,
  name: var SockAddr,
  namelen: cint,
  lpCallerData: LPWSABUF,
  lpCalleeData: LPWSABUF,
  lpSQOS: LPQOS, 
  lpGQOS: LPQOS): cint {.libWs2_32, importc: "WSAConnect".}

proc WSAIoctl*(
  s: SocketHandle, 
  dwIoControlCode: DWORD, lpvInBuffer: LPVOID,
  cbInBuffer: DWORD, lpvOutBuffer: LPVOID, cbOutBuffer: DWORD,
  lpcbBytesReturned: LPDWORD, lpOverlapped: LPOVERLAPPED,
  lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE
): cint {.libWs2_32, importc: "WSAIoctl".}

proc WSASend*(
  s: SocketHandle,
  lpBuffers: LPWSABUF,
  dwBufferCount: DWORD,
  lpNumberOfBytesSent: LPDWORD,
  dwFlags: DWORD, 
  lpOverlapped: LPWSAOVERLAPPED,
  lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE
): cint {.libWs2_32, importc: "WSASend".}

proc WSARecv*(
  s: SocketHandle,
  lpBuffers: LPWSABUF,
  dwBufferCount: DWORD,
  lpNumberOfBytesRecvd: LPDWORD,
  lpFlags: LPDWORD,
  lpOverlapped: LPWSAOVERLAPPED,
  lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE
): cint {.libWs2_32, importc: "WSARecv".}

proc WSACleanup*(): cint {.libWs2_32, importc: "WSACleanup".}

proc WSAGetLastError*(): cint {.libWs2_32, importc: "WSAGetLastError".}

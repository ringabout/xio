import types, wsadata, guiddef, winnt


{.pragma: libWs2_32, stdcall, dynlib: "Ws2_32.dll".}


const
  MAX_PROTOCOL_CHAIN = 7
  WSAPROTOCOL_LEN = 255

type
  SocketHandle* = distinct int

  GROUP = uint32

  WSAPROTOCOLCHAIN* = object
    chainLen*: int32
    chainEntries*: array[MAX_PROTOCOL_CHAIN, DWORD]
  
  LPWSAPROTOCOLCHAIN* = ptr WSAPROTOCOLCHAIN

  WSAPROTOCOL_INFOW* = object
    dwServiceFlags1*: DWORD
    dwServiceFlags2*: DWORD
    dwServiceFlags3*: DWORD
    dwServiceFlags4*: DWORD
    dwProviderFlags*: DWORD
    providerId*: GUid
    dwCatalogEntryId*: DWORD
    protocolChain*: WSAPROTOCOLCHAIN
    iVersion*: int32
    iAddressFamily*: int32
    iMaxSockAddr*: int32
    iMinSockAddr*: int32
    iSocketType*: int32
    iProtocol*: int32
    iProtocolMaxOffset*: int32
    iNetworkByteOrder*: int32
    iSecurityScheme*: int32
    dwMessageSize*: DWORD
    dwProviderReserved*: DWORD
    szProtocol*: array[WSAPROTOCOL_LEN + 1, WChar]
  
  LPWSAPROTOCOL_INFOW* = ptr WSAPROTOCOL_INFOW


const
  INVALID_HANDLE_VALUE* = Handle(-1)
  WSA_IO_PENDING* = 997'i32
  INFINITE* = -1'i32
  SOCKET_ERROR* = -1'i32


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

proc WSAIoctl*(
  s: SocketHandle, 
  dwIoControlCode: DWORD, lpvInBuffer: LPVOID,
  cbInBuffer: DWORD, lpvOutBuffer: LPVOID, cbOutBuffer: DWORD,
  lpcbBytesReturned: LPDWORD, lpOverlapped: LPOVERLAPPED,
  lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE
): cint {.libWs2_32, importc: "WSAIoctl".}

proc WSARecv*(
  s: SocketHandle,
  lpBuffers: LPWSABUF,
  dwBufferCount: DWORD,
  lpNumberOfBytesRecvd: LPDWORD,
  lpFlags: LPDWORD,
  lpOverlapped: LPWSAOVERLAPPED,
  lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE
): cint {.libWs2_32, importc: "WSARecv".}

proc WSAGetLastError*(): cint {.libWs2_32, importc: "WSAGetLastError".}

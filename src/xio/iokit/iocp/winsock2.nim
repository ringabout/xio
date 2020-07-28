import types, wsadata, guiddef, winnt


{.pragma: libWs2_32, stdcall, dynlib: "Ws2_32.dll".}


const
  MAX_PROTOCOL_CHAIN = 7
  WSAPROTOCOL_LEN = 255

type
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


proc WSAStartup*(wVersionRequested: Word, lpWSAData: LPWSADATA): cint {.libWs2_32, importc: "WSAStartup".}

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

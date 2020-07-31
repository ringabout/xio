import winnt, ws2def


{.pragma: libWs2_32, stdcall, dynlib: "Ws2_32.dll".}


proc getAddrInfo*(
  pNodeName: PCSTR,
  pServiceName: PCSTR,
  pHints: ptr AddrInfoA,
  ppResult: var PAddrInfoA
): cint {.libWs2_32, importc: "getaddrinfo"}

proc getAddrInfo*(
  pNodeName: PCWSTR,
  pServiceName: PCWSTR,
  pHints: ptr AddrInfoW,
  ppResult: var PAddrInfoW
): cint {.libWs2_32, importc: "GetaddrinfoW"}

proc freeAddrInfo*(pAddrInfo: PADDRINFOA) {.libWs2_32, importc: "freeaddrinfo"}

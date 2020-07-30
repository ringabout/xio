import winnt, ws2def, ws2types

{.pragma: libWs2_32, stdcall, dynlib: "Ws2_32.dll".}


proc getAddrInfo*(
  pNodeName: PCSTR,
  pServiceName: PCSTR,
  pHints: var SockAddr,
  ppResult: var PAddrInfoA
): cint {.libWs2_32, importc: "getaddrinfo"}

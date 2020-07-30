import crt/rt
import ws2types, winnt


type
  AddrInfoA* = object
    aiFlags*: cint
    aiFamily*: cint
    aiSocktype*: cint
    aiProtocol*: cint
    aiAddrlen*: size_t
    aiCanonname*: cstring
    aiAddr*: ptr SockAddr
    aiNext*: ptr AddrInfoA

  PAddrInfoA* = ptr AddrInfoA

  AddrInfoW* = object
    aiFlags*: cint
    aiFamily*: cint
    aiSocktype*: cint
    aiProtocol*: cint
    aiAddrlen*: size_t
    aiCanonname*: PWSTR,
    aiAddr*: ptr SockAddr
    aiNext*: ptr AddrInfoA

  PAddrInfoW* = ptr AddrInfoW

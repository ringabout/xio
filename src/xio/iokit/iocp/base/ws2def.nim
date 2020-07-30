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
    aiCanonname*: PWSTR
    aiAddr*: ptr SockAddr
    aiNext*: ptr AddrInfoA

  PAddrInfoW* = ptr AddrInfoW


const
  AI_CANONNAME* = 0x00000002
  AI_NUMERICHOST* = 0x00000004
  AI_NUMERICSERV* = 0x00000008
  AI_DNS_ONLY* = 0x00000010
  AI_ALL* = 0x00000100
  AI_ADDRCONFIG* = 0x00000400
  AI_V4MAPPED* = 0x00000800
  AI_NON_AUTHORITATIVE* = 0x00004000
  AI_SECURE* = 0x00008000
  AI_RETURN_PREFERRED_NAMES* = 0x00010000
  AI_FQDN* = 0x00020000
  AI_FILESERVER* = 0x00040000
  AI_DISABLE_IDN_ENCODING* = 0x00080000
  AI_EXTENDED* = 0x80000000
  AI_RESOLUTION_HANDLE* = 0x40000000

import base / minwindef


const
  WSADESCRIPTION_LEN = 256
  WSASYS_STATUS_LEN = 128


# _wsadata.h
type
  WSADATA* = object
    wVersion*: WORD
    wHighVersion*: WORD

    iMaxSockets*: cushort
    iMaxUdpDg*: cushort
    lpVendorInfo*: cstring
    szDescription*: array[WSADESCRIPTION_LEN+1, cchar]
    szSystemStatus*: array[WSASYS_STATUS_LEN+1, cchar]

  LPWSADATA* = ptr WSADATA

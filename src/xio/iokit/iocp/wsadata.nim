import types


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
    szDescription*: array[WSADESCRIPTION_LEN+1, char]
    szSystemStatus*: array[WSASYS_STATUS_LEN+1, char]

  LPWSADATA* = ptr WSADATA

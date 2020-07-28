import bsdtypes


type 
  InAddr* {.importc: "IN_ADDR", header: "inaddr.h".} = object
    s_addr*: uulong

  PinAddr* = ptr InAddr
  LpinAddr* = ptr InAddr

import bsdtypes, inaddr

type
  SockAddr* = object
    saFamily*: uushort
    saData*: array[14, cchar]

  SockaddrIn* = object
    sinFamily*: cshort
    sinPort*: uushort
    sinAddr*: InAddr
    sinZero*: array[8, cchar]


proc newSockAddr*(saFamily: uushort, saData: array[14, char]): SockAddr =
  SockAddr(saFamily: saFamily, saData: saData)

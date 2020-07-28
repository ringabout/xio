import bsdtypes, inaddr

type
  Sockaddr* = object
    saFamily*: uushort
    saData*: array[14, cchar]

  SockaddrIn* = object
    sinFamily*: cshort
    sinPort*: cshort
    sinAddr*: InAddr
    sinZero*: array[8, cchar]

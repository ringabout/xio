import ../src/xio/windows/[winsock2, wsadata]

var wsa: WSAData

if WSAStartup(0x0101, addr wsa) != 0: 
  doAssert false

block:
  let x = getprotobyname("tcp")
  if x != nil:
    doAssert x.p_proto == 6

block:
  let x = getprotobyname("udp")
  if x != nil:
    doAssert x.p_proto == 17, $x.p_proto

block:
  let x = getprotobyname("icmp")
  if x != nil:
    doAssert x.p_proto == 1, $x.p_proto

doAssert WSAGetLastError() == 0
discard WSACleanup()

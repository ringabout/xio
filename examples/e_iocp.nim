import ../src/xio/iokit/iocp
import ../src/xio/iokit/iocp/winsock2
import ../src/xio/iokit/iocp/base/ws2types
import ../src/xio/iokit/iocp/base/bsdtypes



block:
  echo inet_addr("127.0.0.1")
  echo inet_addr("1.0.0.127")
  echo htons(0x1)
  echo htons(256)
  echo htonl(1)

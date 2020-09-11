import basetsd

type
  SocketHandle* = UINT_PTR


const
  INVALID_SOCKET* = cast[SocketHandle](-1)
  SOCKET_ERROR* = -1'i32

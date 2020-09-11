import ntdef, minwindef, basetsd


type
  OVERLAPPED_offset* = object
    offset*: DWORD
    offsetHigh*: DWORD

  OVERLAPPED_union* {.union.} = object
    offset*: OVERLAPPED_offset
    p*: PVOID

  OVERLAPPED* = object
    internal*: ULONG_PTR
    internalHigh*: ULONG_PTR
    union*: OVERLAPPED_union
    hevent*: Handle

  LPOVERLAPPED* = ptr OVERLAPPED

  LPOVERLAPPED_COMPLETION_ROUTINE* = proc (dwErrorCode: DWORD, dwNumberOfBytesTransfered: DWORD,
                                             lpOverlapped: LPOVERLAPPED)

  OVERLAPPED_ENTRY* = object
    lpCompletionKey*: ULONG_PTR
    lpOverlapped*: LPOVERLAPPED
    internal*: ULONG_PTR
    dwNumberOfBytesTransferred*: DWORD

  LPOVERLAPPED_ENTRY* = ptr OVERLAPPED_ENTRY

  WSAOVERLAPPED* = object
    internal*: ULONG_PTR
    internalHigh*: ULONG_PTR
    offset*: DWORD
    offsetHigh*: DWORD
    hevent*: Handle

  LPWSAOVERLAPPED* = ptr WSAOVERLAPPED

  LPWSAOVERLAPPED_COMPLETION_ROUTINE* = proc (dwError: DWORD, cbTransferred: DWORD, 
                                              lpOverlapped: LPWSAOVERLAPPED, dwFlags: DWORD)

  WSABUF* = object
    len*: ULONG
    buf*: cstring

  LPWSABUF* = ptr WSABUF

  SECURITY_ATTRIBUTES* = object
    nLength*: DWORD
    lpSecurityDescriptor*: LPVOID
    bInheritHandle*: WINBOOL
  
  PSECURITY_ATTRIBUTES* = ptr SECURITY_ATTRIBUTES
  LPSECURITY_ATTRIBUTES* = ptr SECURITY_ATTRIBUTES

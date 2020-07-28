type
  BYTE* = cuchar
  WORD* = cushort
  DWORD* = culong
  FLOAT* = cfloat
  PFLOAT* = ptr FLOAT
  PBYTE* = ptr BYTE
  LPBYTE* = ptr BYTE
  PINT* = ptr cint
  LPINT* = ptr cint
  PWORD* = ptr WORD
  LPWORD* = ptr WORD
  LPLONG* = ptr DWORD # __LONG32
  PDWORD* = ptr DWORD
  LPDWORD* = ptr DWORD
  ULONG* = culong
  ULONG_PTR* = culong
  DWORD_PTR* = ULONG_PTR
  PDWORD_PTR* = ptr ULONG_PTR
  PULONG* = ptr ULONG
  PULONG_PTR* = ptr ULONG_PTR

  PVOID* = pointer
  LPVOID* = pointer

  Handle* = pointer
  HDC* = Handle
  HGLRC* = Handle

  WINBOOL* = int32 ## if WINBOOL != 0, it succeeds which is different from posix.

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

{.pragma: libKernel32, stdcall, dynlib: "Kernel32.dll".}


type
  Handle* = int
  DWORD* = int32
  PDWORD* = ptr DWORD
  LPDWORD* = ptr DWORD
  LPINT* = ptr int32
  ULONG_PTR* = uint
  PULONG_PTR* = ptr uint
  HDC* = Handle
  HGLRC* = Handle
  PVOID* = pointer

  WINBOOL = int32 ## if WINBOOL != 0, it succeeds which is different from posix.

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


const
  INVALID_HANDLE_VALUE = -1

proc createIoCompletionPort*(FileHandle: Handle, ExistingCompletionPort: Handle,
  CompletionKey: ULONG_PTR, NumberOfConcurrentThreads: DWORD
): Handle {.libKernel32, importc: "CreateIoCompletionPort"}
  ## Creates an input/output (I/O) completion port and associates it with a specified file handle.


proc getQueuedCompletionStatus*(CompletionPort: Handle,
  lpNumberOfBytesTransferred: LPDWORD,
  lpCompletionKey: PULONG_PTR,
  lpOverlapped: LPOVERLAPPED,
  dwMilliseconds: DWORD
): WinBool {.libKernel32, importc: "GetQueuedCompletionStatus"}


when isMainModule:
  echo createIoCompletionPort(INVALID_HANDLE_VALUE, 0, 0, 1)

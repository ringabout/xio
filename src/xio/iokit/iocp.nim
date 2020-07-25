{.pragma: libKernel32, stdcall, dynlib: "Kernel32.dll".}


type
  Handle* = int
  DWORD* = int32
  PDWORD* = ptr DWORD
  LPINT* = ptr int32
  ULONG_PTR* = uint
  PULONG_PTR* = ptr uint
  HDC* = Handle
  HGLRC* = Handle


const
  INVALID_HANDLE_VALUE = -1

proc createIoCompletionPort*(FileHandle: Handle, ExistingCompletionPort: Handle,
  CompletionKey: ULONG_PTR, NumberOfConcurrentThreads: DWORD
): Handle {.libKernel32, importc: "CreateIoCompletionPort"}
  ## Creates an input/output (I/O) completion port and associates it with a specified file handle



when isMainModule:
  echo createIoCompletionPort(INVALID_HANDLE_VALUE, 0, 0, 1)

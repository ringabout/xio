{.pragma: libKernel32, stdcall, dynlib: "Kernel32.dll".}


import iocp / [types, winsock2]

export types, winsock2


proc createIoCompletionPort*(
  fileHandle: Handle, 
  existingCompletionPort: Handle,
  completionKey: ULONG_PTR, 
  numberOfConcurrentThreads: DWORD
): Handle {.libKernel32, importc: "CreateIoCompletionPort"}
  ## Creates an input/output (I/O) completion port and associates it with a specified file handle.
  ## Or creates an input/output (I/O) completion port which is not yet associated with file handles.
  ## Params: 
  ##         - ``FileHandle``: An open file handle or INVALID_HANDLE_VALUE.
  ##         - ``ExistingCompletionPort``: A handle to an existing I/O completion port or NULL.
  ##         - ``CompletionKey``: User-defined completion key.
  ##         - ``NumberOfConcurrentThreads``
  ## Returns:
  ##         - ``Handle``
  ## .. code-block:: Nim
  ##   # creates an input/output (I/O) completion port
  ##   discard createIoCompletionPort(INVALID_HANDLE_VALUE, 0, 0, 1)

proc getQueuedCompletionStatus*(
  completionPort: Handle,
  lpNumberOfBytesTransferred: var DWORD,
  lpCompletionKey: var ULONG_PTR,
  lpOverlapped: var OVERLAPPED,
  dwMilliseconds: DWORD
): WINBOOL {.libKernel32, importc: "GetQueuedCompletionStatus"}
  ## Gets one completion port entry.

proc getQueuedCompletionStatusEx*(
  completionPort: Handle,
  lpCompletionPortEntries: var OVERLAPPED_ENTRY,
  ulCount: ULONG,
  ulNumEntriesRemoved: var ULONG,
  dwMilliseconds: DWORD,
  fAlertable: WINBOOL
): WINBOOL {.libKernel32, importc: "GetQueuedCompletionStatusEx".}
  ## Gets multiple completion port entries simultaneously.

proc closeHandle*(hObject: Handle): WINBOOL {.libKernel32,
    importc: "CloseHandle".}

proc getLastError*(): DWORD {.libKernel32, importc: "GetLastError".}

proc setLastError*(dwErrCode: DWORD) {.libKernel32, importc: "SetLastError".}


when isMainModule:
  echo cast[int](createIoCompletionPort(INVALID_HANDLE_VALUE, cast[Handle](0), 0, 1))

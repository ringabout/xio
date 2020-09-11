import ntdef, minwindef, minwinbase, basetsd


{.pragma: libKernel32, stdcall, dynlib: "Kernel32.dll".}


proc createIoCompletionPort*(
  FileHandle: Handle,
  ExistingCompletionPort: Handle,
  CompletionKey: ULONG_PTR,
  NumberOfConcurrentThreads: DWORD
): Handle {.libKernel32, importc: "CreateIoCompletionPort".}

proc getQueuedCompletionStatus*(
  CompletionPort: Handle,
  lpNumberOfBytesTransferred: LPDWORD,
  lpCompletionKey: PULONG_PTR,
  lpOverlapped: ptr LPOVERLAPPED,
  dwMilliseconds: DWORD
): WINBOOL {.libKernel32, importc: "GetQueuedCompletionStatus".}

proc getQueuedCompletionStatusEx*(
  CompletionPort: Handle,
  lpCompletionPortEntries: LPOVERLAPPED_ENTRY,
  ulCount: ULONG, ulNumEntriesRemoved: PULONG,
  dwMilliseconds: DWORD, fAlertable: WINBOOL
): WINBOOL {.libKernel32, importc: "GetQueuedCompletionStatusEx".}


proc postQueuedCompletionStatus*(
  CompletionPort: Handle,
  dwNumberOfBytesTransferred: DWORD,
  dwCompletionKey: ULONG_PTR,
  lpOverlapped: LPOVERLAPPED
): WINBOOL {.libKernel32, importc: "PostQueuedCompletionStatus".}

proc deviceIoControl*(
  hDevice: Handle, dwIoControlCode: DWORD, lpInBuffer: LPVOID,
  nInBufferSize: DWORD, lpOutBuffer: LPVOID,
  nOutBufferSize: DWORD, lpBytesReturned: LPDWORD,
  lpOverlapped: LPOVERLAPPED
): WINBOOL {.libKernel32, importc: "DeviceIoControl".}

proc getOverlappedResult*(
  hFile: Handle, lpOverlapped: LPOVERLAPPED,
  lpNumberOfBytesTransferred: var DWORD, bWait: WINBOOL
): WINBOOL {.libKernel32, importc: "GetOverlappedResult".}

proc cancelIoEx*(hFile: Handle, 
  lpOverlapped: LPOVERLAPPED
): WINBOOL {.libKernel32, importc: "CancelIoEx".}

proc cancelIo*(hFile: Handle): WINBOOL {.libKernel32, importc: "CancelIo".}

proc getOverlappedResultEx*(
  hFile: Handle, lpOverlapped: LPOVERLAPPED,
  lpNumberOfBytesTransferred: LPDWORD,
  dwMilliseconds: DWORD, bAlertable: WINBOOL
): WINBOOL {.libKernel32, importc: "GetOverlappedResultEx".}

proc cancelSynchronousIo*(hThread: Handle): WINBOOL {.libKernel32, importc: "CancelSynchronousIo".}

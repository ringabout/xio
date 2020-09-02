



HANDLE
CreateIoCompletionPort(
     HANDLE FileHandle,
     HANDLE ExistingCompletionPort,
     ULONG_PTR CompletionKey,
     DWORD NumberOfConcurrentThreads
    );



WINBOOL
GetQueuedCompletionStatus(
     HANDLE CompletionPort,
     LPDWORD lpNumberOfBytesTransferred,
     PULONG_PTR lpCompletionKey,
     LPOVERLAPPED* lpOverlapped,
     DWORD dwMilliseconds
    );



WINBOOL
GetQueuedCompletionStatusEx(
     HANDLE CompletionPort,
     LPOVERLAPPED_ENTRY lpCompletionPortEntries,
     ULONG ulCount,
     PULONG ulNumEntriesRemoved,
     DWORD dwMilliseconds,
     WINBOOL fAlertable
    );




WINBOOL
PostQueuedCompletionStatus(
     HANDLE CompletionPort,
     DWORD dwNumberOfBytesTransferred,
     ULONG_PTR dwCompletionKey,
     LPOVERLAPPED lpOverlapped
    );




WINBOOL
DeviceIoControl(
     HANDLE hDevice,
     DWORD dwIoControlCode,
    LPVOID lpInBuffer,
     DWORD nInBufferSize,
    LPVOID lpOutBuffer,
     DWORD nOutBufferSize,
     LPDWORD lpBytesReturned,
     LPOVERLAPPED lpOverlapped
    );



WINBOOL
GetOverlappedResult(
     HANDLE hFile,
     LPOVERLAPPED lpOverlapped,
     LPDWORD lpNumberOfBytesTransferred,
     WINBOOL bWait
    );




WINBOOL
CancelIoEx(
     HANDLE hFile,
     LPOVERLAPPED lpOverlapped
    );



WINBOOL
CancelIo(
     HANDLE hFile
    );



WINBOOL
GetOverlappedResultEx(
     HANDLE hFile,
     LPOVERLAPPED lpOverlapped,
     LPDWORD lpNumberOfBytesTransferred,
     DWORD dwMilliseconds,
     WINBOOL bAlertable
    );



WINBOOL
CancelSynchronousIo(
     HANDLE hThread
    );


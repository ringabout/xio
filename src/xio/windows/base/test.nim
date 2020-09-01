proc CloseHandle*(hObject: HANDLE): BOOL
proc DuplicateHandle*(hSourceProcessHandle: HANDLE; hSourceHandle: HANDLE;
                     hTargetProcessHandle: HANDLE; lpTargetHandle: LPHANDLE;
                     dwDesiredAccess: DWORD; bInheritHandle: BOOL; dwOptions: DWORD): BOOL
proc CompareObjectHandles*(hFirstObjectHandle: HANDLE; hSecondObjectHandle: HANDLE): BOOL
proc GetHandleInformation*(hObject: HANDLE; lpdwFlags: LPDWORD): BOOL
proc SetHandleInformation*(hObject: HANDLE; dwMask: DWORD; dwFlags: DWORD): BOOL
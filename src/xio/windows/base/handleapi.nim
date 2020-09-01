import ntdef, minwindef


{.pragma: libKernel32, stdcall, dynlib: "Kernel32.dll".}

const
  INVALID_HANDLE_VALUE* = cast[Handle](-1)

proc closeHandle*(hObject: HANDLE): WINBOOL {.libKernel32, importc: "CloseHandle"}

proc duplicateHandle*(
  hSourceProcessHandle: HANDLE,
  hSourceHandle: HANDLE,
  hTargetProcessHandle: HANDLE,
  lpTargetHandle: LPHANDLE,
  dwDesiredAccess: DWORD,
  bInheritHandle: WINBOOL,
   dwOptions: DWORD
): WINBOOL {.libKernel32, importc: "DuplicateHandle"}

proc compareObjectHandles*(
  hFirstObjectHandle: HANDLE; 
  hSecondObjectHandle: HANDLE
): WINBOOL {.libKernel32, importc: "CompareObjectHandles"}

proc getHandleInformation*(
  hObject: HANDLE; lpdwFlags: LPDWORD
): WINBOOL {.libKernel32, importc: "GetHandleInformation"}

proc setHandleInformation*(
  hObject: HANDLE; dwMask: DWORD; dwFlags: DWORD
): WINBOOL {.libKernel32, importc: "SetHandleInformation"}

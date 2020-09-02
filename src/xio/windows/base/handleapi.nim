import ntdef, minwindef


{.pragma: libKernel32, stdcall, dynlib: "Kernel32.dll".}

const
  INVALID_HANDLE_VALUE* = cast[Handle](-1)

proc closeHandle*(hObject: Handle): WINBOOL {.libKernel32, importc: "CloseHandle"}

proc duplicateHandle*(
  hSourceProcessHandle: Handle,
  hSourceHandle: Handle,
  hTargetProcessHandle: Handle,
  lpTargetHandle: LPHANDLE,
  dwDesiredAccess: DWORD,
  bInheritHandle: WINBOOL,
   dwOptions: DWORD
): WINBOOL {.libKernel32, importc: "DuplicateHandle"}

proc compareObjectHandles*(
  hFirstObjectHandle: Handle; 
  hSecondObjectHandle: Handle
): WINBOOL {.libKernel32, importc: "CompareObjectHandles"}

proc getHandleInformation*(
  hObject: Handle; lpdwFlags: LPDWORD
): WINBOOL {.libKernel32, importc: "GetHandleInformation"}

proc setHandleInformation*(
  hObject: Handle; dwMask: DWORD; dwFlags: DWORD
): WINBOOL {.libKernel32, importc: "SetHandleInformation"}

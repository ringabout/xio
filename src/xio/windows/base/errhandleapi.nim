import minwindef

{.pragma: libKernel32, stdcall, dynlib: "Kernel32.dll".}


proc getLastError*(): DWORD {.libKernel32, importc: "GetLastError".}

proc setLastError*(dwErrCode: DWORD) {.libKernel32, importc: "SetLastError".}

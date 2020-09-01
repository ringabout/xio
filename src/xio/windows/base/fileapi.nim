import ntdef, winnt, minwindef, minwinbase

export ntdef, winnt, minwindef, minwinbase


{.pragma: libKernel32, stdcall, dynlib: "Kernel32.dll".}


const
  CREATE_NEW* = 1
  CREATE_ALWAYS* = 2
  OPEN_EXISTING* = 3
  OPEN_ALWAYS* = 4
  TRUNCATE_EXISTING* = 5


proc createFileW*(
  lpFileName: WCHAR,
  dwDesiredAccess: DWORD,
  dwShareMode: DWORD,
  lpSecurityAttributes: LPSECURITY_ATTRIBUTES,
  dwCreationDisposition: DWORD,
  dwFlagsAndAttributes: DWORD,
  hTemplateFile: Handle
): Handle {.libKernel32, importc: "CreateFileW".}

proc createFileA*(
  lpFileName: cstring,
  dwDesiredAccess: DWORD,
  dwShareMode: DWORD,
  lpSecurityAttributes: LPSECURITY_ATTRIBUTES,
  dwCreationDisposition: DWORD,
  dwFlagsAndAttributes: DWORD,
  hTemplateFile: Handle
): Handle {.libKernel32, importc: "CreateFileA".}

proc getFileAttributesA*(
  lpFileName: LPCSTR
): DWORD {.libKernel32, importc: "GetFileAttributesA".} 

proc getFileAttributesW*(
  lpFileName: LPCWSTR
): DWORD {.libKernel32, importc: "GetFileAttributesW".} 

import ntdef, winnt, minwindef, minwinbase, winbase


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


var name = newWideCString("test.txt")
# echo name


let h = createFileW(name, 0, FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
        OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS or 
        FILE_ATTRIBUTE_NORMAL or FILE_FLAG_OPEN_REPARSE_POINT, cast[Handle](0))

import os
echo osLastError()

echo readFile("test.txt")

# import winlean, os

# var reads: int32
# var s = newString(1000)
# echo winlean.readFile(cast[winlean.Handle](h), s.cstring, 1000, addr reads, cast[pointer](0))

# echo reads

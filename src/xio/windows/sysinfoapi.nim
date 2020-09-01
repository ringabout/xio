import base/[minwindef, ntdef, basetypes]


{.pragma: libKernel32, stdcall, dynlib: "Kernel32.dll".}


type
  SYSTEM_INFO_UNION1_STRUCT1* = object
    wProcessorArchitecture*: WORD
    wReserved*: WORD

  SYSTEM_INFO_UNION1* {.union, pure, final.} = object
    dwOemId*: DWORD
    s1*: SYSTEM_INFO_UNION1_STRUCT1

  SYSTEM_INFO* {.pure, final.} = object
    u1*: SYSTEM_INFO_UNION1
    dwPageSize*: DWORD
    lpMinimumApplicationAddress*: LPVOID
    lpMaximumApplicationAddress*: LPVOID
    dwActiveProcessorMask*: DWORD_PTR
    dwNumberOfProcessors*: DWORD
    dwProcessorType*: DWORD
    dwAllocationGranularity*: DWORD
    wProcessorLevel*: WORD
    wProcessorRevision*: WORD

  LPSYSTEM_INFO* = ptr SYSTEM_INFO


proc getSystemInfo*(lpSystemInfo: ptr SYSTEM_INFO) {.libKernel32, importc: "GetSystemInfo".}


when isMainModule:
  # Error: var info = SYSTEM_INFO()
  var info: SYSTEM_INFO
  getSystemInfo(addr info)
  echo info

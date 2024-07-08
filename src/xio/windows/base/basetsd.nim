type
  uchar* {.importc: "unsigned char", nodecl.} = uint8
  POINTER_64_INT* = uint
  INT8* = cschar
  PINT8* = ptr INT8
  INT16* = cshort
  PINT16* = ptr INT16
  INT32* = cint
  PINT32* = ptr INT32
  INT64* = int64
  PINT64* = ptr INT64
  UINT8* = uchar
  PUINT8* = ptr UINT8
  UINT16* = cushort
  PUINT16* = ptr UINT16
  UINT32* = cuint
  PUINT32* = ptr UINT32
  UINT64* = uint64
  PUINT64* = ptr UINT64
  LONG32* = cint
  PLONG32* = ptr LONG32
  ULONG32* = cuint
  PULONG32* = ptr ULONG32
  DWORD32* = cuint
  PDWORD32* = ptr DWORD32
  INT_PTR* = int
  PINT_PTR* = ptr INT_PTR
  UINT_PTR* = uint
  PUINT_PTR* = ptr UINT_PTR
  LONG_PTR* = int
  PLONG_PTR* = ptr LONG_PTR
  ULONG_PTR* = uint
  PULONG_PTR* = ptr ULONG_PTR
  SHANDLE_PTR* = int
  HANDLE_PTR* = uint


  SIZE_T* = ULONG_PTR
  PSIZE_T* = ptr SIZE_T
  SSIZE_T* = LONG_PTR
  PSSIZE_T* = ptr SSIZE_T
  DWORD_PTR* = ULONG_PTR
  PDWORD_PTR* = ptr DWORD_PTR
  LONG64* = int64
  PLONG64* = ptr LONG64
  ULONG64* = uint64
  PULONG64* = ptr ULONG64
  DWORD64* = uint64
  PDWORD64* = ptr DWORD64
  KAFFINITY* = ULONG_PTR
  PKAFFINITY* = ptr KAFFINITY

when sizeof(int) == 8:
  type
    UHALF_PTR* = cuint
    PUHALF_PTR* = ptr UHALF_PTR
    HALF_PTR* = cint
    PHALF_PTR* = ptr HALF_PTR
elif sizeof(int) == 4:
  type
    UHALF_PTR* = cushort
    PUHALF_PTR* = ptr UHALF_PTR
    HALF_PTR* = cshort
    PHALF_PTR* = ptr HALF_PTR

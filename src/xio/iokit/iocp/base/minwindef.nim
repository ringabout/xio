type
  BYTE* = cuchar
  WORD* = cushort
  DWORD* = culong
  FLOAT* = cfloat
  PFLOAT* = ptr FLOAT
  PBYTE* = ptr BYTE
  LPBYTE* = ptr BYTE
  PINT* = ptr cint
  LPINT* = ptr cint
  PWORD* = ptr WORD
  LPWORD* = ptr WORD
  LPLONG* = ptr DWORD # __LONG32
  PDWORD* = ptr DWORD
  LPDWORD* = ptr DWORD
  ULONG* = culong
  PULONG* = ptr ULONG

  USHORT* = cushort
  PUSHORT* = ptr USHORT
  UCHAR* = cuchar
  PUCHAR* = ptr UCHAR
  PSZ* = cstring

  PVOID* = pointer
  LPVOID* = pointer

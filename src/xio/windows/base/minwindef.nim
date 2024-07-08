import ntdef, basetsd

type
  BYTE* = uint8
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
  UCHAR* = char
  PUCHAR* = ptr UCHAR
  PSZ* = cstring

  WINBOOL* = int32 ## if WINBOOL != 0, it succeeds which is different from posix.

  LPHandle* = ptr Handle

  UINT* = cuint
  WPARAM* = UINT_PTR

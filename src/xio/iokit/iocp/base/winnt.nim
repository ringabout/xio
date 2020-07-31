type
  Utf16Char* = distinct int16
  WideCString* = ref UncheckedArray[Utf16Char]
  WideCStringObj* = WideCString
  wchar_t* = Utf16Char
  WCHAR* = wchar_t
  PWCHAR* = ptr WCHAR


  PVOID* = pointer
  PVOID64* = uint64
  VOID* = void
  CHAR* = cchar
  SHORT* = cshort
  LONG* = clong
  INT* = cint
  
  LPWCH* = ptr WCHAR
  PWCH* = ptr WCHAR
  LPCWCH* = ptr WCHAR
  PCWCH* = ptr WCHAR
  NWPSTR* = ptr WCHAR
  LPWSTR* = ptr WCHAR
  PWSTR* = ptr WCHAR
  PZPWSTR* = ptr PWSTR
  PCZPWSTR* = ptr PWSTR
  LPUWSTR* = ptr WCHAR
  PUWSTR* = ptr WCHAR
  LPCWSTR* = ptr WCHAR
  PCWSTR* = ptr WCHAR
  PZPCWSTR* = ptr PCWSTR
  PCZPCWSTR* = ptr PCWSTR
  LPCUWSTR* = ptr WCHAR 
  PCUWSTR* = ptr WCHAR 
  PZZWSTR* = ptr WCHAR
  PCZZWSTR* = ptr WCHAR
  PUZZWSTR* = ptr WCHAR 
  PCUZZWSTR* = ptr WCHAR 
  PNZWCH* = ptr WCHAR
  PCNZWCH* = ptr WCHAR
  PUNZWCH* = ptr WCHAR 
  PCUNZWCH* = ptr WCHAR 
  LPCWCHAR* = ptr WCHAR
  PCWCHAR* = ptr WCHAR
  LPCUWCHAR* = ptr WCHAR 
  PCUWCHAR* = ptr WCHAR 
  UCSCHAR* = culong

  PUCSCHAR* = ptr UCSCHAR
  PCUCSCHAR* = ptr UCSCHAR
  PUCSSTR* = ptr UCSCHAR
  PUUCSSTR* = ptr UCSCHAR 
  PCUCSSTR* = ptr UCSCHAR
  PCUUCSSTR* = ptr UCSCHAR 
  PUUCSCHAR* = ptr UCSCHAR 
  PCUUCSCHAR* = ptr UCSCHAR 
  PCHAR* = cstring
  LPCH* = cstring
  PCH* = cstring
  LPCCH* = cstring
  PCCH* = cstring
  NPSTR* = cstring
  LPSTR* = cstring
  PSTR* = cstring
  PZPSTR* = ptr PSTR
  PCZPSTR* = ptr PSTR
  LPCSTR* = cstring
  PCSTR* = cstring
  PZPCSTR* = ptr PCSTR
  PCZPCSTR* = ptr PCSTR
  PZZSTR* = cstring
  PCZZSTR* = cstring
  PNZCH* = cstring
  PCNZCH* = cstring


const 
  SYSTEM_CACHE_ALIGNMENT_SIZE* = 64.uint
  UCSCHAR_INVALID_CHARACTER* = cast[UCSCHAR](0xffffffff)
  MIN_UCSCHAR*: UCSCHAR = 0
  MAX_UCSCHAR*: UCSCHAR = 0x0010FFFF
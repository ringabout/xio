type
  Utf16Char* = distinct int16
  WideCString* = ref UncheckedArray[Utf16Char]
  WideCStringObj* = WideCString
  wchar_t* = Utf16Char
  WCHAR* = wchar_t

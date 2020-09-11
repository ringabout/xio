import minwindef, windef, winnt, basetsd


{.pragma: libComdlg32, stdcall, dynlib: "Comdlg32.dll".}


type
  LPOFNHOOKPROC = proc (x1: HWND, x2: UINT, x3: WPARAM, x4: LPARAM): UINT_PTR {.stdcall.}

  OPENFILENAMEA* {.bycopy.} = object
    lStructSize*: DWORD
    hwndOwner*: HWND
    hInstance*: HINSTANCE
    lpstrFilter*: LPCSTR
    lpstrCustomFilter*: LPSTR
    nMaxCustFilter*: DWORD
    nFilterIndex*: DWORD
    lpstrFile*: LPSTR
    nMaxFile*: DWORD
    lpstrFileTitle*: LPSTR
    nMaxFileTitle*: DWORD
    lpstrInitialDir*: LPCSTR
    lpstrTitle*: LPCSTR
    flags*: DWORD
    nFileOffset*: WORD
    nFileExtension*: WORD
    lpstrDefExt*: LPCSTR
    lCustData*: LPARAM
    lpfnHook*: LPOFNHOOKPROC
    lpTemplateName*: LPCSTR
    # lpEditInfo*: LPEDITMENU
    # lpstrPrompt*: LPCSTR
    pvReserved*: pointer
    dwReserved*: DWORD
    flagsEx*: DWORD

  LPOPENFILENAMEA* = ptr OPENFILENAMEA

proc getOpenFileNameA*(
  Arg1: LPOPENFILENAMEA
) {.libComdlg32, importc: "GetOpenFileNameA".}

# proc getOpenFileNameW*(
#   Arg1: LPOPENFILENAMEW
# ) {.libComdlg32, importc: "GetOpenFileNameA".}
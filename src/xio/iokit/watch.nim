import iocp/base/[fileapi, winbase, widestr2]


var name = newWideCString("iocp")
# echo name


let x = proc (dwErrorCode: DWORD, dwNumberOfBytesTransfered: DWORD, lpOverlapped: LPOVERLAPPED) =
  echo "Hello, World"

let h = createFileW(name, FILE_LIST_DIRECTORY, FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
        OPEN_EXISTING, FILE_FLAG_OVERLAPPED or FILE_FLAG_BACKUP_SEMANTICS, x)



var buffer = newString(1024)
var reads: DWORD
var over: OVERLAPPED


import os

while true:
  sleep(1000)
  echo readDirectoryChangesW(h, buffer.cstring, 
      1024, 0, FILE_NOTIFY_CHANGE_FILE_NAME or 
            FILE_NOTIFY_CHANGE_DIR_NAME or 
            FILE_NOTIFY_CHANGE_LAST_WRITE, reads, addr over, nil)

  var buf = cast[pointer](addr buffer[0])
  echo cast[cstring](buf).repr
  while true:
    let info = cast[PFILE_NOTIFY_INFORMATION](buf)

    echo info == nil
    echo (info.NextEntryOffset, info.Action, info.FileNameLength, info.FileName.repr)

    # var filename = newWideCString("".cstring, info.FileNameLength.int div 2)
    # for i in 0 ..< info.FileNameLength div 2:
    #   filename[i] = info.FileName[i]

    echo info.FileName

    buf = cast[pointer](cast[ByteAddress](buf) + info.NextEntryOffset.int)

    if info.NextEntryOffset == 0:
      break

  if reads != 0:
    break

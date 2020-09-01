import windows/base/[fileapi, handleapi, winbase, widestr2]
import timerwheel, times, os


type
  FileEventAction* {.pure.} = enum
    NonAction
    CreateFile, ModifyFile, RenameFile, RemoveFile
    CreateDir, RemoveDir

  FileEvent* = tuple
    name: string
    action: FileEventAction

  DirEventData* = object
    name*: string
    handle*: Handle
    exists*: bool
    lastModificationTime*: Time
    uniqueId*: uint64
    event*: FileEvent

proc clearEvent*(data: ptr DirEventData) =
  data.event = ("", FileEventAction.NonAction)

proc getFileId(name: string): uint =
  var x = newWideCString(name)
  result = uint getFileAttributesW(addr x)

proc getUniqueFileId*(name: string): uint64 =
  when defined(windows):
    let 
      tid = getCreationTime(name)
      id = getFileId(name)
    result = uint64(toWinTime(tid)) xor id
  elif defined(posix):
    var s: Stat
    if stat(name, s) == 0:
      result = uint64(s.st_dev or s.st_ino shl 32)

proc init(data: var DirEventData) =
  let name = newWideCString(data.name)
  data.exists = true
  data.handle = createFileW(name, FILE_LIST_DIRECTORY, FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                              OPEN_EXISTING, FILE_FLAG_OVERLAPPED or FILE_FLAG_BACKUP_SEMANTICS, nil)
  data.uniqueId = getUniqueFileId(data.name)
  data.lastModificationTime = getLastModificationTime(data.name)

proc init(data: ptr DirEventData) =
  let name = newWideCString(data.name)
  data.exists = true
  data.handle = createFileW(name, FILE_LIST_DIRECTORY, FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                              OPEN_EXISTING, FILE_FLAG_OVERLAPPED or FILE_FLAG_BACKUP_SEMANTICS, nil)
  data.uniqueId = getUniqueFileId(data.name)
  data.lastModificationTime = getLastModificationTime(data.name)

proc initDirEventData*(name: string): DirEventData =
  result.name = name

  if dirExists(name):
    init(result)


proc listenDir*(name: string) =
  discard


proc dircb*(args: pointer = nil) =
  if args != nil:
    var data = cast[ptr DirEventData](args)
    var buffer = newString(1024)
    var reads: DWORD
    var over: OVERLAPPED
    data.clearEvent()

    if data.exists:
      if dirExists(data.name):
        if data.handle == nil:
          let name = newWideCString(data.name)
          data.handle = createFileW(name, FILE_LIST_DIRECTORY, FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                              OPEN_EXISTING, FILE_FLAG_OVERLAPPED or FILE_FLAG_BACKUP_SEMANTICS, nil)
      

        discard readDirectoryChangesW(data.handle, buffer.cstring, 
            1024, 0, FILE_NOTIFY_CHANGE_FILE_NAME or 
            FILE_NOTIFY_CHANGE_DIR_NAME or 
            FILE_NOTIFY_CHANGE_LAST_WRITE, reads, addr over, nil)

        var buf = cast[pointer](buffer.cstring)
        while true:
          let info = cast[PFILE_NOTIFY_INFORMATION](buf)
          echo toString(info.FileName)
          buf = cast[pointer](cast[ByteAddress](buf) + info.NextEntryOffset.int)

          if info.NextEntryOffset == 0:
            break
  
      else:
        data.exists = false
        data.handle = nil
        data.event = ("", FileEventAction.RemoveDir)
    else:
      if dirExists(data.name):
        init(data)
        data.event = ("", FileEventAction.CreateDir)

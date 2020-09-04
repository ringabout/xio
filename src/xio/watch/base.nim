import ../windows/base/fileapi
import os, times


when defined(posix):
  import posix

type
  FileEventAction* {.pure.} = enum
    NonAction
    Create, Modify, Rename, Remove
    CreateSelf, RemoveSelf

  PathEvent* = tuple
    name: string
    action: FileEventAction
    newName: string

  EventCallback* = proc (event: seq[PathEvent]) {.gcsafe.}

proc initDirEvent*(name: string, action: FileEventAction, newName = ""): PathEvent =
  (name, action, newName)

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

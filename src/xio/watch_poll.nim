import timerwheel
import os, times
import windows/base/fileapi


when defined(posix):
  import posix


type
  FileEventAction* {.pure.} = enum
    NonAction
    CreateFile, ModifyFile, RenameFile, RemoveFile
    CreateDir, RemoveDir

  FileEvent* = tuple
    name: string
    action: FileEventAction

  FileEventData* = object
    name*: string
    exists*: bool
    lastModificationTime*: Time
    uniqueId*: uint64
    event*: FileEvent

proc clearEvent*(data: ptr FileEventData) =
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

proc init(data: var FileEventData) =
  data.exists = true
  data.uniqueId = getUniqueFileId(data.name)
  data.lastModificationTime = getLastModificationTime(data.name)

proc init(data: ptr FileEventData, name: string) =
  data.exists = true
  data.uniqueId = getUniqueFileId(name)
  data.lastModificationTime = getLastModificationTime(name)

proc initFileEventData*(name: string): FileEventData =
  result.name = name

  if fileExists(name):
    init(result)

proc filecb*(args: pointer = nil) =
  if args != nil:
    var data = cast[ptr FileEventData](args)
    data.clearEvent()
    if data.exists:
      if fileExists(data.name):
        let now = getLastModificationTime(data.name)
        if now != data.lastModificationTime:
          data.lastModificationTime = now
          data.event = ("", FileEventAction.ModifyFile)
      else:
        data.exists = false
        data.event = ("", FileEventAction.RemoveFile)

        let dir = parentDir(data.name)
        for kind, name in walkDir(dir):
          if kind == pcFile and getUniqueFileId(name) == data.uniqueId:
            data.exists = true
            data.name = name
            data.lastModificationTime = getLastModificationTime(data.name)
            data.event = ("", FileEventAction.RenameFile)
    else:
      if fileExists(data.name):
        init(data, data.name)


var t = initTimer(100)
var data = initFileEventData("watch.nim")
echo cast[pointer](data.addr).repr
var event0 = initTimerEvent(filecb, cast[pointer](addr data))


echo data
# One shot
discard t.add(event0, 10, -1)

while true:
  sleep(2000)
  discard process(t)
  echo data

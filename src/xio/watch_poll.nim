import timerwheel
import os, times


type
  FileEventAction* {.pure.} = enum
    NonAction
    CreateFile, ModifyFile, RenameFile, RemoveFile
    CreatePath, RemovePath

  FileEventData* = object
    name*: string
    exists*: bool
    lastModificationTime*: Time
    uniqueId*: int64
    action*: FileEventAction

proc clearAction*(data: ptr FileEventData) =
  data.action = FileEventAction.NonAction

proc getUniqueFileId*(name: string): int64 =
  when defined(windows):
    let t = getCreationTime(name)
    result = toWinTime(t)

proc initFileEventData*(name: string): FileEventData =
  result.name = name

  if fileExists(name):
    result.exists = true
    result.uniqueId = getUniqueFileId(name)
    result.lastModificationTime = getLastModificationTime(name)

proc filecb*(args: pointer = nil) =
  if args != nil:
    var data = cast[ptr FileEventData](args)
    data.clearAction()
    if data.exists:
      if fileExists(data.name):
        let now = getLastModificationTime(data.name)
        if now != data.lastModificationTime:
          data.lastModificationTime = now
          data.action = FileEventAction.ModifyFile
      else:
        data.exists = false
        data.action = FileEventAction.RemoveFile

        let dir = parentDir(data.name)
        for kind, name in walkDir(dir):
          if kind == pcFile and getUniqueFileId(name) == data.uniqueId:
            data.exists = true
            data.name = name
            data.lastModificationTime = getLastModificationTime(data.name)
            data.action = FileEventAction.RenameFile
    else:
      if fileExists(data.name):
        data.exists = true
        data.lastModificationTime = getLastModificationTime(data.name)
        data.action = FileEventAction.CreateFile


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

import timerwheel
import base
import times, os


type
  FileEvent* = tuple
    name: string
    action: FileEventAction

  FileEventData* = object
    name: string
    exists: bool
    lastModificationTime: Time
    uniqueId: uint64
    event: FileEvent


proc isEmpty*(data: FileEventData): bool =
  result = data.event.action == FileEventAction.NonAction

proc getEvent*(data: FileEventData): FileEvent =
  result = data.event

proc clearEvent*(data: ptr FileEventData) =
  data.event = ("", FileEventAction.NonAction)

proc init(data: var FileEventData) =
  data.exists = true
  data.name = expandFilename(data.name)
  data.uniqueId = getUniqueFileId(data.name)
  data.lastModificationTime = getLastModificationTime(data.name)

proc init(data: ptr FileEventData) =
  data.exists = true
  data.name = expandFilename(data.name)
  data.uniqueId = getUniqueFileId(data.name)
  data.lastModificationTime = getLastModificationTime(data.name)

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
        init(data)


when isMainModule:
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

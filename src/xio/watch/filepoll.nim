import base
import times, os
import timerwheel


type
  FileEventData* = object
    name: string
    exists: bool
    lastModificationTime: Time
    uniqueId: uint64
    event: PathEvent
    cb: EventCallback
    node: TimerEventNode


proc `node`*(data: FileEventData): TimerEventNode =
  data.node

proc `node=`*(data: var FileEventData, node: TimerEventNode) =
  data.node = node

proc isEmpty*(data: FileEventData): bool =
  result = data.event.action == FileEventAction.NonAction

proc getEvent*(data: FileEventData): seq[PathEvent] =
  result = @[data.event]

iterator events*(data: FileEventData): PathEvent =
  yield data.event

proc setEvent*(data: ptr FileEventData, name: string, action: FileEventAction, newName = "") =
  data.event = (name, action, newName)

proc call*(data: ptr FileEventData) =
  if data.cb != nil:
    data.cb(@[data.event])

proc clearEvent*(data: ptr FileEventData) =
  data.event = ("", FileEventAction.NonAction, "")

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

proc initFileEventData*(name: string, cb: EventCallback = nil): FileEventData =
  result.name = name
  result.cb = cb

  if fileExists(name):
    init(result)

proc initDirEventData*(args: seq[tuple[name: string, cb: EventCallback]]): seq[FileEventData] =
  result = newSeq[FileEventData](args.len)
  for idx in 0 ..< args.len:
    result[idx].name = args[idx].name
    result[idx].cb = args[idx].cb

    if dirExists(result[idx].name):
      init(result[idx])

proc close*(data: FileEventData) =
  discard

proc filecb*(args: pointer = nil) =
  if args != nil:
    var data = cast[ptr FileEventData](args)
    data.clearEvent()
    if data.exists:
      if fileExists(data.name):
        let now = getLastModificationTime(data.name)
        if now != data.lastModificationTime:
          data.lastModificationTime = now
          data.setEvent(data.name, FileEventAction.Modify)
          call(data)
      else:
        data.exists = false
        data.setEvent(data.name, FileEventAction.Remove)

        let dir = parentDir(data.name)
        for kind, name in walkDir(dir):
          if kind == pcFile and getUniqueFileId(name) == data.uniqueId:
            data.exists = true
            data.lastModificationTime = getLastModificationTime(name)
            data.setEvent(data.name, FileEventAction.Rename, name)
            data.name = name
            break

        call(data)
    else:
      if fileExists(data.name):
        init(data)
        data.setEvent(data.name, FileEventAction.Create)
        call(data)


when isMainModule:
  import timerwheel


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


import timerwheel

when defined(windows):
  import os, times
  import ../windows/base/[fileapi, handleapi]

elif defined(posix):
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


when defined(windows):
  type
    PathKind* {.pure.}  = enum
      File, Dir

    PathEventData* = object
      name*: string
      exists*: bool
      cb: EventCallback
      node: TimerEventNode

      case kind*: PathKind
      of PathKind.File:
        lastModificationTime*: Time
        uniqueId*: uint64
      of PathKind.Dir:
        handle*: Handle
        buffer*: string
        reads*: DWORD
        over*: OVERLAPPED

  proc close*(data: PathEventData) =
    case data.kind
    of PathKind.File:
      discard
    of PathKind.Dir:
      discard data.handle.closeHandle()

  proc getFileId(name: string): uint =
    var x = newWideCString(name)
    result = uint getFileAttributesW(addr x)

  proc `name=`*(data: var PathEventData, name: string) =
    data.name = name

  proc `cb=`*(data: var PathEventData, cb: EventCallback) =
    data.cb = cb

  proc call*(data: ptr PathEventData, event: seq[PathEvent]) =
    data.cb(event)
elif defined(linux):
  type
    EventList* = object
      name*: string
      wd*: cint
      cb*: EventCallback

    PathEventData* = object
      list*: seq[EventList]
      handle*: FileHandle
      node*: TimerEventNode
      event*: seq[PathEvent]
      buffer*: string



  proc call*(data: ptr PathEventData, event: seq[PathEvent]) =
    for item in data.list:
      if item.cb != nil:
        item.cb(event)

proc `node`*(data: PathEventData): TimerEventNode =
  data.node

proc `node=`*(data: var PathEventData, node: TimerEventNode) =
  data.node = node

proc initPathEvent*(name: string, action: FileEventAction, newName = ""): PathEvent =
  (name, action, newName)

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

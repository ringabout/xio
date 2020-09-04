import ../linux/inotify
import base
import times, os
import timerwheel

import posix


type
  EventList* = object
    name: string
    wd: cint
    cb: EventCallback

  FileEventData* = object
    list: seq[EventList]
    handle: FileHandle
    node: TimerEventNode
    event: seq[PathEvent]
    buffer: string

  DirEventData* = FileEventData

proc initEventList*(name: string, wd: cint, cb: EventCallback): EventList =
  EventList(name: name, wd: wd, cb: cb)

proc `node`*(data: FileEventData | DirEventData): TimerEventNode =
  data.node

proc `node=`*(data: var FileEventData | var DirEventData, node: TimerEventNode) =
  data.node = node

proc isEmpty*(data: FileEventData): bool =
  result = data.event.len == 0

proc getEvent*(data: FileEventData | DirEventData): seq[PathEvent] =
  result = data.event

iterator events*(data: FileEventData | DirEventData): PathEvent =
  for event in data.event:
    yield event

proc clearEvent*(data: ptr DirEventData) =
  data.event = @[]

proc initFileEventData*(name: string, cb: EventCallback = nil): FileEventData =
  result.handle = inotify_init()

  var event = EventList(name: expandFilename(name), cb: cb)

  if fileExists(name):
    event.wd = inotify_add_watch(result.handle, name.cstring, IN_ALL_EVENTS)

proc initFileEventData*(args: seq[tuple[name: string, cb: EventCallback]]): seq[FileEventData] =
  var data: FileEventData
  data.handle = inotify_init1(O_NONBLOCK)
  data.buffer = newString(4096)

  data.list = newSeq[EventList](args.len)
  for idx in 0 ..< args.len:
    data.list[idx].name = expandFilename(args[idx].name)
    data.list[idx].cb = args[idx].cb

    if fileExists(data.list[idx].name):
      data.list[idx].wd = inotify_add_watch(data.handle, data.list[idx].name.cstring, IN_ALL_EVENTS)
  result = @[data]


  # InotifyEvent* {.pure, final, importc: "struct inotify_event",
  #                 header: "<sys/inotify.h>".} = object ## An Inotify event.
  #   wd* {.importc: "wd".}: FileHandle                  ## Watch descriptor.
  #   mask* {.importc: "mask".}: uint32                  ## Watch mask.
  #   cookie* {.importc: "cookie".}: uint32              ## Cookie to synchronize two events.
  #   len* {.importc: "len".}: uint32                    ## Length (including NULs) of name.
  #   name* {.importc: "name".}: char                    ## Name.

proc dircb*(args: pointer = nil) =
  if args != nil:
    var data = cast[ptr FileEventData](args)
    data.clearEvent()

    let size = posix.read(data.handle, data.buffer.cstring, data.buffer.len)
    var pos = 0

    if size > 0:
      var buf = cast[pointer](data.buffer.cstring)
      let event = cast[ptr InotifyEvent](cast[ByteAddress](buf) + pos)
      var name: string
      if event.len != 0:
        name = $(event.name.addr.cstring)
      else:
        name = ""

      if (event.mask and IN_MODIFY) != 0:
        data.event.add((name, FileEventAction.Modify, ""))
      elif (event.mask and IN_DELETE_SELF) != 0:
        data.event.add((name, FileEventAction.Remove, ""))
      elif (event.mask and IN_CREATE) != 0:
        data.event.add((name, FileEventAction.Create, ""))
      elif (event.mask and IN_DELETE) != 0:
        data.event.add((name, FileEventAction.Remove, ""))

      inc(pos, sizeof(InotifyEvent) + event.len.int)

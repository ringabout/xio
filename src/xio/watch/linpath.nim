import ../linux/inotify
import base
import times, os
import timerwheel


type
  EventList* = object
    name: string
    wd: cint

  FileEventData* = object
    list: seq[EventList]
    handle: FileHandle
    node: TimerEventNode
    event: seq[PathEvent]
    cb: EventCallback

  DirEventData* = FileEventData

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

proc initFileEventData*(name: string, cb: EventCallback = nil): FileEventData =

  result.cb = cb

  # if fileExists(name):
  #   init(result)

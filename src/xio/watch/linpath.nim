import ../linux/inotify
import base
import times, os
import timerwheel


type
  FileEventData* = object
    name: string
    exists: bool
    handle: FileHandle
    event: PathEvent
    node: TimerEventNode

  DirEventData* = object
    name: string
    exists: bool
    handle: FileHandle
    event: seq[PathEvent]
    node: TimerEventNode

proc `node`*(data: FileEventData | DirEventData): TimerEventNode =
  data.node

proc `node=`*(data: var FileEventData | var DirEventData, node: TimerEventNode) =
  data.node = node

import ../linux/inotify
import base
import os, posix


proc initEventList*(name: string, wd: cint): EventList =
  EventList(name: name, wd: wd)

proc initFileEventData*(name: string, cb: EventCallback): PathEventData =
  result.handle = inotify_init()
  result.buffer = newString(1024 * 4)
  result.cb = cb


  if fileExists(name):
    var event = EventList(name: expandFilename(name))
    event.wd = inotify_add_watch(result.handle, name.cstring, IN_ALL_EVENTS)
    result.list.add event

proc initDirEventData*(name: string, cb: EventCallback): PathEventData =
  result.handle = inotify_init()
  result.buffer = newString(1024 * 4)
  result.cb = cb


  if dirExists(name):
    var event = EventList(name: expandFilename(name))
    event.wd = inotify_add_watch(result.handle, name.cstring, IN_ALL_EVENTS)
    result.list.add event

template pathcb*(args: pointer = nil) =
  if args != nil:
    var data = cast[ptr PathEventData](args)

    let size = posix.read(data.handle, data.buffer.cstring, data.buffer.len)
    var pos = 0


    if size > 0:
      var buf = cast[pointer](data.buffer.cstring)
      var cookie: uint32
      var fromName: string
      var events: seq[PathEvent]

      while pos < size:
        let event = cast[ptr InotifyEvent](cast[ByteAddress](buf) + pos)
        var name: string
        if event.len != 0:
          name = $(event.name.addr.cstring)
        else:
          name = ""

        if (event.mask and IN_MODIFY) != 0:
          events.add((name, FileEventAction.Modify, ""))
        elif (event.mask and IN_DELETE_SELF) != 0:
          events.add((name, FileEventAction.Remove, ""))
        elif (event.mask and IN_CREATE) != 0:
          events.add((name, FileEventAction.Create, ""))
        elif (event.mask and IN_MOVED_FROM) != 0:
          fromName = name
          cookie = event.cookie
        elif (event.mask and IN_MOVED_TO) != 0:
          if cookie == event.cookie:
            events.add((fromName, FileEventAction.Rename, name))
          else:
            events.add((name, FileEventAction.Remove, ""))
        elif (event.mask and IN_DELETE) != 0:
          events.add((name, FileEventAction.Remove, ""))

        inc(pos, sizeof(InotifyEvent) + event.len.int)

      if events.len != 0:
        call(data, events)

proc filecb*(args: pointer = nil) =
  pathcb(args)

proc dircb*(args: pointer = nil) =
  pathcb(args)

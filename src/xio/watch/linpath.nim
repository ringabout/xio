import ../linux/inotify
import base
import os, posix


proc initEventList*(name: string, wd: cint, cb: EventCallback): EventList =
  EventList(name: name, wd: wd, cb: cb)

proc initFileEventData*(name: string, cb: EventCallback): PathEventData =
  result.handle = inotify_init()

  var event = EventList(name: expandFilename(name), cb: cb)

  if fileExists(name):
    event.wd = inotify_add_watch(result.handle, name.cstring, IN_ALL_EVENTS)

proc initDirEventData*(name: string, cb: EventCallback): PathEventData =
  result.handle = inotify_init()

  var event = EventList(name: expandFilename(name), cb: cb)

  if dirExists(name):
    event.wd = inotify_add_watch(result.handle, name.cstring, IN_ALL_EVENTS)


  # InotifyEvent* {.pure, final, importc: "struct inotify_event",
  #                 header: "<sys/inotify.h>".} = object ## An Inotify event.
  #   wd* {.importc: "wd".}: FileHandle                  ## Watch descriptor.
  #   mask* {.importc: "mask".}: uint32                  ## Watch mask.
  #   cookie* {.importc: "cookie".}: uint32              ## Cookie to synchronize two events.
  #   len* {.importc: "len".}: uint32                    ## Length (including NULs) of name.
  #   name* {.importc: "name".}: char                    ## Name.

proc dircb*(args: pointer = nil) =
  if args != nil:
    var data = cast[ptr PathEventData](args)

    let size = posix.read(data.handle, data.buffer.cstring, data.buffer.len)
    var pos = 0

    if size > 0:
      var buf = cast[pointer](data.buffer.cstring)
      var cookie: uint32
      var fromName: string

      while pos < size:
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
        elif (event.mask and IN_MOVED_FROM) != 0:
          fromName = name
          cookie = event.cookie
        elif (event.mask and IN_MOVED_TO) != 0:
          if cookie == event.cookie:
            data.event.add((fromName, FileEventAction.Rename, name))
          else:
            data.event.add((name, FileEventAction.Remove, ""))
        elif (event.mask and IN_DELETE) != 0:
          data.event.add((name, FileEventAction.Remove, ""))

        inc(pos, sizeof(InotifyEvent) + event.len.int)

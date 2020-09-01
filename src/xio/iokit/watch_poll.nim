import timerwheel
import os, times


type
  FileEvent* = enum
    Create, Modify, Rename, Remove
    CreatePath, RemovePath

  FileEventData* = object
    name*: string
    lastModificationTime*: Time


proc initFileEventData*(name: string): FileEventData =
  result.name = name
  result.lastModificationTime = getLastModificationTime(name)

echo getLastModificationTime("watch.nim")

var t = initTimer(100)

proc timercb*(args: pointer = nil) =
  if args != nil:
    let data = cast[ptr FileEventData](args)
    let now = getLastModificationTime(data.name)
    if now != data.lastModificationTime:
      data.lastModificationTime = now
      echo "changed"


var data = initFileEventData("watch.nim")
echo cast[pointer](data.addr).repr
var event0 = initTimerEvent(timercb, cast[pointer](addr data))


echo data
# One shot
discard t.add(event0, 10, -1)

while true:
  sleep(1000)
  discard process(t)

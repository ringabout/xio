import timerwheel
import os, base
export base


when defined(windows):
  import windir, filepoll
  export windir, filepoll
elif defined(linux):
  import linpath
  export linpath


type
  Watcher* = object
    timer: Timer
    path: seq[PathEventData]

proc taskCounter*(watcher: Watcher): int =
  watcher.timer.wheel.taskCounter

proc initWatcher*(interval = 100): Watcher =
  result.timer = initTimer(interval)

proc register*(watcher: var Watcher, path: string, cb: EventCallback, 
               ms = 10, repeatTimes = -1, treatAsFile = false) =
  let idx = watcher.path.len
  if fileExists(path):
    watcher.path.add(initFileEventData(path, cb))
  elif dirExists(path):
    watcher.path.add(initDirEventData(path, cb))
  elif treatAsFile:
    watcher.path.add(initFileEventData(path, cb))
  else:
    watcher.path.add(initDirEventData(path, cb))

  var event = initTimerEvent(filecb, cast[pointer](addr watcher.path[idx]))
  watcher.path[idx].node = watcher.timer.add(event, ms, repeatTimes)

proc register*(watcher: var Watcher, dataList: seq[tuple[path: string, cb: EventCallback]], 
               ms = 10, repeatTimes = -1, treatAsFile = false) =
  for data in dataList:
    watcher.register(data.path, data.cb, ms, repeatTimes, treatAsFile)

# proc remove*(watcher: var Watcher, data: PathEventData) =
#   watcher.timer.cancel(data.node)
#   data.close()

proc poll*(watcher: var Watcher, ms = 100) =
  sleep(ms)
  discard process(watcher.timer)


# when isMainModule:
#   block:
#     var count = 0
#     proc hello(event: PathEvent) =
#       inc count

#     let filename = "d://qqpcmgr/desktop/e.txt"
#     var data = initFileEventData(filename, cb = hello)
#     var watcher = initWatcher(1)
#     register(watcher, data)

#     writeFile(filename, "123")
#     poll(watcher, 10)

#     doAssert watcher.taskCounter == 1
#     doAssert count == 1

#     moveFile(filename, "d://qqpcmgr/desktop/1223.txt")
#     poll(watcher, 10)
#     doAssert watcher.taskCounter == 1
#     doAssert count == 2

#     remove(watcher, data)
#     poll(watcher, 10)
#     doAssert watcher.taskCounter == 0
#     doAssert count == 2

#   block:
#     let path = "d://qqpcmgr/desktop/test"
#     var data = initDirEventData(path)
#     var watcher = initWatcher(100)
#     register(watcher, data)

#     while true:
#       poll(watcher, 2000)
#       echo data.getEvent()

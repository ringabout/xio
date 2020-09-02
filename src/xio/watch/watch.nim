import timerwheel
import os


when defined(windows):
  import windir, filepoll
  export windir, filepoll


type
  Watcher* = object
    timer: Timer


proc initWatcher*(interval = 100): Watcher =
  result.timer = initTimer(interval)

proc registerFile*(watcher: var Watcher, filename: string, data: var FileEventData, ms = 10, repeatTimes = -1) =
  var event = initTimerEvent(filecb, cast[pointer](addr data))
  discard watcher.timer.add(event, ms, repeatTimes)

proc registerDir*(watcher: var Watcher, dirname: string, data: var DirEventData, ms = 10, repeatTimes = -1) =
  var event = initTimerEvent(dircb, cast[pointer](addr data))
  discard watcher.timer.add(event, ms, repeatTimes)

proc poll*(watcher: var Watcher, ms = 100) =
  sleep(ms)
  discard process(watcher.timer)

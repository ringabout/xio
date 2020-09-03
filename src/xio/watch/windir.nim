import ../windows/base/[fileapi, handleapi, winbase, ioapiset]
import os
import base
import timerwheel


type
  DirEventCallback* = proc (event: seq[PathEvent]) {.gcsafe.}

  DirEventData* = object
    name: string
    handle: Handle
    exists: bool
    event: seq[PathEvent]
    buffer: string
    reads: DWORD
    over: OVERLAPPED
    cb: DirEventCallback
    node: TimerEventNode


proc `node`*(data: DirEventData): TimerEventNode =
  data.node

proc `node=`*(data: var DirEventData, node: TimerEventNode) =
  data.node = node

proc call*(data: ptr DirEventData) =
  if data.cb != nil:
    data.cb(data.event)

proc isEmpty*(data: DirEventData): bool =
  result = data.event.len == 0

proc getEvent*(data: DirEventData): seq[PathEvent] =
  result = data.event

proc clearEvent*(data: ptr DirEventData) =
  data.event = @[]

proc startQueue*(data: ptr DirEventData) =
  discard readDirectoryChangesW(data.handle, data.buffer.cstring, 
              cast[DWORD](data.buffer.len), 0, FILE_NOTIFY_CHANGE_FILE_NAME or 
              FILE_NOTIFY_CHANGE_DIR_NAME or 
              FILE_NOTIFY_CHANGE_LAST_WRITE, data.reads, addr data.over, nil)

proc startQueue*(data: var DirEventData) =
  discard readDirectoryChangesW(data.handle, data.buffer.cstring, 
              cast[DWORD](data.buffer.len), 0, FILE_NOTIFY_CHANGE_FILE_NAME or 
              FILE_NOTIFY_CHANGE_DIR_NAME or 
              FILE_NOTIFY_CHANGE_LAST_WRITE, data.reads, addr data.over, nil)

proc init(data: var DirEventData) =
  let name = newWideCString(data.name)
  data.name = expandFilename(data.name)
  data.exists = true
  data.buffer = newString(1024)
  data.handle = createFileW(name, FILE_LIST_DIRECTORY, FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                              OPEN_EXISTING, FILE_FLAG_OVERLAPPED or FILE_FLAG_BACKUP_SEMANTICS, nil)
  startQueue(data)

proc init(data: ptr DirEventData) =
  let name = newWideCString(data.name)
  data.name = expandFilename(data.name)
  data.exists = true
  data.buffer = newString(1024)
  data.handle = createFileW(name, FILE_LIST_DIRECTORY, FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                              OPEN_EXISTING, FILE_FLAG_OVERLAPPED or FILE_FLAG_BACKUP_SEMANTICS, nil)
  startQueue(data)

proc initDirEventData*(name: string, cb: DirEventCallback = nil): DirEventData =
  result.name = name
  result.cb = cb

  if dirExists(name):
    init(result)

proc close*(data: DirEventData) =
  discard data.handle.closeHandle()

proc dircb*(args: pointer = nil) =
  if args != nil:
    var data = cast[ptr DirEventData](args)
    data.clearEvent()

    if data.exists:
      if dirExists(data.name):
        if data.handle == nil:
          let name = newWideCString(data.name)
          data.handle = createFileW(name, FILE_LIST_DIRECTORY, FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                              OPEN_EXISTING, FILE_FLAG_OVERLAPPED or FILE_FLAG_BACKUP_SEMANTICS, nil)


        for _ in 0 ..< 2:
          if getOverlappedResult(data.handle, addr data.over, data.reads, 0) != 0:
            var buf = cast[pointer](data.buffer.substr(0, data.reads.int - 1).cstring)
            var oldName = ""
            var next: int

            while true:
              let info = cast[PFILE_NOTIFY_INFORMATION](cast[ByteAddress](buf) + next)

              if info == nil:
                break

              var tmp = newWideCString("", info.FileNameLength.int div 2)
              for idx in 0 ..< info.FileNameLength.int div 2:
                tmp[idx] = info.FileName[idx]

              let name = $tmp

              case info.Action
              of FILE_ACTION_ADDED:
                data.event.add(initDirEvent(name, FileEventAction.CreateFile))
              of FILE_ACTION_REMOVED:
                data.event.add(initDirEvent(name,FileEventAction.RemoveFile))
              of FILE_ACTION_MODIFIED:
                data.event.add(initDirEvent(name, FileEventAction.ModifyFile))
              of FILE_ACTION_RENAMED_OLD_NAME:
                oldName = name
              of FILE_ACTION_RENAMED_NEW_NAME:
                data.event.add(initDirEvent(oldName, FileEventAction.RenameFile, name))
              else:
                discard

              if info.NextEntryOffset == 0:
                break

              inc(next, info.NextEntryOffset.int)

            startQueue(data)
            call(data)
      else:
        data.exists = false
        data.handle = nil
        data.event = @[initDirEvent("", FileEventAction.RemoveDir)]
        call(data)

    else:
      if dirExists(data.name):
        init(data)
        data.event = @[initDirEvent("", FileEventAction.CreateDir)]
        call(data)


when isMainModule:
  import timerwheel


  var t = initTimer(1)
  var data = initDirEventData("d://qqpcmgr/desktop/test")
  var event0 = initTimerEvent(dircb, cast[pointer](addr data))


  discard t.add(event0, 1000, -1)

  while true:
    sleep(2000)
    discard process(t)

  discard data.handle.closeHandle()

{.pragma: coreservices, header: "CoreServices/CoreServices.h".}


type
  CFAllocatorRef* {.coreservices, importc: "struct CFAllocatorRef"} = ptr object
  ConstFSEventStreamRef* {.coreservices, importc: "struct ConstFSEventStreamRef"} = ptr object
  size_t* {.coreservices, importc: "size_t"} = culong
  FSEventStreamEventFlags* {.coreservices, importc: "FSEventStreamEventFlags"} = uint32
  FSEventStreamEventId* {.coreservices, importc: "FSEventStreamEventId"} = uint64
  FSEventStreamContext* {.coreservices, importc: "struct FSEventStreamContext".} = object
  CFArrayRef* {.coreservices, importc: "struct CFArrayRef".} = object
  CFTimeInterval* {.coreservices, importc: "CFTimeInterval".} = float
  FSEventStreamCreateFlags* {.coreservices, importc: "FSEventStreamCreateFlags".} = uint32
  FSEventStreamRef* {.coreservices, importc: "struct FSEventStreamRef"} = ptr object

  FSEventStreamCallback* = proc (
    streamRef: ConstFSEventStreamRef,
    clientCallBackInfo: pointer,
    numEvents: size_t,
    eventPaths: pointer,
    eventFlags: ptr FSEventStreamEventFlags,
    eventIds: ptr FSEventStreamEventId
    )

proc CFSTR*(str:cstring): cstring {.coreservices, importc:"CFSTR".}

proc FSEventStreamCreate*(
  allocator: CFAllocatorRef,
  callback: FSEventStreamCallback,
  context: ptr FSEventStreamContext,
  pathsToWatch: CFArrayRef,
  sinceWhen: FSEventStreamEventId,
  latency: CFTimeInterval,
  flags: FSEventStreamCreateFlags
): FSEventStreamRef {.coreservices, importc: "FSEventStreamCreate".}

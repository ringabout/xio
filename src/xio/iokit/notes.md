# Nim 的异步

```nim
import asyncdispatch


proc test() {.async.} =
  await sleepAsync(100)

proc hello() {.async.} =
  let a = 12
  echo a
  await test()
```

Nim proc -> Nim iter

```nim
proc hello() =
  var ret: FutureBase
  iterator helloIter() {.closure.} =
    let a = 12
    echo a
    discard
      var internalTmpFuture: FutureBase = test()
      yield internalTmpFuture
      read(cast[type(test())](internalTmpFuture))

    complete(ret)

  proc helloRegister() =
    addCallBack(hello)


  helloRegister()
  return ret
```

Nim 使用定时器，每隔一段时间，从全局 dispatcher 中取出一个 Future， 如果完成，就调用 callback，如果未完成再将 `Future - callback` 重新加到（定时器数值调整） heapqueue 中，如果闭包迭代器已完成，则 do nothing。每次调用 callback，将执行一次闭包迭代器，该操作会改变闭包中的 Future 变量。

```nim
proc hello(): callback =
  var state: 0
  proc stateMachine() =
    case state
    of 0:
      doSomething()
      state = 1
    of 1:
      doSomething()
      state = 2
    of 2:
      doSomething()
      state = 3
    else:
      discard

proc hello() =
  var state: Future
  proc stateMachine() =
    if state == empty:
      return

    case state.finished
    of true:
      state = getNextState()
      addCallback(state, stateMachine)
    of false:
      addCallback(state, stateMachine)
```


```nim
import asyncdispatch, macros


expandMacros:

  proc test(): Future[int] {.async.} =
    echo "htttt"
    return 12

  proc hello(): Future[int] {.async.} =
    var fet = newFuture[void]("uuu")
    if true:
      fet.complete()
      yield fet
    
    discard await test()
    let x = await test()
    echo x
    return 12

  discard waitFor hello()
```


```nim
proc test(): Future[int] =
  template await(f`gensym17972021: typed): untyped {.used.} =
    static :
      error "await expects Future[T], got " & $typeof(f`gensym17972021)

  template await[T](f`gensym17972022: Future[T]): auto {.used.} =
    var internalTmpFuture`gensym17972023_17975018: FutureBase = f`gensym17972022
    yield internalTmpFuture`gensym17972023_17975018
    (cast[type(f`gensym17972022)](internalTmpFuture`gensym17972023_17975018)).read()

  var retFuture_17972014 = newFuture("test")
  iterator testIter_17972015(): owned(FutureBase) {.closure.} =
    {.push, warning[resultshadowed]: false.}
    var result: int
    {.pop.}
    block:
      echo ["htttt"]
      complete(retFuture_17972014, 12)
      return nil
    complete(retFuture_17972014, result)

  let retFutUnown`gensym17972017 = retFuture_17972014
  var nameIterVar`gensym17972018 = testIter_17972015
  proc testNimAsyncContinue_17972016() {.closure.} =
    try:
      if not finished(nameIterVar`gensym17972018):
        var next`gensym17972019 = nameIterVar`gensym17972018()
        while not isNil(next`gensym17972019) and finished(next`gensym17972019):
          next`gensym17972019 = nameIterVar`gensym17972018()
          if finished(nameIterVar`gensym17972018):
            break
        if next`gensym17972019 == nil:
          if not finished(retFutUnown`gensym17972017):
            let msg`gensym17972020 = "Async procedure ($1) yielded `nil`, are you await\'ing a `nil` Future?"
            raise
              (ref AssertionDefect)(msg: msg`gensym17972020 % "test", parent: nil)
        else:
          {.gcsafe.}:
            {.push, hint[ConvFromXtoItselfNotNeeded]: false.}
            addCallback(next`gensym17972019,
                        cast[proc () {.closure, gcsafe.}](testNimAsyncContinue_17972016))
            {.pop.}
    except:
      if finished(retFutUnown`gensym17972017):
        raise
      else:
        fail(retFutUnown`gensym17972017, getCurrentException())
  
  testNimAsyncContinue_17972016()
  return retFuture_17972014

proc hello(): Future[int] =
  template await(f`gensym17995071: typed): untyped {.used.} =
    static :
      error "await expects Future[T], got " & $typeof(f`gensym17995071)

  template await[T](f`gensym17995072: Future[T]): auto {.used.} =
    var internalTmpFuture`gensym17995073_18000018: FutureBase = f`gensym17995072
    yield internalTmpFuture`gensym17995073_18000018
    (cast[type(f`gensym17995072)](internalTmpFuture`gensym17995073_18000018)).read()

  var retFuture_17995064 = newFuture("hello")
  iterator helloIter_17995065(): owned(FutureBase) {.closure.} =
    {.push, warning[resultshadowed]: false.}
    var result: int
    {.pop.}
    block:
      var fet = newFuture("uuu")
      if true:
        complete(fet)
        yield fet
      discard
        var internalTmpFuture`gensym17995073`gensym18000079: FutureBase = test()
        yield internalTmpFuture`gensym17995073`gensym18000079
        read(cast[type(test())](internalTmpFuture`gensym17995073`gensym18000079))
      let x =
        var internalTmpFuture`gensym17995073`gensym18015016: FutureBase = test()
        yield internalTmpFuture`gensym17995073`gensym18015016
        read(cast[type(test())](internalTmpFuture`gensym17995073`gensym18015016))
      echo [x]
      complete(retFuture_17995064, 12)
      return nil
    complete(retFuture_17995064, result)

  let retFutUnown`gensym17995067 = retFuture_17995064
  var nameIterVar`gensym17995068 = helloIter_17995065
  proc helloNimAsyncContinue_17995066() {.closure.} =
    try:
      if not finished(nameIterVar`gensym17995068):
        var next`gensym17995069 = nameIterVar`gensym17995068()
        while not isNil(next`gensym17995069) and finished(next`gensym17995069):
          next`gensym17995069 = nameIterVar`gensym17995068()
          if finished(nameIterVar`gensym17995068):
            break
        if next`gensym17995069 == nil:
          if not finished(retFutUnown`gensym17995067):
            let msg`gensym17995070 = "Async procedure ($1) yielded `nil`, are you await\'ing a `nil` Future?"
            raise
              (ref AssertionDefect)(msg: msg`gensym17995070 % "hello", parent: nil)
        else:
          {.gcsafe.}:
            {.push, hint[ConvFromXtoItselfNotNeeded]: false.}
            addCallback(next`gensym17995069,
                        cast[proc () {.closure, gcsafe.}](helloNimAsyncContinue_17995066))
            {.pop.}
    except:
      if finished(retFutUnown`gensym17995067):
        raise
      else:
        fail(retFutUnown`gensym17995067, getCurrentException())
  
  helloNimAsyncContinue_17995066()
  return retFuture_17995064

discard waitFor hello()
```


```nim
proc hello() =
  var ret: FutureBase
  var state = 0

  proc helloIter() {.closure.} =
    case state
    of 0:
      let f1 = sleepAsync(12)
      if not f1.finished:
        addCallback(f1, helloIter)
      else:
        state = 1
    of 1:
      let f2 = sleepAsync(12)
      if not f2.finished:
        addCallback(f1, helloIter)
      else:
        state = 2
    else:
      complete(ret, 5)
```

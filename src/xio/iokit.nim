when defined(windows):
  import iokit/windows/iocp
  export iocp
else:
  import iokit/linux/io_uring
  export io_uring

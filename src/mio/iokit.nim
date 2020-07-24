when defined(windows):
  import iokit/iocp
else:
  import iokit/io_uring

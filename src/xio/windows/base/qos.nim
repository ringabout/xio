import minwindef


type
  SERVICETYPE* = ULONG

  FLOWSPEC* = object
    tokenRate*: ULONG
    tokenBucketSize*: ULONG
    peakBandwidth*: ULONG
    latency*: ULONG
    delayVariation*: ULONG
    serviceType*: SERVICETYPE
    maxSduSize*: ULONG
    minimumPolicedSize*: ULONG

  PFLOWSPEC* = ptr FLOWSPEC
  LPFLOWSPEC* = ptr FLOWSPEC

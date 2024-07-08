import base/basetsd

type
  GUID* = object
    data1: culong
    data2: cushort
    data3: cushort
    data4: array[8, uchar]

#            Nim's Runtime Library
#        (c) Copyright 2012 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
const
  UNI_REPLACEMENT_CHAR = Utf16Char(0xFFFD'i16)
  UNI_MAX_BMP = 0x0000FFFF
  UNI_MAX_UTF16 = 0x0010FFFF
  UNI_MAX_UTF32 = 0x7FFFFFFF
  UNI_MAX_LEGAL_UTF32 = 0x0010FFFF

  halfShift = 10
  halfBase = 0x0010000
  halfMask = 0x3FF

  UNI_SUR_HIGH_START = 0xD800
  UNI_SUR_HIGH_END = 0xDBFF
  UNI_SUR_LOW_START = 0xDC00
  UNI_SUR_LOW_END = 0xDFFF
  UNI_REPL = 0xFFFD

template ones(n: untyped): untyped = ((1 shl n)-1)

proc toString*(w: UncheckedArray[Utf16Char], estimate: int, replacement: int = 0xFFFD): string =
  result = newStringOfCap(estimate + estimate shr 2)

  var i = 0
  while w[i].int16 != 0'i16:
    var ch = ord(w[i])
    inc i
    if ch >= UNI_SUR_HIGH_START and ch <= UNI_SUR_HIGH_END:
      # If the 16 bits following the high surrogate are in the source buffer...
      let ch2 = ord(w[i])

      # If it's a low surrogate, convert to UTF32:
      if ch2 >= UNI_SUR_LOW_START and ch2 <= UNI_SUR_LOW_END:
        ch = (((ch and halfMask) shl halfShift) + (ch2 and halfMask)) + halfBase
        inc i
      else:
        #invalid UTF-16
        ch = replacement
    elif ch >= UNI_SUR_LOW_START and ch <= UNI_SUR_LOW_END:
      #invalid UTF-16
      ch = replacement

    if ch < 0x80:
      result.add chr(ch)
    elif ch < 0x800:
      result.add chr((ch shr 6) or 0xc0)
      result.add chr((ch and 0x3f) or 0x80)
    elif ch < 0x10000:
      result.add chr((ch shr 12) or 0xe0)
      result.add chr(((ch shr 6) and 0x3f) or 0x80)
      result.add chr((ch and 0x3f) or 0x80)
    elif ch <= 0x10FFFF:
      result.add chr((ch shr 18) or 0xf0)
      result.add chr(((ch shr 12) and 0x3f) or 0x80)
      result.add chr(((ch shr 6) and 0x3f) or 0x80)
      result.add chr((ch and 0x3f) or 0x80)
    else:
      # replacement char(in case user give very large number):
      result.add chr(0xFFFD shr 12 or 0b1110_0000)
      result.add chr(0xFFFD shr 6 and ones(6) or 0b10_0000_00)
      result.add chr(0xFFFD and ones(6) or 0b10_0000_00)

proc toString*(s: UncheckedArray[Utf16Char]): string =
  result = toString(s, 80)

import os


let f1 = open("test.txt", fmRead)
echo getFileInfo(f1)
close(f1)
sleep(10000)
let f2 = open("test1.txt", fmRead)
echo getFileInfo(f2)
close(f2)

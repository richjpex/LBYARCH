## How to compile program
```
nasm -f win32 imgAvgFilter.asm

gcc -c main.c -o main.obj -m32

gcc main.obj imgAvgFilter.obj -o main.exe -m32

main.exe```

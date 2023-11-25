## How to compile program
``nasm -f win32 imgAvgFilter.asm``<br>
``gcc -c main.c -o main.obj -m32``<br>
``gcc main.obj imgAvgFilter.obj -o main.exe -m32``<br>
``main.exe``

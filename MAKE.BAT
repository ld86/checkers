@echo off
tasm MAIN.asm
tlink /t MAIN.obj
del *.swp
del *.obj
del *.map
main

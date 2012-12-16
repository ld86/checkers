.model tiny
.code
.486
LOCALS @@

org 100h
_1:
    jmp start

include com.asm
include game_l~1.asm
include handlers.asm
include graphics.asm
include game.asm
include mouse.asm
include utils.asm
include timer.asm
include ssp.asm
include states.asm

start:
    push bp
    mov bp, sp

    call c_graphics
    call c_mouse
    call Ser_Ini
    call set_timer

    call events_dispatcher

    call unset_timer
    call Ser_Rst
    call d_mouse
    call d_graphics

    pop bp
	ret

end _1

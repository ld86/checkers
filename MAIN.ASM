.model tiny
.code
.486
LOCALS @@

org 100h
_1:
    jmp start

include com.asm
include graphics.asm
include game.asm
include mouse.asm
include utils.asm

start:
    push bp
    mov bp, sp
    call c_graphics

    call draw_field
    call c_mouse

    call events_dispatcher    

    call d_mouse
    call d_graphics
    pop bp
	ret

end _1

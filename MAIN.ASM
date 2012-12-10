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

start:
    push bp
    mov bp, sp

    push 1
    call start_game
    add sp, 2

    pop bp
	ret

end _1

LOCALS @@

proc pause
    mov ah, 7
    int 21h
    ret
endp pause

; Symbol [bp+4]
proc bad_protocol
    push bp
    mov bp, sp
    
    mov ah, 02h
    xor bh, bh
    mov dh, 0
    mov dl, next_position
    int 10h
        
    mov ah, 02
    mov dx, [bp+4]
    int 21h

    inc next_position
    cmp next_position, 20
    jne @@end

    mov next_position, 0 

@@end:    
    pop bp
    ret
endp bad_protocol
next_position db 0


proc get_ssp
    push bp
    mov bp, sp

    xor ax, ax
    int 1Ah

    mov ax, dx
    xor dx, dx

    mov bx, 3

    idiv bx
    mov ax, dx

    pop bp
    ret
endp get_ssp

proc clear_screen
    mov ah, 06
    mov bh, 0
    xor al, al
    xor cx, cx
    mov dh, 52
    mov dl, 79
    int 10h
    ret
endp



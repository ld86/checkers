; X Y
proc get_color
    push bp
    mov bp, sp

    mov ax, [bp+4]
    mov bx, 8
    imul bl
    add ax, [bp+6]
    mov bx, ax
    add bx, table_addr
    mov cl, byte ptr [bx]
    xor ch, ch
    mov ax, cx

    pop bp
    ret
endp get_color

; X Y Color
proc set_color
    push bp
    mov bp, sp

    mov ax, [bp+6]
    mov bx, 8
    imul bl
    add ax, [bp+8]
    mov bx, ax
    add bx, table_addr
    mov cx, [bp+4]
    mov byte ptr [bx], cl

    pop bp
    ret
endp set_color

; X1 [bp+10]
; Y1 [bp+8]
; X2 [bp+6]
; Y2 [bp+4]
proc make
    push bp
    mov bp, sp
    
    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    mov ax, game_color
    push ax
    call set_color
    add sp, 2
    
    call redraw_chip
    add sp, 4
    
    mov ax, [bp+10]
    mov bx, [bp+8]
    push ax
    push bx
    push 0FFh
    call set_color
    add sp, 2

    call redraw_cell
    add sp, 4

    pop bp
    ret
endp make

proc is_allow_make
    mov ax,1
    ret
endp is_allow_make

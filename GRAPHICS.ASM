LOCALS @@

c_graphics:
    mov ah,00
    mov al,12h
    int 10h
    ret

; X Y Color
draw_pixel:
    push bp
    mov bp, sp
    mov ax, [bp+4] ; Color
    mov dx, [bp+6] ; Y
    mov cx, [bp+8] ; X
    mov ah, 0ch
    mov bh, 0
    int 10h
    pop bp
    ret

; X1 Y1 R Color
proc draw_circle
    push bp
    mov bp, sp
    sub sp, 6
    mov ax, [bp+10]
    mov bx, [bp+8]
    sub ax, [bp+6]
    sub bx, [bp+6]
    mov [bp-2], ax
    mov [bp-4], bx
    finit

@@row:
    fild word ptr [bp-2]
    fisub word ptr [bp+10]
    fist word ptr [bp-6]
    fimul word ptr [bp-6]
    
    fild word ptr [bp-4]
    fisub word ptr [bp+8]
    fist word ptr [bp-6]
    fimul word ptr [bp-6]
    
    fadd
    fsqrt
    fist word ptr [bp-6]

    mov ax, [bp-6]
    mov bx, [bp+6]
    cmp ax, bx
    jg @@continue

    mov ax, [bp-2]
    mov bx, [bp-4]
    mov cx, [bp+4]

    push ax
    push bx
    push cx
    call draw_pixel
    add sp, 6

@@continue:
    mov ax, [bp-2]
    mov bx, [bp+6]
    add bx, [bp+10]
    cmp ax, bx
    je @@end_row

    inc word ptr [bp-2]
    jmp @@row

@@end_row:
    mov ax, [bp+10]
    sub ax, [bp+6]
    mov [bp-2], ax

    mov ax, [bp-4]
    mov bx, [bp+6]
    add bx, [bp+8]
    inc bx
    cmp ax, bx
    je @@end_circle

    inc word ptr [bp-4]
    jmp @@row

@@end_circle:
    add sp, 6
    pop bp
    ret
endp draw_circle

; X1 Y1 X2 Y2 Color
proc draw_rectangle
    push bp
    mov bp, sp
    sub sp, 4
    mov ax, [bp+12]
    mov bx, [bp+10]
    mov [bp-2], ax
    mov [bp-4], bx
    
@@row:
    mov ax, [bp-2]
    mov bx, [bp-4]
    mov cx, [bp+4]

    push ax
    push bx
    push cx
    call draw_pixel
    add sp, 6

    mov ax, [bp-2]
    mov bx, [bp+8]
    cmp ax, bx
    je @@end_row

    inc word ptr [bp-2]
    jmp @@row

@@end_row:
    mov ax, [bp+12]
    mov [bp-2], ax

    mov ax, [bp-4]
    mov bx, [bp+6]
    inc bx
    cmp ax, bx
    je @@end_rectangle

    inc word ptr [bp-4]
    jmp @@row

@@end_rectangle:
    add sp, 4
    pop bp
    ret
endp draw_rectangle

d_graphics:
    mov ah,00
    mov al,03
    int 10h
    ret

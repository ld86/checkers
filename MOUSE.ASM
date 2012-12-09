LOCALS @@

proc c_mouse
    push bp
    mov bp, sp
    xor ax, ax
    int 33h

    call show_cursor

    mov ax, 0Ch
    mov cx, 2
    mov dx, offset mouse_handler
    int 33h

    pop bp
    ret
endp c_mouse

proc show_cursor
    mov ax, 1
    int 33h
    ret
endp show_cursor

proc hide_cursor
    mov ax, 2
    int 33h
    ret
endp hide_cursor

proc d_mouse
    push bp
    mov bp, sp
    mov ax, 0Ch
    xor cx, cx
    xor dx, dx
    int 33h

    pop bp
    ret
endp d_mouse

mouse_events_x dw 10 dup(0)
mouse_events_y dw 10 dup(0)

head_mouse_events dw 0
tail_mouse_events dw 0

proc mouse_handler
    pusha
    mov bx, tail_mouse_events
    mov word ptr mouse_events_x[bx], cx
    mov word ptr mouse_events_y[bx], dx
    inc tail_mouse_events

    cmp tail_mouse_events, 10
    jne @@end

    mov tail_mouse_events, 0
@@end:
    popa
    retf
endp mouse_handler



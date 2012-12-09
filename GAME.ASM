LOCALS @@

; X Y
proc get_cell_centr
    push bp
    mov bp, sp

    mov ax, [bp+6]
    mov bx, [bp+4]

    push ax
    push bx
    call get_cell_left_top
    add sp, 4

    add ax, 20
    add bx, 20

    pop bp
    ret
endp get_cell_centr

; X Y
proc get_cell_left_top
    push bp
    mov bp, sp
    sub sp, 6
    mov word ptr [bp-6], 41

    mov ax, [bp+6]
    imul word ptr [bp-6]
    add ax, 50
    mov [bp-2],ax

    mov ax, [bp+4]
    imul word ptr [bp-6]
    add ax, 50
    mov [bp-4],ax

    mov ax, [bp-2]
    mov bx, [bp-4]
    add sp, 6
    pop bp
    ret
endp get_cell_left_top

proc draw_border
    push bp
    mov bp, sp
    
    push 45
    push 45
    push 383
    push 383
    push 1
    call draw_rectangle
    add sp, 10

    pop bp
    ret
endp draw_border

proc draw_field
    push bp
    mov bp, sp
    sub sp, 6
    mov word ptr [bp-2], 0
    mov word ptr [bp-4], 0
    mov word ptr [bp-6], 7
    
    call draw_border
@@row:
    mov ax, [bp-2]
    mov bx, [bp-4]

    push ax
    push bx
    call get_cell_left_top
    add sp, 4

    push ax
    push bx
    add ax, 40
    add bx, 40
    push ax
    push bx
    mov ax, [bp-6]
    push ax
    call draw_rectangle
    add sp, 10

    mov ax, [bp-2]
    cmp ax, 7
    je @@end_row

    inc word ptr [bp-2]
    mov ax, 7
    sub ax, [bp-6]
    mov [bp-6], ax
    
    jmp @@row

@@end_row:
    mov word ptr [bp-2],0
    mov ax, [bp-4]
    cmp ax,7
    je @@end
    
    inc word ptr [bp-4]
    jmp @@row
      
@@end:
    add sp, 6
    pop bp
    ret
endp draw_field

; X Y Type
proc draw_chip
    push bp
    mov bp, sp
    
    mov ax, [bp+8]
    mov bx, [bp+6]

    push ax
    push bx
    call get_cell_centr
    add sp, 4

    push ax
    push bx
    push 20
    mov ax, [bp+4]
    push ax
    call draw_circle
    add sp, 8

    pop bp
    ret
endp draw_chip

; X Y
proc handle_mouse_click
    push bp
    mov bp, sp
    
    mov ax, [bp+6]
    mov bx, [bp+4]


    pop bp
    ret
endp handle_mouse_click

proc events_dispatcher
    push bp
    mov bp, sp

@@dispatch:
    mov ah, 1
    int 16h
    jnz @@end

    mov ax, head_mouse_events
    mov bx, tail_mouse_events
    
    cmp ax, bx
    je @@dispatch

    mov bx, head_mouse_events
    mov cx, word ptr mouse_events_x[bx]
    mov dx, word ptr mouse_events_y[bx]

    push cx
    push dx
    call handle_mouse_click
    add sp, 4

    inc head_mouse_events
    cmp head_mouse_events, 10
    jne @@dispatch

    mov head_mouse_events, 0
    jmp @@dispatch

@@end:
    pop bp
    ret
endp events_dispatcher

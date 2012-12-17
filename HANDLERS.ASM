LOCALS @@

proc check_and_highlight
    push bp
    mov bp, sp
    
    mov ax, [bp+6]
    mov bx, [bp+4]

    push ax
    push bx
    call get_color
    add sp, 4

    cmp ax, main_game_color
    jne @@end

    mov ax, [bp+6]
    mov bx, [bp+4]    

    mov choosen_x, ax
    mov choosen_y, bx

    push ax
    push bx
    call highlight_cell
    call redraw_chip
    add sp, 4

    mov game_state, 103

@@end:
    pop bp
    ret
endp check_and_highlight

proc highlight_or_make
    push bp
    mov bp, sp

    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    call get_color
    add sp, 4

    cmp ax, main_game_color
    jne @@try_make

    mov ax, choosen_x
    mov bx, choosen_y

    push ax
    push bx
    call redraw_cell
    call redraw_chip
    add sp, 4

    mov ax, [bp+6]
    mov bx, [bp+4]
    mov choosen_x, ax
    mov choosen_y, bx

    push ax
    push bx
    call highlight_cell
    call redraw_chip
    add sp, 4

    jmp @@end
@@try_make:
    mov ax, choosen_x
    mov bx, choosen_y
    push ax
    push bx
    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx    
    call is_allow_make
    add sp, 8

    cmp ax, 1
    jne @@end

    sub sp, 8
    call make
    add sp, 8

    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    call is_final_position   
    add sp, 4

    cmp ax, 1
    jne @@end    

    mov al, 'C'
    call Out_Chr

    mov game_state, 104
@@end:
    pop bp
    ret
endp highlight_or_make
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

    cmp ax, king_game_color
    je @@ok_chip
    cmp ax, main_game_color
    jne @@end    

@@ok_chip:
    push word ptr [bp+6]
    push word ptr [bp+4]

    call is_maybe
    add sp, 4

    cmp ax, 1
    jne @@end

    mov ax, [bp+6]
    mov bx, [bp+4]    

    mov moves_pointer, 1
    mov moves_x[0], ax
    mov moves_y[0], bx

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

    cmp ax, king_game_color
    je @@ok_chip
    cmp ax, main_game_color
    jne @@try_make

@@ok_chip:
    mov ax, choosen_x
    mov bx, choosen_y

    push ax
    push bx
    call redraw_cell
    call redraw_chip
    add sp, 4

    push word ptr [bp+6]
    push word ptr [bp+4]

    call is_maybe
    add sp, 4

    cmp ax, 1
    jne @@end

    mov ax, [bp+6]
    mov bx, [bp+4]
    mov choosen_x, ax
    mov choosen_y, bx

    mov moves_pointer, 1
    mov moves_x[0], ax
    mov moves_y[0], bx

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
    call add_move
    call make
    add sp, 8

    mov ax, [bp+4]
    cmp ax, where_king
    jne @@not_king

    push word ptr [bp+6]
    push word ptr [bp+4]
    push king_game_color
    call set_color
    add sp, 2

    call redraw_chip
    add sp, 4
@@not_king:

    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    call is_final_position   
    add sp, 4

    cmp ax, 1
    jne @@continue_move

    call flush
    mov game_state, 105
    jmp @@end

@@continue_move:
    push word ptr [bp+6]
    push word ptr [bp+4]
    call highlight_cell
    call redraw_chip
    add sp, 4

    mov ax, [bp+6]
    mov bx, [bp+4]
    mov choosen_x, ax
    mov choosen_y, bx

    mov game_state, 104

@@end:

    call counts_chip    
    cmp al, 0
    jne @@final_end
    call lose
    mov game_state, 106
    jmp @@final_end

@@final_end:
    pop bp
    ret
endp highlight_or_make

proc only_make
    push bp
    mov bp, sp

    mov ax, choosen_x
    mov bx, choosen_y
    push ax
    push bx
    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx    
    call is_allow_make_cut
    add sp, 8

    cmp ax, 1
    jne @@end

    sub sp, 8
    call add_move
    call make
    add sp, 8

    mov ax, [bp+4]
    cmp ax, where_king
    jne @@not_king

    push word ptr [bp+6]
    push word ptr [bp+4]
    push king_game_color
    call set_color
    add sp, 2

    call redraw_chip
    add sp, 4
@@not_king:

    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    call is_final_position   
    add sp, 4

    cmp ax, 1
    jne @@continue_move

    call flush
    mov game_state, 105
    jmp @@end

@@continue_move:
    push word ptr [bp+6]
    push word ptr [bp+4]
    call highlight_cell
    call redraw_chip
    add sp, 4

    mov ax, [bp+6]
    mov bx, [bp+4]
    mov choosen_x, ax
    mov choosen_y, bx
@@end:

    call counts_chip    
    cmp al, 0
    jne @@final_end
    call lose
    mov game_state, 106
    jmp @@final_end

@@final_end:
    pop bp
    ret
endp only_make

choosen_x dw 0
choosen_y dw 0  

moves_x dw 81 dup(0)
moves_y dw 81 dup(0)

moves_pointer dw 0

; X [bp+6]
; Y [bp+4]
proc add_move
    push bp
    mov bp, sp

    mov ax, [bp+6]
    mov cx, [bp+4]

    mov bx, moves_pointer

    mov moves_x[bx], ax
    mov moves_y[bx], cx

    inc moves_pointer

    pop bp
    ret
endp add_move

proc flush
    push bp
    mov bp, sp    
    mov timer_lock, 1
    sub sp, 2

    mov al, 'C'
    call Out_Chr

    mov al, '0'
    call Out_Chr

    mov ax, moves_pointer
    shl ax, 1
    add al, '0'
    call Out_Chr

    mov word ptr [bp-2], 0

@@loop:
    mov bx, [bp-2]
    cmp bx, moves_pointer
    je @@end

    mov ax, moves_x[bx]
    mov dx, moves_y[bx]

    push ax
    push dx
    call convert_coords
    add sp, 4

    push ax
    mov al, ah
    call Out_Chr

    pop ax
    call Out_Chr

    inc word ptr [bp-2]
    jmp @@loop

@@end:
    mov moves_pointer, 0

    add sp, 2    
    mov timer_lock, 0
    pop bp
    ret
endp flush


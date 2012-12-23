LOCALS @@
; 50 50
; 378 378

cell_size dw 41
cell_half_size dw 20
chip_r dw 15
xy_left dw 50
xy_right dw 378

white_or_black db 0
main_game_color dw 0Fh
king_game_color dw 0Eh

evil_main_game_color dw 7h
evil_king_game_color dw 6

where_king dw 0
evil_where_king dw 7

game_state dw 100
; 100 - waiting for players
; 101 - start game
; 102 - choose chip
; 103 - move chip
; 104 - continue move
; 105 - evil turn

table_colors    db 0Fh,0,0Fh,0,0Fh,0,0Fh,0
                db 0,0Fh,0,0Fh,0,0Fh,0,0Fh
                db 0Fh,0,0Fh,0,0Fh,0,0Fh,0
                db 0,0Fh,0,0Fh,0,0Fh,0,0Fh
                db 0Fh,0,0Fh,0,0Fh,0,0Fh,0
                db 0,0Fh,0,0Fh,0,0Fh,0,0Fh
                db 0Fh,0,0Fh,0,0Fh,0,0Fh,0
                db 0,0Fh,0,0Fh,0,0Fh,0,0Fh

table_addr  dw 0

;white_table db 0FFh,7,0FFh,7,0FFh,7,0FFh,7
;            db 7,0FFh,7,0FFh,7,0FFh,7,0FFh
;            db 0FFh,7,0FFh,7,0FFh,7,0FFh,7

white_table db 0FFh,0FFh,0FFh,7,0FFh,7,0FFh,7
            db 0Fh,0FFh,7,0FFh,7,0FFh,7,0FFh
            db 0FFh,7,0FFh,0FFh,0FFh,7,0FFh,7
            db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
            db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
            db 0Fh,0FFh,0Fh,0FFh,0Fh,0FFh,0Fh,0FFh
            db 0FFh,0Fh,0FFh,0Fh,0FFh,0Fh,0FFh,7 
            db 0Fh,0FFh,0Fh,0FFh,0Fh,0FFh,0FFh,0FFh
;            db 0FFh,0Fh,0FFh,0Fh,0FFh,0Fh,0FFh,0Fh 
;            db 0Fh,0FFh,0Fh,0FFh,0Fh,0FFh,0Fh,0FFh
            
;black_table db 0FFh,0Fh,0FFh,0Fh,0FFh,0Fh,0FFh,0Fh 
;            db 0Fh,0FFh,0Fh,0FFh,0Fh,0FFh,0Fh,0FFh

black_table db 0FFh,0FFh,0FFh,0Fh,0FFh,0Fh,0FFh,0Fh 
            db 7,0FFh,0Fh,0FFh,0Fh,0FFh,0Fh,0FFh
            db 0FFh,0Fh,0FFh,0Fh,0FFh,0Fh,0FFh,0Fh 
            db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
            db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
            db 7,0FFh,7,0FFh,0FFh,0FFh,7,0FFh
            db 0FFh,7,0FFh,7,0FFh,7,0FFh,0Fh
            db 7,0FFh,7,0FFh,7,0FFh,0FFh,0FFh
;            db 7,0FFh,7,0FFh,7,0FFh,0FFh,0FFh
;            db 0FFh,7,0FFh,7,0FFh,7,0FFh,7
;            db 7,0FFh,7,0FFh,7,0FFh,7,0FFh

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

    add ax, cell_half_size
    add bx, cell_half_size

    pop bp
    ret
endp get_cell_centr

; X Y
proc get_cell_left_top
    push bp
    mov bp, sp
    sub sp, 4

    mov ax, [bp+6]
    imul cell_size
    add ax, xy_left
    mov [bp-2],ax
    
    mov ax, [bp+4]
    imul cell_size
    add ax, xy_left
    mov [bp-4],ax

    mov ax, [bp-2]
    mov bx, [bp-4]
    add sp, 4
    pop bp
    ret
endp get_cell_left_top

proc draw_border
    push bp
    mov bp, sp
    
    mov ax, xy_left
    sub ax, 5
    push ax
    push ax
    mov ax, xy_right
    add ax, 5
    push ax
    push ax
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
    mov word ptr [bp-6], 0Fh
    
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
    add ax, cell_size
    add bx, cell_size
    dec ax
    dec bx
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
    mov ax, 0Fh
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
    push chip_r
    mov ax, [bp+4]
    push ax
    call draw_circle
    add sp, 8

    pop bp
    ret
endp draw_chip

; X Y
proc get_cell_by_click
    push bp
    mov bp, sp
    sub sp, 4
    mov word ptr [bp-2], 0FFFFh
    mov word ptr [bp-4], 0FFFFh

    mov ax, [bp+6]
    cmp ax, xy_left
    jng @@end
    cmp ax, xy_right
    jg @@end

    sub ax, xy_left
    mov bx, cell_size
    idiv bl
    xor ah, ah
    mov [bp-2], ax
    
    mov ax, [bp+4]
    cmp ax, xy_left
    jng @@end
    cmp ax, xy_right
    jg @@end
    
    sub ax, xy_left
    mov bx, cell_size
    idiv bl
    xor ah, ah
    mov [bp-4], ax   
@@end:
    mov ax, [bp-2]
    mov bx, [bp-4]

    add sp, 4
    pop bp
    ret
endp get_cell_by_click

proc highlight_cell
    push bp
    mov bp, sp
    
    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    call get_cell_left_top
    add sp,4

    push ax
    push bx
    add ax, cell_size
    add bx, cell_size
    dec ax
    dec bx
    push ax
    push bx
    push 3
    call draw_rectangle
    add sp, 10

    pop bp
    ret
endp highlight_cell

; X Y
proc handle_mouse_click
    push bp
    mov bp, sp
    call hide_cursor

    mov ax, [bp+6]
    mov bx, [bp+4]

    push ax
    push bx
    call get_cell_by_click
    add sp, 4

    cmp ax, 0FFFFh
    je @@end
    cmp bx, 0FFFFh
    je @@end

    cmp game_state, 102
    je @@highlight_and_check
    cmp game_state, 103
    je @@highlight_or_make
    cmp game_state, 104
    je @@only_make
    jmp @@end

@@highlight_and_check:
    push ax
    push bx
    call check_and_highlight
    add sp, 4
    jmp @@end


@@highlight_or_make:
    push ax
    push bx
    call highlight_or_make
    add sp, 4
    jmp @@end

@@only_make:
    push ax
    push bx
    call only_make
    add sp, 4
    jmp @@end

@@end:
    call show_cursor
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


    cmp game_state, 100
    je @@waiting_for_player 

    cmp game_state, 101
    je @@start_game

    cmp game_state, 105
    je @@evil_turn

    call Get_Chr
    jc @@empty_com
    
@@empty_com:
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

@@waiting_for_player:
    call waiting_for_player
    jmp @@dispatch

@@start_game:
    xor ax, ax
    mov al, white_or_black
    push ax
    call start_game
    add sp, 2
    jmp @@dispatch

@@evil_turn:
    call evil_turn
    jmp @@dispatch

@@end:
    pop bp
    ret
endp events_dispatcher

; X Y
proc redraw_cell
    push bp
    mov bp, sp

    mov ax, [bp+6]
    mov bx, [bp+4]

    push ax
    push bx
    call get_cell_left_top
    add sp, 4

    push ax
    push bx
    add ax, cell_size
    add bx, cell_size
    dec ax
    dec bx
    push ax
    push bx

    mov ax, [bp+4]
    mov bx, 8
    imul bl
    add ax, [bp+6]
    mov bx, ax
    add bx, offset table_colors
    mov cl, byte ptr [bx]
    xor ch, ch

    push cx
    call draw_rectangle
    add sp, 10 
    pop bp
    ret
endp redraw_cell

; X Y
proc redraw_chip
    push bp
    mov bp, sp

    mov ax, [bp+4]
    mov bx, 8
    imul bx
    add ax, [bp+6]
    mov bx, ax
    add bx, table_addr
    mov cl, byte ptr [bx]
    xor ch, ch
    cmp cl, 0FFh
    je @@end

    mov ax, [bp+6]
    mov bx, [bp+4]

    push ax
    push bx
    push cx
    call draw_chip
    add sp, 6

@@end:
    pop bp
    ret
endp redraw_chip

; Table
proc redraw_chips
    push bp
    mov bp, sp
    sub sp, 4

    mov word ptr [bp-2], 0
    mov word ptr [bp-4], 0

@@row:
    mov ax, [bp-4]
    mov bx, 8
    imul bl
    add ax, [bp-2]
    
    mov bx, [bp+4]
    add bx, ax
    mov cl, byte ptr [bx] 
    xor ch, ch
    cmp cl, 0FFh
    je @@next_in_row


    mov ax, [bp-2]
    mov bx, [bp-4]

    push ax
    push bx
    push cx
    call draw_chip
    add sp, 6

@@next_in_row:
    mov ax, [bp-2]
    cmp ax, 7
    je @@end_row
    inc word ptr [bp-2]
    jmp @@row

@@end_row:
    mov word ptr [bp-2],0
    inc word ptr [bp-4]

    mov ax, [bp-4]
    cmp ax, 8
    je @@end

    jmp @@row   

@@end:
    add sp, 4
    pop bp
    ret
endp redraw_chips

; 0 - White, 1 - Black
proc start_game
    push bp
    mov bp, sp
 
    call clear_screen   
    mov table_addr, offset white_table
    mov game_state, 102
    mov ax, [bp+4]
    test ax, ax
    je @@next
    mov table_addr, offset black_table
    mov main_game_color, 7h
    mov king_game_color, 6
    mov evil_main_game_color, 0Fh
    mov evil_king_game_color, 0Eh
    mov game_state, 105
@@next:
    call draw_field
    
    push 3
    push 4
    call redraw_cell
    add sp, 4

    push table_addr
    call redraw_chips
    add sp, 2
    
    pop bp
    ret
endp start_game

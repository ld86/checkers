LOCALS @@

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

; X To      [bp+6]
; Y To      [bp+4]
proc is_maybe
    push bp
    mov bp, sp
    sub sp, 4

    push word ptr [bp+6]
    push word ptr [bp+4]
    call get_color
    add sp, 4
    cmp ax, king_game_color
    je @@true

    push word ptr [bp+6]
    push word ptr [bp+4]
    call check_left_top
    add sp, 4
    cmp ax, 1
    je @@true

    push word ptr [bp+6]
    push word ptr [bp+4]
    call check_right_top
    add sp, 4
    cmp ax, 1
    je @@true

    push word ptr [bp+6]
    push word ptr [bp+4]
    call check_left_bottom
    add sp, 4
    cmp ax, 1
    je @@true

    push word ptr [bp+6]
    push word ptr [bp+4]
    call check_right_bottom
    add sp, 4
    cmp ax, 1
    je @@true

    mov word ptr [bp-2], 0
    mov word ptr [bp-4], 0

@@row_loop:
    cmp word ptr [bp-4], 8
    je @@true

    push word ptr [bp-2]
    push word ptr [bp-4]
    call get_color
    add sp, 4

    cmp ax, main_game_color
    je @@test
    cmp ax, king_game_color
    je @@test
    jmp @@continue

@@test:
    push word ptr [bp-2]
    push word ptr [bp-4]
    call check_left_top
    add sp, 4
    cmp ax, 1
    je @@false

    push word ptr [bp-2]
    push word ptr [bp-4]
    call check_right_top
    add sp, 4
    cmp ax, 1
    je @@false

    push word ptr [bp-2]
    push word ptr [bp-4]
    call check_left_bottom
    add sp, 4
    cmp ax, 1
    je @@false

    push word ptr [bp-2]
    push word ptr [bp-4]
    call check_right_bottom
    add sp, 4
    cmp ax, 1
    je @@false

@@continue:
    inc word ptr [bp-2]
    cmp word ptr [bp-2], 8
    je @@new_row
    jmp @@row_loop

@@new_row:
    mov word ptr [bp-2], 0
    inc word ptr [bp-4]
    jmp @@row_loop

@@true:
    mov ax, 1
    jmp @@end
@@false:
    xor ax, ax
@@end:
    
    add sp, 4
    pop bp
    ret
endp is_maybe

; X To      [bp+6]
; Y To      [bp+4]
proc check_left_top
    push bp
    mov bp, sp

    mov ax, [bp+6]
    mov bx, [bp+4]

    cmp ax, 2
    jl @@false
    cmp bx, 2
    jl @@false

    dec ax
    dec bx

    push ax
    push bx
    call get_color
    add sp, 4

    cmp ax, evil_main_game_color
    je @@continue
    cmp ax, evil_king_game_color
    je @@continue
    jmp @@false

@@continue:
    mov ax, [bp+6]
    mov bx, [bp+4]
    sub ax, 2
    sub bx, 2

    push ax
    push bx
    call get_color
    add sp, 4

    cmp al, 0FFh
    je @@true
    jmp @@false

@@true:
    mov ax, 1
    jmp @@end
@@false:
    xor ax, ax
@@end:
    pop bp
    ret
endp check_left_top

; X To      [bp+6]
; Y To      [bp+4]
proc check_right_top
    push bp
    mov bp, sp

    mov ax, [bp+6]
    mov bx, [bp+4]

    cmp ax, 5
    jg @@false
    cmp bx, 2
    jl @@false

    inc ax
    dec bx

    push ax
    push bx
    call get_color
    add sp, 4

    cmp ax, evil_main_game_color
    je @@continue
    cmp ax, evil_king_game_color
    je @@continue
    jmp @@false

@@continue:
    mov ax, [bp+6]
    mov bx, [bp+4]
    add ax, 2
    sub bx, 2

    push ax
    push bx
    call get_color
    add sp, 4

    cmp al, 0FFh
    je @@true
    jmp @@false

@@true:
    mov ax, 1
    jmp @@end
@@false:
    xor ax, ax
@@end:
    pop bp
    ret
endp check_right_top

; X To      [bp+6]
; Y To      [bp+4]
proc check_left_bottom
    push bp
    mov bp, sp

    mov ax, [bp+6]
    mov bx, [bp+4]

    cmp ax, 2
    jl @@false
    cmp bx, 5
    jg @@false

    dec ax
    inc bx

    push ax
    push bx
    call get_color
    add sp, 4

    cmp ax, evil_main_game_color
    je @@continue
    cmp ax, evil_king_game_color
    je @@continue
    jmp @@false

@@continue:
    mov ax, [bp+6]
    mov bx, [bp+4]
    sub ax, 2
    add bx, 2

    push ax
    push bx
    call get_color
    add sp, 4

    cmp al, 0FFh
    je @@true
    jmp @@false

@@true:
    mov ax, 1
    jmp @@end
@@false:
    xor ax, ax
@@end:
    pop bp
    ret
endp check_left_bottom

; X To      [bp+6]
; Y To      [bp+4]
proc check_right_bottom
    push bp
    mov bp, sp

    mov ax, [bp+6]
    mov bx, [bp+4]

    cmp ax, 5
    jg @@false
    cmp bx, 5
    jg @@false

    inc ax
    inc bx

    push ax
    push bx
    call get_color
    add sp, 4

    cmp ax, evil_main_game_color
    je @@continue
    cmp ax, evil_king_game_color
    je @@continue
    jmp @@false

@@continue:
    mov ax, [bp+6]
    mov bx, [bp+4]
    add ax, 2
    add bx, 2

    push ax
    push bx
    call get_color
    add sp, 4

    cmp al, 0FFh
    je @@true
    jmp @@false

@@true:
    mov ax, 1
    jmp @@end
@@false:
    xor ax, ax
@@end:
    pop bp
    ret
endp check_right_bottom

; X To      [bp+6]
; Y To      [bp+4]
proc is_final_position
    push bp
    mov bp, sp    

    cmp last_check_type, 0
    je @@true    

    push word ptr [bp+6]
    push word ptr [bp+4]
    call check_left_top
    add sp, 4
    cmp ax, 1
    je @@false

    push word ptr [bp+6]
    push word ptr [bp+4]
    call check_right_top
    add sp, 4
    cmp ax, 1
    je @@false

    push word ptr [bp+6]
    push word ptr [bp+4]
    call check_left_bottom
    add sp, 4
    cmp ax, 1
    je @@false

    push word ptr [bp+6]
    push word ptr [bp+4]
    call check_right_bottom
    add sp, 4
    cmp ax, 1
    je @@false

    jmp @@true

@@true:
    mov ax, 1
    jmp @@end

@@false:
    xor ax, ax
    jmp @@end

@@end:
    pop bp
    ret
endp is_final_position

last_check_type db 0
direction db 0
; X From    [bp+10]
; Y From    [bp+8]
; X To      [bp+6]
; Y To      [bp+4]
proc make
    push bp
    mov bp, sp    
    
    push word ptr [bp+10]
    push word ptr [bp+8]
    call get_color
    add sp, 4
    mov dx, ax

    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    push dx
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
    
    cmp last_check_type, 2
    jne @@next_check_type


    cmp direction, 0
    je @@right_top
    cmp direction, 1
    je @@left_top
    cmp direction, 2
    je @@right_bottom
    cmp direction, 3
    je @@left_bottom
    jmp @@end    

@@right_top:
    mov ax, [bp+10]
    mov bx, [bp+8]
@@right_top_loop:
    push ax
    push bx
    push 0FFh
    call set_color
    add sp, 2
    call redraw_cell
    pop bx
    pop ax

    cmp ax, [bp+6]
    jne @@right_top_loop_continue
    cmp bx, [bp+4]
    jne @@right_top_loop_continue

    push ax
    push bx
    push king_game_color
    call set_color
    add sp, 2
    call redraw_cell
    call redraw_chip
    add sp, 4

    jmp @@end
@@right_top_loop_continue:
    inc ax
    dec bx
    jmp @@right_top_loop

@@left_top:
    mov ax, [bp+10]
    mov bx, [bp+8]
@@left_top_loop:
    push ax
    push bx
    push 0FFh
    call set_color
    add sp, 2
    call redraw_cell
    pop bx
    pop ax

    cmp ax, [bp+6]
    jne @@left_top_loop_continue
    cmp bx, [bp+4]
    jne @@left_top_loop_continue

    push ax
    push bx
    push king_game_color
    call set_color
    add sp, 2
    call redraw_cell
    call redraw_chip
    add sp, 4

    jmp @@end
@@left_top_loop_continue:
    dec ax
    dec bx
    jmp @@left_top_loop
    jmp @@end

@@right_bottom:
    push 'BB'
    call bad_protocol
    add sp, 2


    mov ax, [bp+10]
    mov bx, [bp+8]
@@right_bottom_loop:
    push ax
    push bx
    push 0FFh
    call set_color
    add sp, 2
    call redraw_cell
    pop bx
    pop ax

    cmp ax, [bp+6]
    jne @@right_bottom_loop_continue
    cmp bx, [bp+4]
    jne @@right_bottom_loop_continue

    push ax
    push bx
    push king_game_color
    call set_color
    add sp, 2
    call redraw_cell
    call redraw_chip
    add sp, 4

    jmp @@end
@@right_bottom_loop_continue:
    inc ax
    inc bx
    jmp @@right_bottom_loop
    jmp @@end

@@left_bottom:
    mov ax, [bp+10]
    mov bx, [bp+8]
@@left_bottom_loop:
    push ax
    push bx
    push 0FFh
    call set_color
    add sp, 2
    call redraw_cell
    pop bx
    pop ax

    cmp ax, [bp+6]
    jne @@left_bottom_loop_continue
    cmp bx, [bp+4]
    jne @@left_bottom_loop_continue

    push ax
    push bx
    push king_game_color
    call set_color
    add sp, 2
    call redraw_cell
    call redraw_chip
    add sp, 4

    jmp @@end
@@left_bottom_loop_continue:
    dec ax
    inc bx
    jmp @@left_bottom_loop
    jmp @@end

@@next_check_type:
    cmp last_check_type, 1
    jne @@end

    mov ax, [bp+10]
    add ax, [bp+6]
    shr ax, 1

    mov bx, [bp+8]
    add bx, [bp+4]
    shr bx, 1

    push ax
    push bx
    push 0FFh
    call set_color
    add sp, 2
    call redraw_cell
    add sp, 4

@@end:
    pop bp
    ret
endp make


evils db 0
my db 0

; X From    [bp+10]
; Y From    [bp+8]
; X To      [bp+6]
; Y To      [bp+4]
proc is_allow_make
    push bp
    mov bp, sp

    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    call get_color
    add sp, 4
    cmp al, 0FFh
    jne @@false

    push word ptr [bp+10]
    push word ptr [bp+8]
    call get_color
    add sp, 4
    xor ah, ah
    cmp ax, king_game_color
    je @@king_check

    mov ax, [bp+10]
    mov bx, [bp+6]
    sub ax, bx
    cmp ax, -2
    je @@stub
    cmp ax, 2
    jne @@move
@@stub:
    mov ax, [bp+8]
    mov bx, [bp+4]
    sub ax, bx
    cmp ax, -2
    je @@cut
    cmp ax, 2
    jne @@move
    jmp @@cut

@@move:
    mov last_check_type, 0

    mov ax, [bp+8]
    sub ax, [bp+4]
    cmp ax, 1
    jne @@false

    mov ax, [bp+10]
    sub ax, [bp+6]
    cmp ax, 1
    je @@true
    cmp ax, -1
    jne @@false

    jmp @@true

@@cut:
    mov last_check_type, 1

    mov ax, [bp+10]
    add ax, [bp+6]
    shr ax, 1

    mov bx, [bp+8]
    add bx, [bp+4]
    shr bx, 1

    push ax
    push bx
    call get_color
    add sp, 4

    cmp ax, evil_main_game_color
    je @@true
    cmp ax, evil_king_game_color
    jne @@false
    jmp @@true

@@king_check:
    mov last_check_type, 2

    mov evils, 0
    mov my, 0

    mov ax, [bp+8]
    cmp ax, [bp+4]
    jl @@bottom 

    cmp ax, [bp+4]
    jg @@top
    jmp @@false

@@top:
    mov ax, [bp+10]
    cmp ax, [bp+6]
    jg @@left_top

    cmp ax, [bp+6]
    jl @@right_top
    jmp @@false

@@bottom:
    mov ax, [bp+10]
    cmp ax, [bp+6]
    jg @@left_bottom
    
    cmp ax, [bp+6]
    jl @@right_bottom
    jmp @@false   

@@right_top:
    mov ax, [bp+10]
    mov bx, [bp+8]
        
@@right_top_loop:
    cmp ax, 8
    je @@false
    cmp bx, -1
    je @@false

    push ax
    push bx
    call get_color
    cmp ax, main_game_color
    je @@rtm
    cmp ax, king_game_color
    je @@rtm
    cmp ax, evil_main_game_color
    je @@rte
    cmp ax, evil_king_game_color
    je @@rte
    jmp @@rt
@@rtm:
    inc my
    jmp @@rt
@@rte:
    inc evils
    jmp @@rt
@@rt:
    pop bx
    pop ax

    cmp ax, [bp+6]
    jne @@right_top_loop_continue
    cmp bx, [bp+4]
    jne @@right_top_loop_continue
    
    mov direction, 0
    jmp @@king_final_check
@@right_top_loop_continue:
    inc ax
    dec bx 
    jmp @@right_top_loop

    jmp @@false

@@left_top:
    mov ax, [bp+10]
    mov bx, [bp+8]
        
@@left_top_loop:
    cmp ax, -1
    je @@false
    cmp bx, -1
    je @@false

    push ax
    push bx
    call get_color
    cmp ax, main_game_color
    je @@ltm
    cmp ax, king_game_color
    je @@ltm
    cmp ax, evil_main_game_color
    je @@lte
    cmp ax, evil_king_game_color
    je @@lte
    jmp @@lt
@@ltm:
    inc my
    jmp @@lt
@@lte:
    inc evils
    jmp @@lt
@@lt:
    pop bx
    pop ax

    cmp ax, [bp+6]
    jne @@left_top_loop_continue
    cmp bx, [bp+4]
    jne @@left_top_loop_continue
    
    mov direction, 1
    jmp @@king_final_check
@@left_top_loop_continue:
    dec ax
    dec bx 
    jmp @@left_top_loop

    jmp @@false

@@right_bottom:
    mov ax, [bp+10]
    mov bx, [bp+8]
        
@@right_bottom_loop:
    cmp ax, 8
    je @@false
    cmp bx, 8
    je @@false

    push ax
    push bx
    call get_color
    cmp ax, main_game_color
    je @@rbm
    cmp ax, king_game_color
    je @@rbm
    cmp ax, evil_main_game_color
    je @@rbe
    cmp ax, evil_king_game_color
    je @@rbe
    jmp @@rb
@@rbm:
    inc my
    jmp @@rb
@@rbe:
    inc evils
    jmp @@rb
@@rb:
    pop bx
    pop ax

    cmp ax, [bp+6]
    jne @@right_bottom_loop_continue
    cmp bx, [bp+4]
    jne @@right_bottom_loop_continue

    mov direction, 2
    jmp @@king_final_check
@@right_bottom_loop_continue:
    inc ax
    inc bx 
    jmp @@right_bottom_loop

    jmp @@false

@@left_bottom:
    mov ax, [bp+10]
    mov bx, [bp+8]
        
@@left_bottom_loop:
    cmp ax, -1
    je @@false
    cmp bx, 8
    je @@false

    push ax
    push bx
    call get_color
    cmp ax, main_game_color
    je @@lbm
    cmp ax, king_game_color
    je @@lbm
    cmp ax, evil_main_game_color
    je @@lbe
    cmp ax, evil_king_game_color
    je @@lbe
    jmp @@lb
@@lbm:
    inc my
    jmp @@lb
@@lbe:
    inc evils
    jmp @@lb
@@lb:
    pop bx
    pop ax

    cmp ax, [bp+6]
    jne @@left_bottom_loop_continue
    cmp bx, [bp+4]
    jne @@left_bottom_loop_continue
    
    mov direction, 3
    jmp @@king_final_check
@@left_bottom_loop_continue:
    dec ax
    inc bx 
    jmp @@left_bottom_loop

    jmp @@false

@@king_final_check:
    cmp my, 1
    jne @@false
    cmp evils, 1
    jle @@true
    jmp @@false

@@true:
    mov ax, 1
    jmp @@end

@@false:
    xor ax, ax
    jmp @@end

@@end:
    pop bp
    ret
endp is_allow_make

; Column [bp+6]
; Row [bp+4]
proc convert_coords
    push bp
    mov bp, sp

    cmp white_or_black, 0
    je @@white
    jmp @@black 

@@white:
    mov ax, [bp+6]
    add al, 'A'
    
    mov bx, [bp+4]
    mov cl, '8'
    sub cl, bl
    mov bl, cl
    
    mov ah, al
    mov al, bl
    jmp @@end

@@black:
    mov ax, [bp+6]
    mov bl, 'H'
    sub bl, al
    mov al, bl

    mov bx, [bp+4]
    add bl, '1'
    
    mov ah, al
    mov al, bl
    jmp @@end


@@end:
    pop bp
    ret
endp convert_coords

; A1    [bp+4]
proc back_convert_coords
    push bp
    mov bp, sp

    cmp white_or_black, 0
    je @@white
    jmp @@black

@@white:
    mov ax, [bp+4]
    sub ah, 'A'
    mov bl, '8'
    sub bl, al
    mov al, bl
    jmp @@end

@@black:
    mov ax, [bp+4]
    mov bl, 'H'
    sub bl, ah
    mov ah, bl 
    sub al, '1'
    jmp @@end


@@end:
    pop bp
    ret
endp back_convert_coords

proc evil_turn
    push bp
    mov bp, sp
    sub sp, 6

    call Get_Chr    
    jc @@end

    cmp al, 'A'
    je @@end

    cmp al, 'C'
    je @@continue

    push ax
    call bad_protocol
    add sp, 2
    jmp @@end


@@continue:
    mov word ptr [bp-2], 0

@@loop:
    cmp word ptr [bp-2], 0
    je @@first_digit
    cmp word ptr [bp-2], 1
    je @@second_digit
    cmp word ptr [bp-2], 2
    je @@message
    cmp word ptr [bp-2], 3
    je @@check_and_move
    jmp @@end

@@first_digit:
    call Get_Chr    
    jc @@first_digit    

    mov ah, al
    mov word ptr [bp-4], ax
    mov word ptr [bp-2], 1
    jmp @@loop

@@second_digit:
    call Get_Chr    
    jc @@second_digit    

    mov bx, [bp-4]
    mov ah, bh
    mov [bp-4], ax
    mov word ptr [bp-2], 2   

    mov ax, [bp-4]
    xor ah, ah
    sub al, '0'
    mov [bp-4], ax

    jmp @@loop

@@message:
    mov word ptr [bp-6], 0
    mov ax, [bp-4]
    mov receive_turns_size, al   

@@message_loop:
    mov bx, [bp-6]
    cmp bx, [bp-4]
    je @@message_end

    call Get_Chr    
    jc @@message_loop  

    mov bx, [bp-6]
    mov receive_turns[bx], al

    inc word ptr [bp-6]
    jmp @@message_loop

@@message_end:
    mov word ptr [bp-2], 3
    jmp @@loop

@@check_and_move:
    mov al, receive_turns_size
    add al, '0'

    push ax
    call bad_protocol
    add sp, 2

    mov word ptr [bp-6], 0
@@check_loop:
    mov bx, [bp-6]    
    add bx, 2
    cmp bl, receive_turns_size
    je @@check_end

    
    mov bx, [bp-6]
    mov ah, receive_turns[bx]
    mov al, receive_turns[bx+1]    

    push ax
    call back_convert_coords
    add sp, 2

    mov bx, ax
    mov al, ah
    xor ah, ah    
    xor bh,bh
    push ax
    push bx 
   
    mov bx, [bp-6]
    mov ah, receive_turns[bx+2]
    mov al, receive_turns[bx+3]    

    push ax
    call back_convert_coords
    add sp, 2

    mov bx, ax
    mov al, ah
    xor ah, ah    
    xor bh, bh
    push ax
    push bx
    call is_evil_available
    add sp, 8

    cmp ax, 1
    jne @@bad_move

    sub sp, 8
    call evil_make

    pop bx
    pop ax
    add sp, 4

    cmp bx, evil_where_king
    jne @@check_loop_end

    push ax
    push bx
    push evil_king_game_color
    call set_color
    add sp, 2

    call redraw_chip
    add sp, 4

@@check_loop_end:

    add word ptr [bp-6], 2
    jmp @@check_loop

@@bad_move:
    mov al, 'D'
    call Out_Chr
    mov al, '1'
    call Out_Chr
    jmp @@end

@@check_end:
    jmp @@change_turn

@@change_turn:
    mov game_state, 102
    jmp @@end

@@end:
    add sp, 6
    pop bp
    ret
endp evil_turn

receive_turns_size db 0
receive_turns db 81 dup(0)

; X From    [bp+10]
; Y From    [bp+8]
; X To      [bp+6]
; Y To      [bp+4]
proc evil_make
    push bp
    mov bp, sp    
    
    push word ptr [bp+10]
    push word ptr [bp+8]
    call get_color
    add sp, 4
    mov dx, ax

    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    push dx
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
endp evil_make

; X From    [bp+10]
; Y From    [bp+8]
; X To      [bp+6]
; Y To      [bp+4]
proc is_evil_available
    push bp
    mov bp, sp

    push word ptr [bp+10]
    push word ptr [bp+8]
    call get_color
    add sp, 4
    xor ah, ah
    cmp ax, evil_king_game_color
    je @@true

    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    call get_color
    add sp, 4
    cmp al, 0FFh
    jne @@false

    mov ax, [bp+10]
    mov bx, [bp+6]
    sub ax, bx
    cmp ax, -2
    je @@stub
    cmp ax, 2
    jne @@move
@@stub:
    mov ax, [bp+8]
    mov bx, [bp+4]
    sub ax, bx
    cmp ax, -2
    je @@cut
    cmp ax, 2
    jne @@move
    jmp @@cut

@@move:
    mov ax, [bp+4]
    sub ax, [bp+8]
    cmp ax, 1
    jne @@false

    mov ax, [bp+10]
    sub ax, [bp+6]
    cmp ax, 1
    je @@true
    cmp ax, -1
    jne @@false

    jmp @@true

@@cut:
    mov ax, [bp+10]
    add ax, [bp+6]
    shr ax, 1

    mov bx, [bp+8]
    add bx, [bp+4]
    shr bx, 1

    push ax
    push bx
    call get_color
    add sp, 4

    cmp ax, main_game_color
    je @@cut_action
    cmp ax, king_game_color
    jne @@false

@@cut_action:
    sub sp, 4
    push 0FFh
    call set_color
    add sp, 2

    call redraw_cell
    add sp, 4

    jmp @@true

@@true:
    mov ax, 1
    jmp @@end

@@false:
    xor ax, ax
    jmp @@end

@@end:     
    pop bp
    ret
endp is_evil_available


; X From [bp+10]
; Y From [bp+8]
; X To   [bp+6]
; Y To   [bp+4]
proc is_allow_make_cut
    push bp
    mov bp, sp

    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    call get_color
    add sp, 4
    cmp al, 0FFh
    jne @@false

    mov ax, [bp+10]
    mov bx, [bp+6]
    sub ax, bx
    cmp ax, -2
    je @@stub
    cmp ax, 2
    jne @@false
@@stub:
    mov ax, [bp+8]
    mov bx, [bp+4]
    sub ax, bx
    cmp ax, -2
    je @@cut
    cmp ax, 2
    jne @@false
    jmp @@cut

@@cut:
    mov last_check_type, 1

    mov ax, [bp+10]
    add ax, [bp+6]
    shr ax, 1

    mov bx, [bp+8]
    add bx, [bp+4]
    shr bx, 1

    push ax
    push bx
    call get_color
    add sp, 4

    cmp ax, evil_main_game_color
    je @@true
    cmp ax, evil_king_game_color
    jne @@false
    jmp @@true

@@true:
    mov ax, 1
    jmp @@end

@@false:
    xor ax, ax
    jmp @@end

@@end:

    pop bp
    ret
endp is_allow_make_cut

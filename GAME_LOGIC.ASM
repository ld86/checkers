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
proc is_final_position
    push bp
    mov bp, sp    

    ;jmp @@false

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

; X From    [bp+10]
; Y From    [bp+8]
; X To      [bp+6]
; Y To      [bp+4]
proc make
    push bp
    mov bp, sp    
    
    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    mov ax, main_game_color
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
    je @@cut_action
    cmp ax, evil_king_game_color
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
    cmp bl, receive_turns_size
    je @@check_end

    
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
    push 0FFh   
    call set_color
    add sp, 2
    call redraw_cell
    add sp, 4

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
    push evil_main_game_color 
    call set_color
    add sp, 2
    call redraw_chip
    add sp, 4

    add word ptr [bp-6], 4
    jmp @@check_loop

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
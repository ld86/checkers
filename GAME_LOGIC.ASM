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

    mov ax, [bp+10]
    mov bx, [bp+6]
    sub ax, bx
    cmp ax, -2
    je @@cut
    cmp ax, 2
    je @@cut
    mov ax, [bp+8]
    mov bx, [bp+4]
    sib ax, bx
    cmp ax, -2
    je @@cut
    cmp ax, 2
    je @@cut

@@move:
    
    jmp @@end

@@cut:
    
    
    jmp @@end

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

; A [bp+6]
; 1 [bp+4]
proc back_convert_coords
    push bp
    mov bp, sp

    cmp white_or_black, 0
    je @@white
    jmp @@black

@@white:
    
    jmp @@end

@@black:
    jmp @@end


@@end:
    pop bp
    ret
endp back_convert_coords

proc evil_turn
    push bp
    mov bp, sp
    
    call Get_Chr    
    jc @@end

    cmp al, 'A'
    je @@end

    cmp al, 'C'
    je @@change_turn

    push ax
    call bad_protocol
    add sp, 2

    jmp @@end

@@change_turn:
    mov game_state, 102
    jmp @@end

@@end:
    pop bp
    ret
endp evil_turn

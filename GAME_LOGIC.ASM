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

    mov al, 'C'
    call Out_Chr
    mov al, '0'
    call Out_Chr
    mov al, '4'
    call Out_Chr

    mov ax, [bp+10]
    mov bx, [bp+8]
    push ax
    push bx
    call convert_coords
    add sp, 4

    push ax
    mov al, ah
    call Out_Chr

    pop ax
    call Out_Chr

    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    call convert_coords
    add sp, 4

    push ax
    mov al, ah
    call Out_Chr

    pop ax
    call Out_Chr


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
    mov bx, [bp+8]

    
    push ax
    push bx
    call get_available
    add sp, 4

    mov bx, 0
@@loop:
    cmp bl, available_count
    je @@false

    xor ax, ax
    xor dx, dx
    mov al, available_x[bx]
    mov dl, available_y[bx]

    cmp ax, [bp+6]
    jne @@continue_loop
    cmp dx, [bp+4]
    jne @@continue_loop

    jmp @@true

@@continue_loop:
    inc bx
    jmp @@loop

@@true:
    mov ax, 1
    jmp @@end
@@false:
    xor ax, ax
@@end:
    pop bp
    ret
endp is_allow_make

available_x db 64 dup(0) 
available_y db 64 dup(0)
available_count db 0

; X [bp+6]
; Y [bp+4]
proc get_available
    push bp
    mov bp, sp
    mov available_count, 0

    mov ax, [bp+6]
    mov bx, [bp+4]
    inc ax
    dec bx
    push ax
    push bx
    call try_near
    add sp, 4

    mov ax, [bp+6]
    mov bx, [bp+4]
    dec ax
    dec bx
    push ax
    push bx
    call try_near
    add sp, 4

    pop bp
    ret      
endp get_available

; X To [bp+10] 
; Y To [bp+8]
; X [bp+6]
; Y [bp+4]
proc try_near
    push bp
    mov bp, sp

    mov ax, [bp+6]
    cmp ax, 0
    jnge @@end
    cmp ax, 7
    jg @@end

    mov ax, [bp+4]
    cmp ax, 0
    jnge @@end
    cmp ax, 7
    jg @@end

    mov ax, [bp+6]
    mov bx, [bp+4]
    push ax
    push bx
    call get_color
    add sp, 4
    
    cmp al, 0FFh
    jne @@end

    mov ax, [bp+6]
    mov dx, [bp+4]
    xor bx, bx
    mov bl, available_count
    mov byte ptr available_x[bx], al
    mov byte ptr available_y[bx], dl
    inc available_count


@@end:
    pop bp
    ret
endp try_near

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

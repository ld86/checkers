LOCALS @@

proc waiting_for_player
    mov ah, 02h
    xor bh, bh
    mov dh, waiting_message_y
    mov dl, waiting_message_x
    int 10h
    mov ah, 09h
    mov dx, offset waiting_message
    int 21h

    call Get_Chr
    jc @@end
    
    cmp al,'A'
    je @@send_ssp
    
    cmp al,'B'
    je @@make_choose

    push ax
    call bad_protocol
    add sp, 2
    jmp @@end

@@send_ssp:
    cmp my_ssp, 3
    jne @@end

    call send_ssp

    jmp @@end

@@make_choose:
    cmp my_ssp, 3
    jne @@make_choose_next

    call send_ssp

@@make_choose_next:
    
    call Get_Chr
    jc @@make_choose_next

    sub al, '0'
    mov evil_ssp, al

    cmp my_ssp, al
    jne @@ok
    
    mov my_ssp, 3
    jmp @@end

@@ok:
    cmp my_ssp, 0
    je @@stone
    cmp my_ssp, 1
    je @@scissors
    cmp my_ssp, 2
    je @@paper

@@stone:
    cmp evil_ssp, 1
    je @@white
    jmp @@black
    
@@scissors:
    cmp evil_ssp, 2
    je @@white
    jmp @@black

@@paper:
    cmp evil_ssp, 0
    je @@white
    jmp @@black

@@white:
    mov white_or_black, 0
    mov game_state, 101
    jmp @@end

@@black:
    mov white_or_black, 1
    mov game_state, 101
    jmp @@end

@@end:
    ret
endp waiting_for_player

my_ssp db 3
evil_ssp db 3
waiting_message_x db 25
waiting_message_y db 15
waiting_message db 'Waiting for remote player...$'
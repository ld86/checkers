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

    mov ah, 02h
    xor bh, bh
    mov dh, 0
    mov dl, 0
    int 10h

    mov ah, 2
    mov dl, my_ssp
    add dl, '0'
    int 21h

    mov ah, 02h
    xor bh, bh
    mov dh, 1
    mov dl, 0
    int 10h

    mov ah, 2
    mov dl, evil_ssp
    add dl, '0'
    int 21h

    jmp @@end
@@end:
    ret
endp waiting_for_player

my_ssp db 3
evil_ssp db 3
waiting_message_x db 25
waiting_message_y db 15
waiting_message db 'Waiting for remote player...$'

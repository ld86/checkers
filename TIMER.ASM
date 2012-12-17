LOCALS @@

proc set_timer
    pusha
    mov ax, 3508h
    int 21h
    mov segm, es
    mov offs, bx

    mov ax, 2508h
    mov dx, offset timer_handler
    int 21h
    popa
    ret
endp set_timer

proc timer_handler
    pushf
    call dword ptr cs:[@@address]
    pusha
    push cs
    pop ds
    inc ant_syn_counter
    inc my_syn_counter
    cmp my_syn_counter, 18
    jl @@go
    mov my_syn_counter, 0
    mov al, 'A'
    call Out_Chr
@@go:
    popa    
    iret
@@address:    
    offs    dw  ?
    segm    dw  ?   
    my_syn_counter  dw 0
    ant_syn_counter dw 0
endp timer_handler

proc unset_timer
    pusha
    mov ax, segm
    mov dx, offs
    push ds
    push ax
    pop ds
    mov ax, 2508h
    int 21h
    pop ds
    popa
    ret
endp unset_timer

LOCALS @@

proc send_ssp
    push bp
    mov bp, sp
    sub sp, 2

    mov al, 'B'
    call Out_Chr
    
    call get_ssp
    mov my_ssp, al

    add al, '0'
    call Out_Chr

    add sp, 2
    pop bp
    ret
endp send_ssp



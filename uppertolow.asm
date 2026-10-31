.model small
.stack 100h
.code

main proc

    mov ah,1
    int 21h
    mov bl,al

    cmp bl,'A'
    jnge L2

    cmp bl,'Z'
    jnle L2

    jmp L1

L1:
    mov ah,2
    mov dl,bl
    add dl,32
    int 21h
    jmp exit

L2:
    mov ah,2
    mov dl,bl
    int 21h

exit:
    mov ah,4ch
    int 21h

main endp
end main

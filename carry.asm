.model small
.stack 100h

.data
msg db 'Carry Flag = $'

.code
main proc

    mov ax,@data
    mov ds,ax

    ; Addition
    mov al,0FAh
    add al,0AH

    ; Save Flag Register
    pushf
    pop bx

    ; Extract Carry Flag
    and bl,01h

    ; Display Message
    mov ah,9
    lea dx,msg
    int 21h

    ; Display Carry Flag
    cmp bl,1
    je carry

    mov ah,2
    mov dl,'0'
    int 21h
    jmp exit

carry:
    mov ah,2
    mov dl,'1'
    int 21h

exit:
    mov ah,4ch
    int 21h

main endp
end main

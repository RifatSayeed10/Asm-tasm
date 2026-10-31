.model small
.stack 100h

.code
main proc

    mov ah,1
    int 21h
    mov bl,al

    ; New Line
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h

    ; Display Character
    mov ah,2
    mov dl,bl
    int 21h

    ; Exit
    mov ah,4ch
    int 21h

main endp
end main

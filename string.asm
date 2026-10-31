.model small
.stack 100h

.data
msg db 'Welcome to Assembly Language!$'

.code
main proc

    mov ax,@data
    mov ds,ax

    mov ah,9
    lea dx,msg
    int 21h

    mov ah,4ch
    int 21h

main endp
end main

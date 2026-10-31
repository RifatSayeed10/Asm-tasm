.MODEL SMALL
.STACK 100H
.DATA
    MSG DB 'Absolute value = $'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AX, -25          ; test value (AX = FFE7H)

    CMP AX, 0
    JGE POSITIVE         ; branch: already positive
    NEG AX               ; make it positive
POSITIVE:
    MOV BX, AX           ; save result

    LEA DX, MSG
    MOV AH, 9
    INT 21H

    MOV AX, BX
    AAM                  ; AH = tens, AL = units
    ADD AH, 30H
    ADD AL, 30H
    MOV BH, AL
    MOV DL, AH
    MOV AH, 2
    INT 21H
    MOV DL, BH
    MOV AH, 2
    INT 21H

    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN

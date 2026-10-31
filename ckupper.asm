.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Enter a character: $'
    MSG2 DB 0DH,0AH,'Uppercase letter: $'
    MSG3 DB 0DH,0AH,'Not an uppercase letter.$'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, MSG1
    MOV AH, 9
    INT 21H

    MOV AH, 1
    INT 21H              ; AL = input character
    MOV BL, AL

    CMP BL, 'A'          ; condition 1
    JB  NOT_UPPER
    CMP BL, 'Z'          ; condition 2
    JA  NOT_UPPER

    LEA DX, MSG2         ; both conditions satisfied
    MOV AH, 9
    INT 21H
    MOV DL, BL
    MOV AH, 2
    INT 21H
    JMP EXIT

NOT_UPPER:
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
EXIT:
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN

.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Continue? (y/Y): $'
    MSG2 DB 0DH,0AH,'You entered: $'
    MSG3 DB 0DH,0AH,'Program terminated.$'
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

    CMP BL, 'y'          ; condition 1
    JE  SHOW
    CMP BL, 'Y'          ; condition 2
    JE  SHOW
    JMP TERMINATE        ; neither matched

SHOW:
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    MOV DL, BL
    MOV AH, 2
    INT 21H
    JMP EXIT

TERMINATE:
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
EXIT:
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN

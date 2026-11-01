;============================================================
; PROJECT: HYBRID SORTING TECHNIQUE
; INSERTION SORT + BOTTOM-UP MERGE SORT
; PROCESSOR: 8086
; MAX INPUT: 50 NUMBERS
; RUN SIZE: 8
;============================================================

.MODEL SMALL
.STACK 100H

;---------------- MACROS -------------------------------------

PRINT MACRO MSG
    PUSH AX
    PUSH DX
    LEA DX, MSG
    MOV AH, 09H
    INT 21H
    POP DX
    POP AX
ENDM

NEWLINE MACRO
    PUSH AX
    PUSH DX
    MOV AH, 02H
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H
    POP DX
    POP AX
ENDM

;---------------- DATA ---------------------------------------

.DATA

MAXN EQU 50
RUN  EQU 8

ARR  DW MAXN DUP(0)
TEMP DW MAXN DUP(0)

N       DW 0
LFT     DW 0
MID     DW 0
RGT     DW 0
WSIZE   DW 0
GRP     DW 0

RUNNO   DW 0
PASSNO  DW 0
MERGENO DW 0

TITLE1 DB '============================================',0DH,0AH
       DB ' HYBRID SORTING TECHNIQUE - 8086',0DH,0AH
       DB ' INSERTION SORT + MERGE SORT',0DH,0AH
       DB '============================================$'

ASKN DB 'How many numbers (2-50)? $'
BADN DB 'Invalid count. Enter 2 to 50.$'
ASKNUM DB 'Enter numbers separated by spaces: $'

MTOTAL DB 'Total numbers: $'
MORIG DB 'Original Array:$'
MFINAL DB 'FINAL SORTED ARRAY:$'

MOK DB 'CHECK: Array is correctly sorted.$'
MFAIL DB 'CHECK: Sorting failed.$'

PH1TITLE DB '========== PHASE 1: INSERTION SORT ==========$'
RUNINFO DB 'Fixed Run Size = 8$'
RUNMSG DB 'Run #$'
INDEXMSG DB ' | Index [$'
TOMSG DB ' to $'
CLOSEBR DB ']$'
BEFOREMSG DB 'Before Insertion Sort:$'
AFTERMSG DB 'After Insertion Sort:$'
PH1DONE DB 'PHASE 1 COMPLETED.$'

PH2TITLE DB '========== PHASE 2: BOTTOM-UP MERGE SORT ==========$'
PASSMSG DB 'MERGE PASS #$'
BLOCKMSG DB ' | Block Size = $'
MERGEOPMSG DB 'Merge Operation #$'
LEFTMSG DB ' | Left [$'
RIGHTMSG DB '] + Right [$'
AFTERMERGE DB 'Array after this merge:$'
PASSDONE DB 'END OF PASS #$'
PASSARRAY DB 'Array after complete pass:$'
PH2DONE DB 'MERGE SORT COMPLETED.$'

SPACE1 DB ' $'

;---------------- CODE ---------------------------------------

.CODE

MAIN PROC

    MOV AX,@DATA
    MOV DS,AX

    PRINT TITLE1
    NEWLINE

;---------------- USER INPUT ---------------------------------

ASK_COUNT:

    PRINT ASKN
    CALL READ_NUM

    CMP AX,2
    JB BAD_COUNT

    CMP AX,MAXN
    JA BAD_COUNT

    MOV N,AX
    JMP READ_ALL

BAD_COUNT:

    PRINT BADN
    NEWLINE
    JMP ASK_COUNT

READ_ALL:

    PRINT ASKNUM
    NEWLINE

    MOV CX,N
    XOR SI,SI

READ_LOOP:

    CALL READ_NUM

    MOV ARR[SI],AX
    ADD SI,2

    LOOP READ_LOOP

    NEWLINE

;---------------- ORIGINAL ARRAY -----------------------------

    PRINT MTOTAL

    MOV AX,N
    CALL PRINT_NUM

    NEWLINE

    PRINT MORIG
    NEWLINE

    MOV GRP,0
    CALL PRINT_ARRAY

    NEWLINE

;---------------- HYBRID SORT --------------------------------

    CALL HYBRID_SORT

;---------------- FINAL OUTPUT -------------------------------

    PRINT MFINAL
    NEWLINE

    CALL PRINT_ARRAY_SINGLE

    CALL CHECK_SORTED

    MOV AH,4CH
    INT 21H

MAIN ENDP


;============================================================
; HYBRID SORT
; PHASE 1: INSERTION SORT
; PHASE 2: BOTTOM-UP MERGE SORT
;============================================================

HYBRID_SORT PROC

    PUSH AX
    PUSH BX

;---------------- PHASE 1 ------------------------------------

    PRINT PH1TITLE
    NEWLINE

    PRINT RUNINFO
    NEWLINE
    NEWLINE

    MOV LFT,0
    MOV RUNNO,1

P1_LOOP:

    MOV AX,LFT

    CMP AX,N
    JAE P1_DONE

    ADD AX,RUN-1

    MOV BX,N
    DEC BX

    CMP AX,BX
    JBE P1_SETR

    MOV AX,BX

P1_SETR:

    MOV RGT,AX

; DISPLAY RUN NUMBER

    PRINT RUNMSG

    MOV AX,RUNNO
    CALL PRINT_NUM

    PRINT INDEXMSG

    MOV AX,LFT
    CALL PRINT_NUM

    PRINT TOMSG

    MOV AX,RGT
    CALL PRINT_NUM

    PRINT CLOSEBR
    NEWLINE

; BEFORE SORTING

    PRINT BEFOREMSG
    NEWLINE

    MOV GRP,0
    CALL PRINT_ARRAY

; CALL INSERTION SORT

    CALL INSERTION_SORT

; AFTER SORTING

    PRINT AFTERMSG
    NEWLINE

    MOV GRP,RUN
    CALL PRINT_ARRAY

    NEWLINE

    INC RUNNO

    ADD LFT,RUN

    JMP P1_LOOP

P1_DONE:

    PRINT PH1DONE
    NEWLINE

    MOV GRP,RUN
    CALL PRINT_ARRAY

    NEWLINE

;---------------- PHASE 2 ------------------------------------

    PRINT PH2TITLE
    NEWLINE

    MOV WSIZE,RUN
    MOV PASSNO,1

P2_OUTER:

    MOV AX,WSIZE

    CMP AX,N
    JAE P2_DONE

; DISPLAY PASS NUMBER

    PRINT PASSMSG

    MOV AX,PASSNO
    CALL PRINT_NUM

    PRINT BLOCKMSG

    MOV AX,WSIZE
    CALL PRINT_NUM

    NEWLINE

    MOV LFT,0
    MOV MERGENO,1

P2_INNER:

    MOV AX,LFT

    CMP AX,N
    JAE P2_PASS_DONE

; MID = LFT + WSIZE - 1

    ADD AX,WSIZE
    DEC AX

    MOV MID,AX

; RGT = MIN(LFT + 2*WSIZE - 1, N-1)

    MOV AX,WSIZE

    SHL AX,1

    ADD AX,LFT
    DEC AX

    MOV BX,N
    DEC BX

    CMP AX,BX
    JBE P2_SETR

    MOV AX,BX

P2_SETR:

    MOV RGT,AX

; CHECK RIGHT RUN

    MOV AX,MID

    CMP AX,RGT
    JAE P2_NEXT

; DISPLAY MERGE OPERATION

    PRINT MERGEOPMSG

    MOV AX,MERGENO
    CALL PRINT_NUM

    PRINT LEFTMSG

    MOV AX,LFT
    CALL PRINT_NUM

    PRINT TOMSG

    MOV AX,MID
    CALL PRINT_NUM

    PRINT RIGHTMSG

    MOV AX,MID
    INC AX
    CALL PRINT_NUM

    PRINT TOMSG

    MOV AX,RGT
    CALL PRINT_NUM

    PRINT CLOSEBR
    NEWLINE

; CALL MERGE

    CALL MERGE

; DISPLAY AFTER MERGE

    PRINT AFTERMERGE
    NEWLINE

    MOV GRP,0
    CALL PRINT_ARRAY

    NEWLINE

    INC MERGENO

P2_NEXT:

    MOV AX,WSIZE

    SHL AX,1

    ADD LFT,AX

    JMP P2_INNER

;---------------- END OF PASS --------------------------------

P2_PASS_DONE:

    PRINT PASSDONE

    MOV AX,PASSNO
    CALL PRINT_NUM

    NEWLINE

    PRINT PASSARRAY
    NEWLINE

    CALL PRINT_ARRAY

    NEWLINE

; DOUBLE BLOCK SIZE

    SHL WSIZE,1

    INC PASSNO

    JMP P2_OUTER

P2_DONE:

    PRINT PH2DONE
    NEWLINE

    POP BX
    POP AX

    RET

HYBRID_SORT ENDP


;============================================================
; INSERTION SORT
; SORT ARR[LFT...RGT]
;============================================================

INSERTION_SORT PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV CX,LFT
    INC CX

IS_OUTER:

    CMP CX,RGT
    JA IS_DONE

    MOV SI,CX
    SHL SI,1

    MOV DX,ARR[SI]

    MOV BX,CX
    DEC BX

IS_INNER:

    CMP BX,LFT
    JL IS_INSERT

    MOV SI,BX
    SHL SI,1

    MOV AX,ARR[SI]

    CMP AX,DX
    JBE IS_INSERT

; SHIFT ELEMENT RIGHT

    MOV ARR[SI+2],AX

    DEC BX

    JMP IS_INNER

IS_INSERT:

    MOV SI,BX
    INC SI

    SHL SI,1

    MOV ARR[SI],DX

    INC CX

    JMP IS_OUTER

IS_DONE:

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX

    RET

INSERTION_SORT ENDP


;============================================================
; MERGE SORT
; MERGE TWO SORTED BLOCKS
; LEFT  = ARR[LFT...MID]
; RIGHT = ARR[MID+1...RGT]
;============================================================

MERGE PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI

    MOV BX,LFT

    MOV DI,MID
    INC DI

    MOV CX,LFT

M_LOOP:

    CMP BX,MID
    JA M_RIGHT_REST

    CMP DI,RGT
    JA M_LEFT_REST

; READ LEFT VALUE

    MOV SI,BX
    SHL SI,1

    MOV AX,ARR[SI]

; READ RIGHT VALUE

    MOV SI,DI
    SHL SI,1

    MOV DX,ARR[SI]

; COMPARE BOTH VALUES

    CMP AX,DX

    JBE M_TAKE_LEFT

; TAKE RIGHT VALUE

    MOV SI,CX
    SHL SI,1

    MOV TEMP[SI],DX

    INC DI
    INC CX

    JMP M_LOOP

M_TAKE_LEFT:

    MOV SI,CX
    SHL SI,1

    MOV TEMP[SI],AX

    INC BX
    INC CX

    JMP M_LOOP

; COPY REMAINING LEFT ELEMENTS

M_LEFT_REST:

    CMP BX,MID
    JA M_COPY_BACK

    MOV SI,BX
    SHL SI,1

    MOV AX,ARR[SI]

    MOV SI,CX
    SHL SI,1

    MOV TEMP[SI],AX

    INC BX
    INC CX

    JMP M_LEFT_REST

; COPY REMAINING RIGHT ELEMENTS

M_RIGHT_REST:

    CMP DI,RGT
    JA M_COPY_BACK

    MOV SI,DI
    SHL SI,1

    MOV AX,ARR[SI]

    MOV SI,CX
    SHL SI,1

    MOV TEMP[SI],AX

    INC DI
    INC CX

    JMP M_RIGHT_REST

; COPY TEMP BACK TO ARR

M_COPY_BACK:

    MOV CX,LFT

M_COPY_LOOP:

    CMP CX,RGT
    JA M_DONE

    MOV SI,CX
    SHL SI,1

    MOV AX,TEMP[SI]

    MOV ARR[SI],AX

    INC CX

    JMP M_COPY_LOOP

M_DONE:

    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX

    RET

MERGE ENDP


;============================================================
; DISPLAY ARRAY - INTERMEDIATE OUTPUT
;============================================================

PRINT_ARRAY PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI

    MOV CX,N

    XOR SI,SI
    XOR BX,BX

PA_LOOP:

    MOV AX,ARR[SI]

    CALL PRINT_NUM

    PRINT SPACE1

    INC BX

    CMP BX,N
    JE PA_NEXT

    CMP GRP,0
    JE PA_LINE

    MOV AX,BX

    XOR DX,DX

    DIV GRP

    CMP DX,0
    JNE PA_LINE

    NEWLINE

    JMP PA_NEXT

PA_LINE:

    MOV AX,BX

    XOR DX,DX

    MOV DI,RUN

    DIV DI

    CMP DX,0
    JNE PA_NEXT

    NEWLINE

PA_NEXT:

    ADD SI,2

    LOOP PA_LOOP

    NEWLINE

    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX

    RET

PRINT_ARRAY ENDP


;============================================================
; PRINT FINAL ARRAY IN ONE ROW
;============================================================

PRINT_ARRAY_SINGLE PROC

    PUSH AX
    PUSH CX
    PUSH SI

    MOV CX,N

    XOR SI,SI

PAS_LOOP:

    MOV AX,ARR[SI]

    CALL PRINT_NUM

    DEC CX

    JZ PAS_DONE

    PRINT SPACE1

    ADD SI,2

    JMP PAS_LOOP

PAS_DONE:

    NEWLINE

    POP SI
    POP CX
    POP AX

    RET

PRINT_ARRAY_SINGLE ENDP


;============================================================
; CHECK SORTED ARRAY
;============================================================

CHECK_SORTED PROC

    PUSH AX
    PUSH CX
    PUSH SI

    MOV CX,N
    DEC CX

    XOR SI,SI

CS_LOOP:

    MOV AX,ARR[SI]

    CMP AX,ARR[SI+2]

    JA CS_FAIL

    ADD SI,2

    LOOP CS_LOOP

    PRINT MOK
    NEWLINE

    JMP CS_END

CS_FAIL:

    PRINT MFAIL
    NEWLINE

CS_END:

    POP SI
    POP CX
    POP AX

    RET

CHECK_SORTED ENDP


;============================================================
; PRINT UNSIGNED NUMBER
;============================================================

PRINT_NUM PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX,10

    XOR CX,CX

PN_DIV:

    XOR DX,DX

    DIV BX

    PUSH DX

    INC CX

    CMP AX,0

    JNE PN_DIV

PN_OUT:

    POP DX

    ADD DL,'0'

    MOV AH,02H

    INT 21H

    LOOP PN_OUT

    POP DX
    POP CX
    POP BX
    POP AX

    RET

PRINT_NUM ENDP


;============================================================
; READ NUMBER FROM KEYBOARD
; ACCEPTS SPACE OR ENTER AS SEPARATOR
;============================================================

READ_NUM PROC

    PUSH BX
    PUSH CX
    PUSH DX
    PUSH DI

    XOR BX,BX

    XOR DI,DI

RN_LOOP:

    MOV AH,01H

    INT 21H

    CMP AL,0DH
    JE RN_SEP

    CMP AL,' '
    JE RN_SEP

    CMP AL,'0'
    JB RN_LOOP

    CMP AL,'9'
    JA RN_LOOP

    SUB AL,'0'

    MOV AH,0

    MOV CX,AX

    MOV AX,BX

    MOV DX,10

    MUL DX

    ADD AX,CX

    MOV BX,AX

    MOV DI,1

    JMP RN_LOOP

RN_SEP:

    CMP DI,0

    JE RN_LOOP

    CMP AL,0DH
    JNE RN_RETURN

    PUSH AX

    MOV AH,02H
    MOV DL,0AH

    INT 21H

    POP AX

RN_RETURN:

    MOV AX,BX

    POP DI
    POP DX
    POP CX
    POP BX

    RET

READ_NUM ENDP

END MAIN

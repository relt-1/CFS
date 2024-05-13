100h:

MOV AL, 00h ; B0 00
MOV DX, 0400h ; BA 00 04
MOV AH, 3Dh ; B4 3D
INT 21h ; CD 21

MOV BX, AX ; 8B D8
MOV CX, 4000h ; B9 00 40
MOV DX, 0500h ; BA 00 05
MOV AH, 3Fh ; B4 3F
INT 21h ; CD 21

MOV AH, 3Eh ; B4 3E
INT 21h ; CD 21

MOV SI, 0500h ; BE 00 05
MOV DI, 4504h ; BF 04 45
MOV CX, 4000h ; B9 00 40
MOV AX, 0000h ; B8 00 00
MOV BX, 0482h ; BB 82 04
MOV [BX], AX ; 89 07

JMP @comp ; EB ??

luup:
CMP DL, 3Bh ; 80 FA 3B
JNE @semicolon ; 75 ??
coloop:
MOV DX, [SI] ; 8A 14
INC SI ; FF C6
DEC CX ; FF C9
JZ @exit ; 74 ??
CMP DL, 00h ; 80 FA 00
JZ @exit ; 74 ??
CMP DL,0Ah ; 80 FA 0A
JE @comp ; 74 ??
JMP @coloop ; EB ??
semicolon:

CMP DL, 53h ; 80 FA 53
JNE @S ; 75 ??
MOV BL, 20h ; B3 20
CALL @gethex ; E8 ?? ??
MOV BX, 0482h ; BB 82 04
MOV [BX],AX ; 89 07
JMP @luup ; EB ??
S:

CMP DL, 4Ch ; 80 FA 4C
JNE @L ; 75 ??
MOV BL, 3Ah ; B3 3A
CALL @gethex ; E8 ?? ??
MOV BX, 0482h ; BB 82 04
MOV DX, [BX] ; 8B 17
MOV [DI], AX ; 89 05
ADD DI, 0002h ; 81 C7 02 00
MOV [DI], DX ; 89 15
ADD DI, 0002h ; 81 C7 02 00
JMP @luup ; EB ??
L:

CMP DL, 40h ; 80 FA 40
JNE @AA   ; 75 ?? 
MOV DX, [SI] ; 8B 14
INC SI ; FF C6
MOV DH, 00h ; 86 00
SUB DL, 30h ; 80 EF 30
MOV BX, 0482h ; BB 82 04
MOV BX, [BX] ; 89 1F
ADD BX, DX ; 00 D3
MOV DX, 0482h ; BA 82 04
MOV [DX], BX ; 89 DA
INC SI ; FF C6
INC SI ; FF C6
MOV BL, 20h ; B3 20
CALL @gethex ; E8 ?? ??
JMP @luup ; EB ??
AA:

CMP DL, 24h
JNE @dollar
INC SI
INC SI
MOV BL, 20h
CALL @gethex
LEA DX, [0482h]
ADD DX, 2h
MOV [0482h], DX
JMP @luup
dollar:

MOV BL, 20h
CALL @gethex
CALL @addhexptr

comp:
MOV DX, [SI] ; 8A 14
INC SI ; FF C6
CMP DL, 00h ; 80 FA 00
LOOPNE @luup ; E0 ??

exit:
JMP @part2


gethex:
MOV [0484h], SI
MOV AX, 00h
JMP @Lcomp
Lluup:
SHL AX
SHL AX
SHL AX
SHL AX
AND DL, 1Fh
CMP DL, 10h
JA @Lnumber
ADD DL, 9h
JMP @Lshared
Lnumber:
SUB DL, 10h
Lshared:
OR AL, DL

Lcomp:
MOV DX, [SI]
INC SI
DEC CX
JZ @re
CMP DL, BL
JZ @re
CMP DL, 20h
JNA @re
CMP DL, BL
JE @re
JMP @Lluup
re:
RET

addhexptr:
LEA DX, [0484h]
SUB DX, SI
NEG DX
SHR DX
LEA BX, [0482h]
ADD BX, DX
MOV [0482h], BX
RET

; =======================================

part2:
MOV SI, 0500h ; BE 00 05
MOV CX, 4000h ; B9 00 40
MOV DI, 5000h
part2luup:

CMP DL, 3Bh
JNE @semicolon2
coloop2:
MOV DX, [SI] ; 8A 14
INC SI ; FF C6
DEC CX ; FF C9
JZ @exit2 ; 74 ??
CMP DL, 00h ; 80 FA 00
JZ @exit2 ; 74 ??
CMP DL, 0Ah ; 80 FA 0A
JE @comp2 ; 74 ??
JMP @coloop2 ; EB ??
semicolon2:


CMP DL, 53h ; 80 FA 53
JNE @S2 ; 75 ??
MOV BL, 20h ; 83 20
CALL @gethex ; 
MOV [0482h],AX
JMP @part2luup
S2:

CMP DL, 4Ch
JNE @L2
MOV BL, 3Ah
CALL @gethex
JMP @part2luup
L2:

CMP DL, 40h
JNE @AA2   ; @
MOV DX, [SI]
INC SI
MOV DH, 00h
SUB DL, 30h
INC SI
INC SI
MOV BL, 20h
CALL @gethex
CALL @getlabel
LEA AX, [0482h]
ADD AX, DL
MOV [0482h], AX
SUB BX, AX
MOV [DI], BX
ADD DI, DL
JMP @part2luup
AA2:

CMP DL, 24h
JNE @dollar2
INC SI
INC SI
MOV BL, 20h
CALL @gethex
CALL @getlabel
MOV [DI], BX
LEA AX, [0482h]
ADD AX, 02h
MOV [0482h], AX
ADD DI, 02h
JMP @part2luup
dollar2:

CALL @gethex
MOV [DI], AX
CALL @addhexptr
ADD DI, DX

comp2:
MOV DX, [SI] ; 8A 14
INC SI ; FF C6
CMP DL, 00h ; 80 FA 00
LOOPNE @part2luup ; E0 ??

MOV CX, 00h
MOV DX, 0480h
MOV AH, 3Ch
INT 21h

MOV BX, AX
MOV CX, DI
SUB CX, 5000h
MOV DX, 5000h
MOV AH, 40h
INT 21h

MOV AH, 3Eh
INT 21h


MOV AH, 4Ch
INT 21h



getlabel:
MOV BX, 4500h
getlabelluup:
ADD BX, 0004h
CMP AX, [BX]
JNE @getlabelluup
ADD BX, 0002h
MOV BX, [BX]
RET
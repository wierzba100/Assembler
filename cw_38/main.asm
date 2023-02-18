ldi R22, 0 //0
mov R2, R22
ldi R22, 1 //1
mov R3, R22
ldi R22, 2 //2
mov R4, R22
ldi R22, 3 //3
mov R5, R22
ldi R22, 4 //4
mov R6, R22
ldi R22, 5 //5
mov R7, R22
ldi R22, 6 //6
mov R8, R22
ldi R22, 7 //7
mov R9, R22
ldi R22, 8 //8
mov R10, R22
ldi R22, 9 //9
mov R11, R22
clr R22

.def Digit_0 = R2
.def Digit_1 = R3
.def Digit_2 = R4
.def Digit_3 = R5
.def Digit_4 = R6
.def Digit_5 = R7
.def Digit_6 = R8
.def Digit_7 = R9
.def Digit_8 = R10
.def Digit_9 = R11


ldi R30, low(Table<<1) // inicjalizacja rejestru Z 
ldi R31, high(Table<<1)

mov R16, Digit_9

rcall DigitTo7segCode

mov R16, Digit_8

rcall DigitTo7segCode

nop


Table: .db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x3D, 0x07, 0x7F, 0x6F 

DigitTo7segCode:
    push R20
    push R30
    push R31
    lpm R20, Z
    inc R16
    Loop: adiw R30:R31,1 // inkrementacja Z
    dec R16
    brne Loop
sbiw R30:R31,1
lpm R20, Z  
mov R16,R20
pop R31
pop R30
pop R20
ret
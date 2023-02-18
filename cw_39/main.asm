.equ Digits_P = PORTB
.equ Segments_P = PORTD

.macro SET_DIGIT
push R20
push R30
push R31
push R16
push R17
ldi R17, 0x0A
ldi R16, @0
add R16,R17
lpm R20, Z
    Loop: adiw R30:R31,1 // inkrementacja Z
    dec R16
    brne Loop
lpm R20, Z  
out Digits_P, R20
pop R17
pop R16
pop R31
pop R30
pop R20
.endmacro

ldi R30, low(Table<<1) // inicjalizacja rejestru Z 
ldi R31, high(Table<<1)

ldi R18, 20
ldi R17, 0
clr R20
out DDRD, R20
ldi R22, 0 
mov R2, R22
ldi R22, 1 
mov R3, R22
ldi R22, 2 
mov R4, R22
ldi R22, 3 
mov R5, R22
ldi R22, 4 
mov R6, R22
ldi R22, 5 
mov R7, R22
ldi R22, 6 
mov R8, R22
ldi R22, 7 
mov R9, R22
ldi R22, 8 
mov R10, R22
ldi R22, 9 
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


MainLoop:
SET_DIGIT 0
mov R16, Digit_7
rcall DigitTo7segCode
out Segments_P, R16
rcall DelayInMs
SET_DIGIT 1
mov R16, Digit_6
rcall DigitTo7segCode
out Segments_P, R16
rcall DelayInMs
SET_DIGIT 2
mov R16, Digit_5
rcall DigitTo7segCode
out Segments_P, R16
rcall DelayInMs
SET_DIGIT 3
mov R16, Digit_4
rcall DigitTo7segCode
out Segments_P, R16
rcall DelayInMs
rjmp MainLoop


Table: .db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x02, 0x04, 0x08, 0x10

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

DelayInMs:
    push R18
    push R17
    push R24
    push R25
    Start:
        ldi R24,0xFF
        ldi R25,0xFF
        CounterLoop:sbiw R25:R24, 41
                brcs Loop2
                 rjmp CounterLoop
    Loop2:subi R18, 1
        sbci R17, 0
        brne Start
    End:
    pop R25
    pop R24
    pop R17
    pop R18
ret

Segment_1:
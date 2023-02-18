.equ Digits_P = PORTB
.equ Segments_P = PORTD
   
ldi R16, 0x04
mov R2, R16
ldi R16, 0x03
mov R3, R16
ldi R16, 0x02
mov R4, R16
ldi R16, 0x01
mov R5, R16

.def Digit_0=R5
.def Digit_1=R4
.def Digit_2=R3
.def Digit_3=R2

ldi R16, 0x2
mov R6, R16
ldi R16, 0x4
mov R7, R16
ldi R16, 0x8
mov R8, R16
ldi R16, 0x10
mov R9, R16

.def Segment_0 = R6
.def Segment_1 = R7
.def Segment_2 = R8
.def Segment_3 = R9

ldi R17, 0xFF
out DDRB, R17
out DDRD, R17

.macro SET_DIGIT
push R19
push R17
mov R17, Digit_@0
push Digit_@0
rcall DigitTo7segCode
mov Digit_@0, R17
out Digits_P, Segment_@0
clr R19
out Segments_P, R19
out Segments_P,  Digit_@0
rcall DelayInMs
pop Digit_@0
pop R17
pop R19
.endmacro

ldi R20, 1 //Counter1OfDelayInMS
ldi R21, 0 //Counter2OfDelayInMS

MainLoop:
    SET_DIGIT 0
    SET_DIGIT 1
    SET_DIGIT 2
    SET_DIGIT 3
    ldi R19, 10
    inc R2
    cp R2,R19
    brne MainLoop
    clr R2
rjmp MainLoop

DigitTo7segCode:
push R16
mov R16, R17
ldi R30, low(Table<<1) 
ldi R31, high(Table<<1)
    IncrementationOfZ:
        dec R16
        brbs 2, EndOfIncrementationOfZ
        adiw R30:R31, 1
        rjmp  IncrementationOfZ
    EndOfIncrementationOfZ:
lpm R16, Z
mov R17, R16
pop R16
ret
Table: 
.db 0x3f, 0x6, 0x5b, 0x4f,0x66, 0x6d, 0x7d,  0x7, 0xff, 0x6f

DelayInMs:
    push R20
    push R21
    push R24
    push R25
    Start:
        ldi R24,0xFF
        ldi R25,0xFF
        CounterLoop:sbiw R25:R24, 41
                brcs Loop2
                 rjmp CounterLoop
    Loop2:subi R21, 1
        sbci R20, 0
        brne Start
    End:
    pop R25
    pop R24
    pop R21
    pop R20
ret

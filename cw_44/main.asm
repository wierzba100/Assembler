.equ Digits_P = PORTB
.equ Segments_P = PORTD
   
ldi R16, 0x00
mov R2, R16
ldi R16, 0x00
mov R3, R16
ldi R16, 0x00
mov R4, R16
ldi R16, 0x00
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

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

MainLoop:
    SET_DIGIT 0
    SET_DIGIT 1
    SET_DIGIT 2
    SET_DIGIT 3
    ldi R21, 1
    clr R20

    add R0, R21
    adc R1, R20
    mov R16, R0
    mov R17, R1
    ldi R18,0x10
    ldi R19,0x27
    rcall Divide
    rcall NumberToDigits
    mov Digit_0, R16
    mov Digit_1, R17
    mov Digit_2, R18
    mov Digit_3, R19
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
    ldi R20, 0x00 //CounterHOfDelayInMS
    ldi R21, 0x01 //CounterLOfDelayInMS
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

DelayOneMs:
    push R24
    push R25
    ldi R24, 0xFF
    ldi R25, 0xFF
    CounterLoopDelayOneMs:
        sbiw R25:R24, 41                
        brcs EndOfDelayOneMs
        rjmp CounterLoopDelayOneMs
EndOfDelayOneMs:
    pop R25
    pop R24
ret 

Divide:
    push R24
    push R25
    .def XL=R16 ; divident 
    .def XH=R17 
    .def YL=R18 ; divisor
    .def YH=R19

    .def QCtrL=R24
    .def QCtrH=R25

    ldi QCtrL, 0x00
    ldi QCtrH, 0x00

    rjmp comparing
    subtraction:
        sub XL,YL
        sbc XH,YH
        adiw QCtrH:QCtrL, 1
    comparing:
        cp XL,YL
        cpc XH,YH
    brsh subtraction

    .def RL=R16 ; remainder 
    .def RH=R17 
    .def QL=R18 ; quotient
    .def QH=R19 
    mov QL, QCtrL
    mov QH, QCtrH
    pop R25
    pop R24
ret

NumberToDigits:
    .def Dig0=R22 ; Digits temps
    .def Dig1=R23 ; 
    .def Dig2=R24 ; 
    .def Dig3=R25 ;

    ldi R18, 0xE8
    ldi R19, 0x03
    rcall Divide
    mov Dig0, R18

    ldi R18, 0x64
    ldi R19, 0x00
    rcall Divide
    mov Dig1, R18

    ldi R18, 0x0A
    ldi R19, 0x00
    rcall Divide
    mov Dig2, R18

    mov Dig3, R16

    mov R16, R22
    mov R17, R23
    mov R18, R24
    mov R19, R25
    
    clr R22
    clr R23
    clr R24
    clr R25
ret

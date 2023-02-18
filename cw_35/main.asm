.equ Digits_P = PORTB
.equ Segments_P = PORTD

ldi R16, 20
ldi R17, 0
clr R20
out DDRD, R20
ldi R22, 0x3F //0
mov R2, R22
ldi R22, 0x06 //1
mov R3, R22
ldi R22, 0x5B //2
mov R4, R22
ldi R22, 0x4F //3
mov R5, R22

.def Digit_0 = R2
.def Digit_1 = R3
.def Digit_2 = R4
.def Digit_3 = R5

MainLoop:
ldi R23, 0x02
out Digits_P, R23
out Segments_P, Digit_0
rcall DelayInMs
ldi R23, 0x04
out Digits_P, R23
out Segments_P, Digit_1
rcall DelayInMs
ldi R23, 0x08
out Digits_P, R23
out Segments_P, Digit_2
rcall DelayInMs
ldi R23, 0x10
out Digits_P, R23
out Segments_P, Digit_3
rcall DelayInMs
rjmp MainLoop

DelayInMs:
    push R16
    push R17
    push R24
    push R25
    Start:
        ldi R24,0xFF
        ldi R25,0xFF
        CounterLoop:sbiw R25:R24, 41
                brcs Loop2
                 rjmp CounterLoop
    Loop2:subi R16, 1
        sbci R17, 0
        brne Start
    End:
    pop R25
    pop R24
    pop R17
    pop R16
ret
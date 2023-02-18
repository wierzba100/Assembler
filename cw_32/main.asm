.equ Digits_P = PORTB
.equ Segments_P = PORTD

ldi R16, 20
ldi R17, 0
clr R20
out DDRD, R20
ldi R21, 0x06
ldi R22, 0x3F

MainLoop:
ldi R23, 0x02
out Digits_P, R23
out Segments_P, R22
rcall DelayInMs
ldi R23, 0x04
out Digits_P, R23
out Segments_P, R22
rcall DelayInMs
ldi R23, 0x08
out Digits_P, R23
out Segments_P, R22
rcall DelayInMs
ldi R23, 0x10
out Digits_P, R23
out Segments_P, R22
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
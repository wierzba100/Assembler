ldi R16, 250
ldi R17, 0
clr R20
out DDRD, R20
ldi R21, 0x06
ldi R22, 0x3F
ldi R23, 0x02
out PORTB, R23
MainLoop:
out PORTD, R22
rcall DelayInMs
out PORTD, R21
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
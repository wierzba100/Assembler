ldi R16, 250
ldi R17, 0
ldi R20, 0xF
clr R22
out DDRB, R22
MainLoop:
out PORTB, R20
out PORTB, R21
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
    pop R24
    pop R25
    pop R16
    pop R17
ret
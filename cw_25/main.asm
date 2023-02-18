MainLoop:
rcall  DelayOneMs
rjmp MainLoop

DelayInMs:
Start:
    ldi R24, 0xff
    ldi R25, 0xff
    CounterLoop:sbiw R25:R24, 41
                brcs Loop2
                 rjmp CounterLoop
Loop2:lds R24,0x60
    dec R24
    brbs 1, End
    rjmp Start
End:
ret

DelayOneMs:
ldi R24,1
sts 0x60,R24
rcall DelayInMs
ret


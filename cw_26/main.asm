MainLoop:
rcall  DelayOneMs
rjmp MainLoop

DelayInMs:
Start:
    lds R24,0x61
    lds R25,0x61
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
ldi R25, 0xff
sts 0x60,R24
sts 0x61,R25
rcall DelayInMs
ret


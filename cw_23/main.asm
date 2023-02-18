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
Loop2:dec R22
     brbs 1, End
     rjmp Start
End:
ret

DelayOneMs:
Start2:
    ldi R24, 0xff
    ldi R25, 0xff
    CounterLoop2:sbiw R25:R24, 41
                brcs End2
                 rjmp CounterLoop2
     rjmp Start2
End2:
ret


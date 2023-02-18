ldi R22, 5

MainLoop: 
rcall DelayInMs
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


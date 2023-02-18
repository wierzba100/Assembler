ldi R22, 5

Start:
    Loop1:
        ldi R24, 0xFF
        ldi R25, 0xFF
        Loop2:
            sbiw R25:R24,41
            brcs Loop2
            rjmp Loop1
Loop2:
    brbs 1, End
    rjmp Start

End: nop
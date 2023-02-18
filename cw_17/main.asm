ldi R22,5
Loop3:
ldi R21, 20
Loop1:
    ldi R20, 100
Loop2:
    nop
    dec R20
    brne Loop2
    dec R21
    brne Loop1
    dec R22
    brne Loop3
    nop
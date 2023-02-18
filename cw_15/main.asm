ldi R20, 125
Loop:
    ldi    R21, 11
Loop1:
      nop
      nop
      nop
      nop
    dec R21
    brne Loop1
    dec R20
    brne Loop
    nop
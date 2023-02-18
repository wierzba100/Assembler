ldi r20, 50
Loop1:
    ldi r21, 10
    Loop2:
      nop
    dec r21
    brne Loop2
dec r20
brne Loop1

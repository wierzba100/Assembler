Loop1:
    ldi R20,5
    Loop: dec R20
    brne Loop
rjmp Loop1

//Cycles=(R20*3)+1

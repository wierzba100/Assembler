ldi R16, 0xB0
ldi R17, 0x04
ldi R18, 0xF4
ldi R19, 0x01
Divide:
.def XL=R16 ; divident 
.def XH=R17 
.def YL=R18 ; divisor
.def YH=R19

.def QCtrL=R24
.def QCtrH=R25

ldi QCtrL, 0x00
ldi QCtrH, 0x00

rjmp comparing
subtraction:
    sub XL,YL
    sbc XH,YH
    adiw QCtrH:QCtrL, 1
comparing:
    cp XL,YL
    cpc XH,YH
brsh subtraction

.def RL=R16 ; remainder 
.def RH=R17 
.def QL=R18 ; quotient
.def QH=R19 
mov QL, QCtrL
mov QH, QCtrH
nop



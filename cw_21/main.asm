ldi R20, 0xFF

MainLoop: 
rcall DelayNCycles ; 
rjmp MainLoop
DelayNCycles: ;zwyk�a etykieta
nop
nop
rcall Podprogram
nop
ret ;powr�t do miejsca wywo�ania

Podprogram:
nop
dec R22
nop
ret

ldi R20, 0xFF

MainLoop: 
rcall DelayNCycles ; 
rjmp MainLoop
DelayNCycles: ;zwyk³a etykieta
nop
nop
rcall Podprogram
nop
ret ;powrót do miejsca wywo³ania

Podprogram:
nop
dec R22
nop
ret

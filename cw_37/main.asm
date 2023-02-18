// Program odczytuje 4 bajty z tablicy sta�ych zdefiniowanej w pami�ci kodu do rejestr�w 
//R20..R23

ldi R30, low(Table<<1) // inicjalizacja rejestru Z 
ldi R31, high(Table<<1)

ldi R16, 0x09

rcall Converter

nop


Table: .db 0x00, 0x01, 0x04, 0x09, 0x10, 0x19, 0x24, 0x31, 0x40, 0x51 // UWAGA: liczba bajt�w zdeklarowanych
 // w pami�ci kodu musi by� parzysta

Converter:
    lpm R20, Z
    inc R16
    Loop: adiw R30:R31,1 // inkrementacja Z
    dec R16
    brne Loop
sbiw R30:R31,1
lpm R20, Z  
mov R16,R20
ret
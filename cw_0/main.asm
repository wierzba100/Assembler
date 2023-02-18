 ;### MACROS & defs (.equ)###

; Macro LOAD_CONST loads given registers with immediate value, example: LOAD_CONST  R16,R17 1234 
.MACRO LOAD_CONST  
ldi @0L, low(@2)
ldi @1H, high(@2)
.ENDMACRO 

/*** Display ***/
.equ Digits_P = PORTB
.equ Segments_P = PORTD
//.equ DisplayRefreshPeriod   ; TBD

; SET_DIGIT diplay digit of a number given in macro argument, example: SET_DIGIT 2
.MACRO SET_DIGIT  
    push R19
    push R17
    mov R17, Dig_@0
    push Dig_@0
    rcall DigitTo7segCode
    mov Dig_@0, R17
    out Dig_P, Segment_@0
    clr R19
    out Segments_P, R19
    out Segments_P,  Dig_@0
    rcall DelayInMs
    pop Dig_@0
    pop R17
    pop R19
.ENDMACRO 

; ### GLOBAL VARIABLES ###

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig_0=R2
.def Dig_1=R3
.def Dig_2=R4
.def Dig_3=R5

ldi R16, 0x2
mov R6, R16
ldi R16, 0x4
mov R7, R16
ldi R16, 0x8
mov R8, R16
ldi R16, 0x10
mov R9, R16

.def Segment_0 = R6
.def Segment_1 = R7
.def Segment_2 = R8
.def Segment_3 = R9

; ### INTERRUPT VECTORS ###
.cseg		     ; segment pamiêci kodu programu 

.org 0          rjmp _main               ; skok po resecie (do programu g³ównego)
  ; skok do obs³ugi przerwania timera
.org OC1Aaddr	rjmp _timer_isr
.org PCIBaddr   rjmp _pcinit_isr 

; ### INTERRUPT SEERVICE ROUTINES ###

_pcinit_isr: 

    push R20              ; procedura obs³ugi przerwania timera
    push R16
    push R17

    in R20, SREG
    push R20

    
    ldi R16, 1
    clr R17

   /* cp R16, R10
    BRNE NotEqual*/

    add PulseEdgeCtrL, R16
    adc PulseEdgeCtrH, R17
   /* dec R10
    rjmp Equal

NotEqual:
    inc R10

Equal:*/

    pop R20
    out SREG, R20
 
    pop R17
    pop R16
    pop R20
  

   reti             ; powrót z procedury obs³ugi przerwania (reti zamiast ret)


_ExtInt_ISR: 	 ; procedura obs³ugi przerwania zewnetrznego
    push R20             
    push R16
    push R17

    in R20, SREG
    push R20

    ldi R16, 1
    clr R17
    add PulseEdgeCtrL, R16   ;Inkrementacja
    adc PulseEdgeCtrH, R17

    pop R20
    out SREG, R20
 
    pop R17
    pop R16
    pop R20
reti   ; powrót z procedury obs³ugi przerwania (reti zamiast ret)      

_Timer_ISR:
   push R16 
   push R17
   push R18
   push R19

   in R18, SREG
   push R18

   mov R16, PulseEdgeCtrL
   mov R17, PulseEdgeCtrH
   ldi R18,0x10
   ldi R19,0x27
   rcall Divide
   rcall NumberToDigits
   mov R17, R22
   rcall DigitTo7segCode
   mov Dig_0, R17

   mov R17, R23
   rcall DigitTo7segCode
   mov Dig_1, R17

   mov R17, R24
   rcall DigitTo7segCode
   mov Dig_2, R17

    mov R17, R25  
    rcall DigitTo7segCode
    mov Dig_3, R17

    clr PulseEdgeCtrL
    clr PulseEdgeCtrH
    

   pop R18
   out SREG, R18
   pop R19
   pop R18
   pop R17
   pop R16
reti
; ### MAIN PROGAM ###

_main: 
    clr R10

    push R17
    
    ldi R17, 0x20
    out GIMSK, R17
    ldi R17, 0x01
    out PCMSK0, R17

    ldi R17, 0x0
    out TCCR1A, R17
    ldi R17, 0x0C
    out TCCR1B,  R17
    ldi R17, 0x3D  //F4  //7A //3D
    out OCR1AH,  R17
    ldi R17, 0x09  //  24  //12 //09
    out OCR1AL,  R17
    ldi R17, 0x40
    out TIMSK, R17

    

    pop R17
    sei

MainLoop:   ; presents Digit0-3 variables on a Display
			SET_DIGIT 0
			SET_DIGIT 1
			SET_DIGIT 2
			SET_DIGIT 3

			RJMP MainLoop

; ### SUBROUTINES ###

;*** NumberToDigits ***
;converts number to coresponding digits
;input/otput: R16-17/R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divider

; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ; 
.def Dig2=R24 ; 
.def Dig3=R25 ; 

_NumberToDigits:

	push Dig0
	push Dig1
	push Dig2
	push Dig3

	ldi R18, 0xE8
    ldi R19, 0x03
    rcall Divide
    mov Dig0, R18

    ldi R18, 0x64
    ldi R19, 0x00
    rcall Divide
    mov Dig1, R18

    ldi R18, 0x0A
    ldi R19, 0x00
    rcall Divide
    mov Dig2, R18

    mov Dig3, R16

    mov R16, R22
    mov R17, R23
    mov R18, R24
    mov R19, R25
    
    clr R22
    clr R23
    clr R24
    clr R25

	; output result
	mov R16,Dig0
	mov R17,Dig1
	mov R18,Dig2
	mov R19,Dig3

	pop Dig3
	pop Dig2
	pop Dig1
	pop Dig0

ret

;*** Divide ***
; divide 16-bit nr by 16-bit nr; X/Y -> Qotient,Reminder
; Input/Output: R16-19, Internal R24-25

; inputs
.def XL=R16 ; divident  
.def XH=R17 

.def YL=R18 ; divider
.def YH=R19 

; outputs

.def RL=R16 ; reminder 
.def RH=R17 

.def QL=R18 ; quotient
.def QH=R19 

; internal
.def QCtrL=R24
.def QCtrH=R25

_Divide:push R24 ;save internal variables on stack
        push R25
		
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


		pop R25 ; pop internal variables from stack
		pop R24

		ret

; *** DigitTo7segCode ***
; In/Out - R16

Table: .db 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0xff,0x6f

DigitTo7segCode:

    push R30
    push R31

    push R16
    mov R16, R17
    ldi R30, low(Table<<1) 
    ldi R31, high(Table<<1)
        IncrementationOfZ:
            dec R16
            brbs 2, EndOfIncrementationOfZ
            adiw R30:R31, 1
            rjmp  IncrementationOfZ
        EndOfIncrementationOfZ:
    lpm R16, Z
    mov R17, R16
    pop R16

    pop R31
    pop R30

ret

; *** DelayInMs ***
; In: R16,R17
DealyInMs:  
    push R20
    push R21
    push R24
    push R25
    ldi R20, 0x00 //CounterHOfDelayInMS
    ldi R21, 0x01 //CounterLOfDelayInMS
    Start:
        ldi R24,0xFF
        ldi R25,0xFF
        CounterLoop:sbiw R25:R24, 41
                brcs Loop2
                 rjmp CounterLoop
    Loop2:subi R21, 1
        sbci R20, 0
        brne Start
    End:
    pop R25
    pop R24
    pop R21
    pop R20
ret
; *** OneMsLoop ***
OneMsLoop:	
			push R24
			push R25 
			
			LOAD_CONST R24,R25,2000                    

L1:			SBIW R24:R25,1 
			BRNE L1

			pop R25
			pop R24

			ret




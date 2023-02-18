 ;### MACROS & defs (.equ)###

; Macro LOAD_CONST loads given registers with immediate value, example: LOAD_CONST  R16,R17 1234 
.MACRO LOAD_CONST  
 ldi @0, low(@2)
 ldi @1, high(@2)
.ENDMACRO 

/*** Display ***/
.equ DigitsPort=PORTB
.equ SegmentsPort=PORTD
.equ DisplayRefreshPeriod=0x05

; SET_DIGIT diplay digit of a number given in macro argument, example: SET_DIGIT 2
.MACRO SET_DIGIT  
 out DigitsPort, Segment_@0
 out SegmentsPort, Dig_@0
 rcall DelayInMs
.ENDMACRO 

; ### GLOBAL VARIABLES ###

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig_0=R2
.def Dig_1=R3
.def Dig_2=R4
.def Dig_3=R5

; ### INTERRUPT VECTORS ###
.cseg		     ; segment pamiêci kodu programu 

.org	 0      rjmp	_main	 ; skok do programu g³ównego
.org OC1Aaddr	rjmp  _Timer_ISR
.org PCIBaddr   rjmp  _ExtInt_ISR ; skok do procedury obs³ugi przerwania zenetrznego 

; ### INTERRUPT SEERVICE ROUTINES ###

_ExtInt_ISR: 	 ; procedura obs³ugi przerwania zewnetrznego
 cli
 push R20
 push R21
 in R20, SREG
 push R20
 ldi R21, 1
 clr R20
 add PulseEdgeCtrL, R21
 adc PulseEdgeCtrH, R20
 pop R20
 out SREG, R20
 pop R21
 pop R20
 sei

reti   ; powrót z procedury obs³ugi przerwania (reti zamiast ret)      

_Timer_ISR:
    cli
    push R16
    push R17
    push R18
    push R19

    in R18, SREG
    push R18
    mov R16, PulseEdgeCtrL
    mov R17, PulseEdgeCtrH
    rcall _NumberToDigits
    rcall DigitTo7segCode
    mov Dig_0, R16
    mov R16, R17
    rcall DigitTo7segCode
    mov Dig_1, R16
    mov R16, R18
    rcall DigitTo7segCode
    mov Dig_2, R16
    mov R16, R19  
    rcall DigitTo7segCode
    mov Dig_3, R16
    clr PulseEdgeCtrL
    clr PulseEdgeCtrH    
    pop R18
    out SREG, R18 


	pop R19
    pop R18
    pop R17
    pop R16
    sei
  reti

; ### MAIN PROGAM ###

_main: 
    ; *** Initialisations ***

    ;--- Ext. ints --- PB0
    ldi R16, 0x20
    out GIMSK, R16
    ldi R16, 0x01
    out PCMSK0, R16
	;--- Timer1 --- CTC with 256 prescaller
    ldi R16, 0x0
    out TCCR1A, R16
    ldi R16, 0x0C
    out TCCR1B,  R16
    ldi R16, 0x3D  
    out OCR1AH,  R16
    ldi R16, 0x09
    out OCR1AL,  R16
    ldi R16, 0x40
    out TIMSK, R16			
	;---  Display  --- 
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
    ldi R17, 0x1E
    out DDRB, R17
    ldi R17, 0x7F
    out DDRD, R17
    LOAD_CONST R16, R17, DisplayRefreshPeriod 

	; --- enable gloabl interrupts
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

	; thousands 
    ldi R18, low(1000)
    ldi R19, high(1000)
    rcall _Divide
    mov Dig0, R18


	; hundreads 
    ldi R18, low(100)
    ldi R19, high(100) 
    rcall _Divide
    mov Dig1, R18     
   

	; tens 
    ldi R18, low(10)
    ldi R19, high(10)
    rcall _Divide
    mov Dig2, R18   
  

	; ones 
    mov Dig3, R16

	; otput result
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
		
    clr QCtrL
    clr QCtrH
    rjmp condition
    content:
        sub XL,YL
        sbc XH,YH
        adiw QCtrH:QCtrL, 0x01
    condition:  cp XL,YL
                cpc XH,YH 
    brsh content

    mov QL, QCtrL
    mov QH, QctrH

		pop R25 ; pop internal variables from stack
		pop R24

		ret

; *** DigitTo7segCode ***
; In/Out - R16

Table: .db 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0xff,0x6f

DigitTo7segCode:

push R30
push R31

ldi R30, low(Table<<1)
ldi R31, high(Table<<1)
ZIncrementation:
     dec R16
     brbs 2, EndOfZIncrementation
     adiw R30:R31, 1
     rjmp  ZIncrementation
EndOfZIncrementation:
lpm R16, Z


pop R31
pop R30

ret

; *** DelayInMs ***
; In: R16,R17
DelayInMs:  
            push R24
			push R25

            mov R24, R16
            mov R25, R17

L2:			rcall OneMsLoop
            SBIW R24:R25,1 
			    BRNE L2

			pop R25
			pop R24

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






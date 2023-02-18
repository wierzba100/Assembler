		AREA	MAIN_CODE, CODE, READONLY
		GET		6_LPC213x.s
		
	ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		


DIG_0 	RN R8
DIG_1 	RN R9	
DIG_2 	RN R10	
DIG_3 	RN R11
CURRENT_DIGIT 	RN r12
	
	;Pin Direct
	ldr R4, =IO0DIR  ; ustawienie pinów sterujacych wyswietlaczem na wyjsciowe
	ldr R5, =0xf00f0 ;
	str R5, [R4] ;
	
	ldr R4, =IO1DIR  ;
	ldr R5, =0xff0000 ;
	str R5, [R4]      ;
	
	
	ldr CURRENT_DIGIT, =0x00  ; wyzerowanie licznika cyfr
	
	ldr DIG_0, =0x00
	ldr DIG_1, =0x00
	ldr DIG_2, =0x00
	ldr DIG_3, =0x00
main_loop
	ldr r5, =IO0CLR  ; wlaczenie cyfry o numerze podanym w CURR_DIG,
	ldr r4, =0xF0000
	str r4, [r5]
	
	ldr R5, =IO0SET
	ldr R4, =0x80000
	mov R4, R4, LSR CURRENT_DIGIT
	str R4, [R5]
	
	ldr R4, =0xff0000  ; czyszczenie liczby na wyswietlaczu
	ldr R5, =IO1CLR
	str R4, [R5]
	
	cmp CURRENT_DIGIT, #0   ; zamiana numeru cyfry (CURR_DIG) na kod siedmiosegmentowy (R6)
	moveq R6, DIG_0
	
	cmp CURRENT_DIGIT, #1
	moveq R6, DIG_1
	
	cmp CURRENT_DIGIT, #2
	moveq R6, DIG_2
	
	cmp CURRENT_DIGIT, #3
	moveq R6, DIG_3
	
	adr R4, table
	add R4, R4, R6
	ldrb R6, [R4]
	
	mov R6, R6, LSL #16     	; wpisanie kodu siedmiosegmentowego (R6) do segmentów 
	ldr R5, =IO1SET
	str R6, [R5]
	
	ldr R7, =1
	add DIG_0, R7
	cmp DIG_0, #10
	bne incrementation
	ldr DIG_0, =0x0
	
	add DIG_1, R7
	cmp DIG_1, #10
	bne incrementation
	ldr DIG_1, =0x0
	
	add DIG_2, R7
	cmp DIG_2, #10
	bne incrementation
	ldr DIG_2, =0x0

	add DIG_3, R7
	cmp DIG_3, #10
	bne incrementation
	ldr DIG_3, =0x0
	
	
incrementation	
	ldr R7, =1				; inkrementacja licznika cyfr (CURR_DIG) modulo 4
	add CURRENT_DIGIT, R7
	ldr R7, =4
	cmp CURRENT_DIGIT, R7
	
	EOREQ CURRENT_DIGIT, CURRENT_DIGIT, R7
	
	bl delay_in_ms
	
	
	b main_loop
delay_in_ms	
	ldr R0, = 5
	ldr R1, = 12012
	mul R2, R1, R0
Delay_Loop
	subs R2, R2, #1
	beq finish
	b Delay_Loop
finish
	bx lr
	
table	DCB 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0x7f,0x6f

		END
		

		


;-----------------------------------------------------------------------------
	XL 	equ 	0x50 ; the lower byte of the input value
	YH 	equ 	0x52 ; high byte of the input value
	YL 	equ 	0x53 ; auxiliary value
	Z  	equ 	0x40 ; the lower byte of the input value
	ZZ	equ 	0x41 ; high byte of the input value
;-----------------------------------------------------------------------------
	cseg	AT	0
	ljmp	Main		
;-----------------------------------------------------------------------------
; The algorithm converts a binary value from an 8-bit A/D converter, where the reference voltage of which is 5 V.
;-----------------------------------------------------------------------------
Main:
	mov XL, #0x3E ; input value
	
multiplication_16bit:
	
	mov R1, #0x00
	mov R2, #0x00
	mov R3, XL
	mov R4, #0x64

	mov A, R3
	mov B, R4
	mul AB
	mov 20h, A
	mov 21h, B

	mov A, R3
	mov B, R2
	mul AB
	mov 22h, B
	addc A, 21h
	mov 21h, A
	
	mov A, R1
	mov B, R4
	mul AB
	addc A, 21h
	mov 21h, A
	mov A, B
	addc A, 22h
	mov 22h, A
		
	mov A, R1
	mov B, R2
	mul AB
	addc A, 22h
	mov 22h, A
	mov A, B
	addc A, #00h
	mov 23h, A

	mov YL, 20h
	mov YH, 21h


	mov R6, #0 
	mov R7, #0
	mov B, #16
	mov R0, YL
	mov R1, YH
	mov R2, #33h
	mov R3, #00h

divide_16bit:

	clr C
	mov A, R0
	rlc A
	mov R0, A
	mov A, R1
	rlc A
	mov R1, A
	mov A, R6
	rlc A
	mov R6, A
	mov A, R7
	rlc A
	mov R7, A
	mov A, R6
	clr C
	subb A, R2
	mov DPL, A
	mov A, R7
	subb A, R3
	mov DPH, A
	cpl C

	jnc divide_bit

	mov R7, DPH
	mov R6, DPL

divide_bit:

	mov A, R4
	rlc A
	mov R4, A
	mov A, R5
	rlc A
	mov R5, A
	djnz B, divide_16bit

	mov A, R5
	mov R1, A
	mov A, R4
	mov R0, A
	mov A, R7
	mov R3, A
	mov A, R6
	mov R2, A
	
	mov Z, R0 ; output data
	mov ZZ, R1
	
convert_to_ASCII:

	mov B, #10
	mov A , Z
	div AB
	mov R1, B
	mov B, #10
	div AB
	mov R2, B
	mov R3, A
	mov A, ZZ
	cjne A, #00h, step_further
	ljmp addition
	
step_further:

	mov A, #6
	add A,R1
	mov B, #10
	div AB
	mov R1,B
	add A, #5
	add A, R2
	mov B, #10
	div AB
	mov R2, B
	add A, #2
	add A, R3
	mov B, #10
	div AB
	mov R3,B
	add A,R4
	mov R4,A
	mov b, #10
	mov A,R4
	div AB
	mov R4,B
	mov R5,A
	
addition:

	mov A, R5
	add A, #30h
	mov R5, A

	mov A, R4
	add A, #30h
	mov R4, A

	mov A, R3
	add A, #30h
	mov R3, A

	mov A, R2
	add A, #30h
	mov R2, A

	mov A, R1
	add A, #30h
	mov R1, A

insert_result:

	mov 0x43, R1
	mov 0x42, R2
	mov 0x40, R3
	mov 0x41, #2Eh

	jmp $
	
	END

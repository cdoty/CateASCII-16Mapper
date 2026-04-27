include "../../../System/SystemDefines.inc"

ext	flickerModeEnabled
ext	flickerModeStartSprite

; A - new bank
; E - Function index to call
callBankFunction_:	public	callBankFunction_
	push	bc
	push	de

	ld		b, a				; Save new bank

	ld		a, (currentBank)	; Preserve current bank on the stack
	push	af

	ld		a, b
	ld		(currentBank), a	; Update current bank	
	ld		($7000), a			; Select new bank

	ld		a, e				; Select the function to run
	call	$8000				; Jump to the call table at the start of bank 1

	pop		af
	ld		(currentBank), a	; Update current bank	
	ld		($7000), a			; Restore previous bank

	pop		de
	pop		bc

	ret

initRandSeed_: public initRandSeed_
	push	af

    ld		a, r
    ld		(randSeed), a

	pop		af

	ret

; Based on https://cocotownretro.wordpress.com/2025/07/20/a-retro-random-number-generator-written-by-a-modern-ai/
rand_:	public rand_
	ld		a, (randSeed)

	cp		0
	jp		z, randEOR

	sla		a
	jr		z, randSet
	jr		nc, randSet

randEOR:
	xor		$1D

randSet:
	ld		(randSeed), a

	ret		

; A - The maximum value that can be generated. This allows values from 0 to 255.
randLimit_:	public randLimit_
	push	de
	push	hl

	cp		255					; Use the original rand if the limit is 255
	jr		z, rand_

	inc		a					; Store limit value + 1 in h for multiplication
	ld		h, a				

	call	rand_				; Call original rand routine

	ld		e, a				; Store the value in e for multiplication

	call	mul8				; Multiply h and e. This pushes the limited value into the high byte of mul8_result

	ld		a, h

	pop		hl
	pop		de

	ret		

enableSpriteMagnification_:	public enableSpriteMagnification_
	ld		(spriteMagnificationEnabled), a

	ret

setStartNumericChar_:	public setStartNumericChar_
	dec		a
	ld		(startNumericChar), a

	ret

startupDelay:	public startupDelay
	ld		bc, 0
	
delayLoop:
	dec		bc
	
	ld		a, b
	or		c
	
	jr		nz, delayLoop
	
	ret
	
clearRam:	public clearRam
	ld		hl, RAMStart
	ld		(hl), a
	
	ld		de, RAMStart + 1
	ld		bc,	RAMSize - 1		; Adjust the size for the loop
	
	ldir

	ret

convertValueToAscii_:	public convertValueToAscii_
	push	bc
	push	de
	push	hl

	call	convertToAscii

	pop		hl
	pop		de
	pop		bc

	ret

; HL - Number
; DE - Pointer to string to place 5 digit characters
; Based on https://map.grauw.nl/sources/external/z80bits.html#5.1
convertToAscii:	
	ld		bc, -10000
    call	ConvertDigit
	
	ld		bc, -1000
	call	ConvertDigit
	
	ld		bc, -100
	call	ConvertDigit
	
	ld		c, -10
	call	ConvertDigit
	
	ld		c, b

ConvertDigit:
	ld 		a, (startNumericChar)

DivideResult:
	inc		a
	add		hl, bc

	jr		c, DivideResult

	sbc		hl, bc
	ld		(de), a
	inc		de

	ret

; Multiply two 8 bit values
; H - First value
; E - Second value
; HL - result
; From https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Multiplication
mul8:
	ld		d, 0			; clearing D and L
	ld		l, d
	ld		b, 8			; The 2nd number is 8 bits

mul8Loop:
	add		hl, hl			; advancing a bit
	jp 		nc, mul8Skip	; if zero, we skip the addition (jp is used for speed)
	
	add 	hl, de			; adding to the product if necessary

mul8Skip:
	djnz	mul8Loop

	ret

setupLibrary:	public setupLibrary
	xor		a	
	ld		(frameCount), a					; Reset frame count
	ld		(spriteMagnificationEnabled), a	; Disable sprite magnification
	ld		(flickerModeEnabled), a			; Disable flicker mode
	ld		(flickerModeStartSprite), a		; Set flicker mode start sprite

	ld		a, $80
	ld		(randSeed), a					; Set default random seed to 0x80
	
	ld		a, '0' - 1						; Set the default numeric char
	ld		(startNumericChar), a
	
	ld		a, 1							; Set current bank
	ld		(currentBank), a

	ret

dseg

frameCount:	public	frameCount
	ds	1

randSeed:
	ds	1

spriteMagnificationEnabled:	public spriteMagnificationEnabled
	ds	1

startNumericChar:	public startNumericChar
	ds	1

currentBank:	public currentBank
	ds	1

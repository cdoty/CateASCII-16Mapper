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
	xor		a
	
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

getBankParam0B_:	public getBankParam0B_
	ld		a, (bankParam0)

	ret

getBankParam0W_:	public getBankParam0W_
	ld		hl, (bankParam0)

	ret
	
getBankParam1B_:	public getBankParam1B_
	ld		a, (bankParam1)

	ret

getBankParam1W_:	public getBankParam1W_
	ld		hl, (bankParam1)

	ret
	
getBankParam2B_:	public getBankParam2B_
	ld		a, (bankParam2)

	ret

getBankParam2W_:	public getBankParam2W_
	ld		hl, (bankParam2)

	ret
	
getBankParam3B_:	public getBankParam3B_
	ld		a, (bankParam3)

	ret

getBankParam3W_:	public getBankParam3W_
	ld		hl, (bankParam3)

	ret
	
getBankParam4B_:	public getBankParam4B_
	ld		a, (bankParam4)

	ret

getBankParam4W_:	public getBankParam4W_
	ld		hl, (bankParam4)

	ret
	
getBankParam5B_:	public getBankParam5B_
	ld		a, (bankParam5)

	ret

getBankParam5W_:	public getBankParam5W_
	ld		hl, (bankParam5)

	ret
	
getBankParam6B_:	public getBankParam6B_
	ld		a, (bankParam6)

	ret

getBankParam6W_:	public getBankParam6W_
	ld		hl, (bankParam6)

	ret
	
getBankParam7B_:	public getBankParam7B_
	ld		a, (bankParam7)

	ret

getBankParam7W_:	public getBankParam7W_
	ld		hl, (bankParam7)

	ret
	
setBankParam0B_:	public setBankParam0B_
	ld		(bankParam0), a

	ret

setBankParam0W_:	public setBankParam0W_
	ld		(bankParam0), hl

	ret
	
setBankParam1B_:	public setBankParam1B_
	ld		(bankParam1), a

	ret

setBankParam1W_:	public setBankParam1W_
	ld		(bankParam1), hl

	ret
	
setBankParam2B_:	public setBankParam2B_
	ld		(bankParam2), a

	ret

setBankParam2W_:	public setBankParam2W_
	ld		(bankParam2), hl

	ret
	
setBankParam3B_:	public setBankParam3B_
	ld		(bankParam3), a

	ret

setBankParam3W_:	public setBankParam3W_
	ld		(bankParam3), hl

	ret
	
setBankParam4B_:	public setBankParam4B_
	ld		(bankParam4), a

	ret

setBankParam4W_:	public setBankParam4W_
	ld		(bankParam4), hl

	ret
	
setBankParam5B_:	public setBankParam5B_
	ld		(bankParam5), a

	ret

setBankParam5W_:	public setBankParam5W_
	ld		(bankParam5), hl

	ret
	
setBankParam6B_:	public setBankParam6B_
	ld		(bankParam6), a

	ret

setBankParam6W_:	public setBankParam6W_
	ld		(bankParam6), hl

	ret
	
setBankParam7B_:	public setBankParam7B_
	ld		(bankParam7), a

	ret

setBankParam7W_:	public setBankParam7W_
	ld		(bankParam7), hl

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

; Bank parameters which are accessible across banks. ParamxW and ParamxB cannot both be used unless they are only used to store bytes.
bankParam0:
	ds	2

bankParam1:
	ds	2

bankParam2:
	ds	2

bankParam3:
	ds	2

bankParam4:
	ds	2

bankParam5:
	ds	2

bankParam6:
	ds	2

bankParam7:
	ds	2

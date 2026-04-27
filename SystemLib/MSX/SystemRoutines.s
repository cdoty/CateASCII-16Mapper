include "../../System/GameDefines.inc"
include "../../System/SystemDefines.inc"
include "../../System/VRAMDefines.inc"

ext	nmiCount
ext	lastNMICount
ext	frameCount
ext	writeVDPReg
ext	spriteMagnificationEnabled
ext	nmiHandler

setMode2:	public setMode2
	ld		b, $02						; Disable external VDP interrupt, set M2 for Graphics mode 2
	ld		c, 0
	call	writeVDPReg

	ld		a, (spriteMagnificationEnabled)
	or		SpriteSize
	or		$A0

	ld		b, a						; Enable 16K VRAM, Screen, NMI interrupt. Sprite size is set by SpriteSize define
	ld		c, 1
	call	writeVDPReg

	ld		b, Screen1VRAM / $400		; Set Name Table location.
	ld		c, 2
	call	writeVDPReg

	ld		b, Color1VRAM / $40 OR $7F	; Set Color Table location.
	ld		c, 3
	call	writeVDPReg

	ld		b, Tile1VRAM / $800 OR 3	; Set Pattern Table location.
	ld		c, 4
	call	writeVDPReg

	ld		b, SpriteAttributes / $80	; Set Sprite Attribute Table location.
	ld		c, 5
	call	writeVDPReg

	ld		b, SpritePattern / $800		; Set Sprite Pattern Table location.
	ld		c, 6
	call	writeVDPReg

	ld		b, $00						; Set background color to black
	ld		c, 7
	call	writeVDPReg

	ret
	
; Turn on screen
; void turnOnScreen();
turnOnScreen_: public turnOnScreen_
	ld		a, (spriteMagnificationEnabled)
	or		SpriteSize
	or		$E0

	ld		b, a						; Enable 16K VRAM, Screen, NMI interrupt. Sprite size is set by SpriteSize define
	ld		c, 1
	call	writeVDPReg

	ret
	
; Turn off screen
; void turnOffScreen();
turnOffScreen_:	public turnOffScreen_
	ld		a, (spriteMagnificationEnabled)
	or		SpriteSize
	or		$A0

	ld		b, a						; Enable 16K VRAM, Screen, NMI interrupt. Sprite size is set by SpriteSize define
	ld		c, 1
	call	writeVDPReg

	ret

enableIRQ_:	public enableIRQ_
	; Clear nmi counts
	xor		a
	ld		(nmiCount), a
	ld		(lastNMICount), a

	ei

	ret

disableIRQ_:	public disableIRQ_
	di

	ret

; void waitForVBlank();
waitForVBlank_:	public waitForVBlank_
	ld		a, (lastNMICount)
	ld		b, a

waitVBlankLoop:
	ld		a, (nmiCount)
	cp		b
	
	jr		z, waitVBlankLoop
	
	ld		(lastNMICount), a

	ld		a, (frameCount)
	inc		a
	ld		(frameCount), a

	ret

; Change interrupt, used for cassette and disk games
changeInterrupt:	public changeInterrupt
	di								; Start of critical region

	ld		de, oldInterrupt		; Get address of old int. hook saved area
	ld		hl, InterruptHook		; Get address of interrupt entry hook
	ld		bc, 5					; Length of hook is 5 bytes
	ldir							; Transfer

	ld		a, $C3					; Set new hook code
	ld		(InterruptHook), a		; 
	ld		hl, nmiHandler			; Get our interrupt entry point
	ld		(InterruptHook + 1), hl	; Set new interrupt entry point
	ld		a, $C9					; 'RET' operation code
	ld		(InterruptHook + 3), a	; set operation code of 'RET'
	
	ei								; End of critical region
	
	ret

setupInterrupt:	public setupInterrupt
	di								; Start of critical region

	ld		de, oldInterrupt		; Get address of old int. hook saved area
	ld		hl, InterruptHook		; Get address of interrupt entry hook
	ld		bc, 5					; Length of hook is 5 bytes
	ldir							; Transfer

	call	getCurrentSlot			; Get my slot address

	ld		(InterruptHook + 1), a	; Set slot address
	ld		a, $F7					; 'RST 30H' inter-slot call operation code
	ld		(InterruptHook), a		; Set new hook op-code
	ld		hl, nmiHandler			; Get our interrupt entry point
	ld		(InterruptHook + 2), hl	; Set new interrupt entry point
	ld		a, $C9					; 'RET' operation code
	ld		(InterruptHook + 4), a	; Set operation code of 'RET'
	
	ei								; End of critical region
	
	ret

; Gets the current slot and enables the 2nd handle of a 32k ROM.
getCurrentSlot:
	push	bc
	push	hl
	
	call	ReadSlotReg				; Read slot register

	rrca							; Move it to bit 0 and 1 of A
	rrca
	and		$03						; Get bit 0 and 1
	ld		c, a					; Set primary slot No.
	ld		b, 0
	ld		hl,	ExpansionTable		; See if the slot is expanded or not
	add		hl, bc
	ld		a, (hl)					; Set MSB if so
	and		$80
	or		c
	ld		c, a
	inc		hl						; Point to SLTTBL entry
	inc		hl
	inc		hl
	inc		hl
	ld		a, (hl)					; Get what is currently output to expansion slot register

	and		$0C						; Get bits 3,2
	or		c						; Finally form slot address

	push	af

	ld		h, $80					; Select ROM at $8000-BFFF
	call	EnableSlot

	pop		af

	pop		hl
	pop		bc
	
	ret

dseg

oldInterrupt:
	ds	5


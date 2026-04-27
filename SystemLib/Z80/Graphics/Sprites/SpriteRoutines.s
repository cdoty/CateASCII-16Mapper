include "../../../../System/GameDefines.inc"
include "../../../../System/SystemDefines.inc"
include "../../../../System/VRAMDefines.inc"

ext	transferToVRAM_
ext	clearVRAMWithParameters

clearSprites_:	public clearSprites_
	push	bc
	push	de
	push	hl

	ld		b, MaxSprites

	ld		hl, spriteTable

clearSpriteLoop:
	ld		(hl), HiddenSpriteY
	inc		hl
	ld		(hl), HiddenSpriteX
	inc		hl
	ld		(hl), $00
	inc		hl
	ld		(hl), $00
	inc		hl
	
	dec		b
	jr		nz, clearSpriteLoop
	
	call	transferSpriteAttributeTable
	
	pop		hl
	pop		de
	pop		bc
	
	ret

setActiveSprites_:	public setActiveSprites_
	ld		(activeSprites), a

	ret

setStartSprite_:	public setStartSprite_
	ld		(flickerModeStartSprite), a

	ret

enableFlickerMode_:	public enableFlickerMode_
	push	af

	ld		(flickerModeEnabled), a	; Enable/Disable flicker mode
	
	xor		a
	ld		(flickerModeFrame), a		; Reset flicker mode frame
	ld		(flickerModeStartSprite), a	; Reset flicker mode start sprite
	
	pop		af
	
	ret

updateSprites_:	public updateSprites_
	push	af

	; Set update sprite attributes flag
	ld		a, 1
	ld		(updateSpriteAttributes), a

	pop		af
	
	ret
	
updateSpriteAttributeTable:	public updateSpriteAttributeTable
	; No need to disable interrupts since we're in VBlank	
	xor		a							; Clear update sprite attributes flag
	ld		(updateSpriteAttributes), a

	ld		a, (flickerModeEnabled)	

	or		a
	jr		nz, checkFlicker

transferSpriteAttributeTable:
	; Do the normal DMA transfer to VRAM
	ld		hl, spriteTable
	ld		de, SpriteAttributes
	ld		bc, 4 * MaxSprites
	call	transferToVRAM_

	ret

checkFlicker:
	ld		a, (activeSprites)			; Skip update if there are no active sprites

	or		a							
	jr		nz, checkFlickerMode

	ret

checkFlickerMode:
	ld		a, (flickerModeFrame)
	
	or		a
	jr		nz, updateSpriteAttributeReverse

updateSpriteAttributeForward:	public updateSpriteAttributeForward
	ld		b, 0						; Clear b

	ld		a, (activeSprites)
	ld		c, a

	ld		a, (flickerModeStartSprite)
	add		a, c

	sla		a							; Multiply by 4 to skip 4 bytes per sprite. Will never exceed 255 since the highest value is 31.
	sla		a
	
	ld		c, a
	
	ld		hl, spriteTable
	ld		de, SpriteAttributes
	call	transferToVRAM_

	ld		a, 1							; Swap to backward transfer next time
	ld		(flickerModeFrame), a

	ret

updateSpriteAttributeReverse:	public updateSpriteAttributeReverse
	ld		hl, spriteTable
	ld		de, SpriteAttributes

	ld		b, 0						; Clear b	

	ld		a, (flickerModeStartSprite)	; Get the number of sprites to transfer
	ld		c, a

	sla		c							; Multiply by 4 to transfer 4 bytes per sprite. Will never exceed 255 since the highest value is 31.
	sla		c

	push	bc

	call	transferToVRAM_

	pop		bc

	ld		a, (activeSprites)			; Skip to the end of the active sprite list
	dec		a

	sla		a							; Multiply by 4 to skip 4 bytes per sprite. Will never exceed 255 since the highest value is 31.
	sla		a

	add		a, c
	ld		c, a
	
	ld		hl, spriteTable				; Move to the last active entry in the sprite table
	add		hl, bc						

	ld		de, -8						; Offset to the start of the previous sprite

	ld		a, (activeSprites)			; Get the number of sprites to transfer
	ld		b, a

updateReverseLoop:
	ld		a, (hl)						; Transfer four bytes per sprite
	out		(VDPBASE), a
	inc		hl

	ld		a, (hl)
	out		(VDPBASE), a
	inc		hl

	ld		a, (hl)
	out		(VDPBASE), a
	inc		hl

	ld		a, (hl)
	out		(VDPBASE), a
	inc		hl

	add		hl, de					; Move to the start of the previous sprite

	dec		b						; Repeat for the remaining sprite
	jr		nz, updateReverseLoop	
	
	in		a, (VDPReadBase + WriteOffset)	; Acknowledge interrupt

	xor		a						; Swap to forward transfer next time
	ld		(flickerModeFrame), a

	ret

selectSprite_:	public selectSprite_
	push	af
	push	bc
	push	hl

	; Multiply selectedSprite by 4.
	sla		a
	sla		a

	ld		b, 0
	ld		c, a

	ld		hl, spriteTable
	add		hl, bc

	ld		(selectedSprite), hl

	pop		hl
	pop		bc
	pop		af
		
	ret

; A: Sprite X
; E: Sprite Y
setSpritePosition_:	public setSpritePosition_
	push	hl

	ld		hl, (selectedSprite)

	ld		(hl), e
	inc		hl
	
	ld		(hl), a

	pop		hl

	ret

; A: Sprite tile
setSpriteTile_:	public setSpriteTile_
	push	hl

	ld		hl, (selectedSprite)

	; Skip x and y position
	inc		hl
	inc		hl

	ld		(hl), a

	pop		hl

	ret

; A: Sprite color
setSpriteColor_:	public setSpriteColor_
	push	hl

	ld		hl, (selectedSprite)

	; Skip x and y position and tile
	inc		hl
	inc		hl
	inc		hl

	ld		(hl), a

	pop		hl

	ret

; A: Sprite tile
; E: Sprite color
setSpriteTileAndColor_:	public setSpriteTileAndColor_
	push	hl

	ld		hl, (selectedSprite)

	; Skip x and y position
	inc		hl
	inc		hl

	ld		(hl), a
	inc		hl
	
	ld		(hl), e

	pop		hl

	ret

dseg

spriteTable:	public spriteTable
	ds	4 * MaxSprites

updateSpriteAttributes:	public updateSpriteAttributes
	ds	1

; Stores hl of the selected sprite
selectedSprite:	public selectedSprite	
	ds	2

; Flicker mode enabled
flickerModeEnabled:	public flickerModeEnabled
	ds	1

flickerModeFrame:
	ds	1
	
flickerModeStartSprite:	public flickerModeStartSprite
	ds	1

; Stores number of active sprites for forward and reverse transfer routines
activeSprites:	public activeSprites
	ds	1

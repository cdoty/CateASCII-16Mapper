include "../../../../System/SystemDefines.inc"

; B - Value
; C - Register
writeVDPReg:	public writeVDPReg
	in		a, (VDPReadBase + WriteOffset)	; Reset register write mode
	
	ld		a, b					; Write VDP data
	out		(VDPBase + WriteOffset), a

	ld		a, $80					; Write VDP register | $80
	or		c
	out		(VDPBase + WriteOffset), a

	ret
	
clearVRAM:	public clearVRAM
	ld		hl, 0
	ld		de, $4000

; HL: VRAM start address
; DE: Bytes to clear
clearVRAMWithParameters:	public clearVRAMWithParameters
	in		a, (VDPReadBase + WriteOffset)	; Reset register write mode
	
	ld		a, l
	out		(VDPBase + WriteOffset), a
	
	ld		a, h
	or		$40
	out		(VDPBase + WriteOffset), a
	
clearVRAMLoop:
	xor		a
	out		(VDPBase), a
		
	dec		de
	ld		a, d
	or		e
	
	jr		nz, clearVRAMLoop
	
	in		a, (VDPReadBase + WriteOffset)	; Acknowledge interrupt

	ret
		
; A - value
; DE - _dest
writeToVRAM_:	public writeToVRAM_
	push	af
	push	bc
	push	de

	ld		b, a
	
	in		a, (VDPReadBase + WriteOffset)	; Reset register write mode

	ld		a, e
	out		(VDPBase + WriteOffset), a
	
	ld		a, d
	or		$40
	out		(VDPBase + WriteOffset), a
	
	ld		a, b
	out		(VDPBase), a

	in		a, (VDPReadBase + WriteOffset)	; Acknowledge interrupt

	pop		de
	pop		bc
	pop		af
	
	ret

; HL: _source
; DE: _dest
; BC: _size
transferToVRAM_:	public transferToVRAM_
	in		a, (VDPReadBase + WriteOffset)	; Reset register write mode
	
	ld		a, e
	out		(VDPBase + WriteOffset), a
	
	ld		a, d
	or		$40
	out		(VDPBase + WriteOffset), a
	
transferVRAMLoop:
	ld		a, (hl)
	out		(VDPBase), a
		
	inc		hl
	dec		bc
	ld		a, b
	or		c
	
	jr		nz, transferVRAMLoop
	
	in		a, (VDPReadBase + WriteOffset)	; Acknowledge interrupt

	ret

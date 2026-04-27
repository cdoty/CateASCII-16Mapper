include "../../../../../System/SystemDefines.inc"

; D - Register
; E - Value
writePSGReg:	public writePSGReg
	ld		a, b
	out		(PSGRegisterPort), a

	ld		a, c
	out		(PSGWritePort), a

	ret

; B - Register
; A - read value
readPSGReg:	public readPSGReg
	ld		a, b
	out		(PSGRegisterPort), a

	in		a, (PSGReadPort)

	ret

resetSound:	public resetSound
	ld		d, 7			; Select register 7
	ld		e, $BF			; Enable port A, disable all noise and sound channels

	call	writePSGReg

	ret

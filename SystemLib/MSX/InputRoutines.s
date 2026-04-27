include "../../System/SystemDefines.inc"

clearJoysticks_:	public clearJoysticks_
	; Clear joystick values
	xor		a
	ld		(joystick1Value), a
	ld		(joystick1LastValue), a
	ld		(joystick2Value), a
	ld		(joystick2LastValue), a

	ret

updateJoysticks_:	public updateJoysticks_
	ld		a, (Joystick1Value)
	ld		(Joystick1LastValue), a
	ld		a, (Joystick2Value)
	ld		(Joystick2LastValue), a

	call	readJoysticks
	
	ret

readJoystick1_:	public readJoystick1_
	ld		a, (joystick1Value)

	ret

readJoystick2_:	public readJoystick2_
	ld		a, (joystick2Value)

	ret

readJoysticks:
	; Read joystick port 1
	ld		a, 15
	out		(PSGRegisterPort), a
	in		a, (PSGReadPort)
	
	; Turn off joystick input selection, and enable pins 6 and 7, to read joystick 0.
	and		$8F
	out		(PSGWritePort), a

	; Read joystick 1 data
	ld		a, 14
	out		(PSGRegisterPort), a
	in		a, (PSGReadPort)

	; Invert and mask bits
	cpl
	and		$3F

	; Store result
	ld		(joystick1Value), a

	; Read joystick 2 data
	ld		a, 15
	out		(PSGRegisterPort), a
	in		a, (PSGReadPort)
	
	; Turn on joystick input selection to read joystick 1
	or		$40
	out		(PSGWritePort), a

	ld		a, 14
	out		(PSGRegisterPort), a
	in		a, (PSGReadPort)

	; Invert and mask bits
	cpl
	and		$3F

	; Store result
	ld		(joystick2Value), a

	ret

dseg

joystick1Value:
    ds	1

joystick1LastValue:
    ds	1

joystick2Value:
    ds	1

joystick2LastValue:
    ds	1

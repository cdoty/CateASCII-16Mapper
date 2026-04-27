RAMStart		equ	$E000	; Ram start address, allows cartridge to work on systems with 8k ram
RAMSize			equ	$FF0	; Ram size
StackStart		equ	$F000	; Stack start
ExtraRAMStart	equ	$C000	; Extra ram start address
ExtraRAMSize	equ	$2000	; Extra ram size
VDPBase			equ	$98		; VDP data base port 
VDPReadBase		equ	VDPBase	; VDP control base port
WriteOffset		equ	1		; Difference between read and write ports for each base port
Joystick1Port	equ	$DC		; Joystick data port 1
Joystick2Port	equ	$DD		; Joystick data port 2
PSGRegisterPort	equ	$A0		; PSG latch port
PSGWritePort	equ	$A1		; PSG write port
PSGReadPort		equ	$A2		; PSG read port
ReadSlotReg		equ	$138	; Read slot register
EnableSlot		equ	$24		; Enable slot register
ExpansionTable	equ	$FCC1	; Expansion ExpansionTable
InterruptHook	equ	$FD9A	; Interrupt hook
SystemSprites	equ	32		; Maximum system sprites
JoystickButtons	equ	2		; Joystick buttons supported
HiddenSpriteX	equ	0		; Hidden sprite position
HiddenSpriteY	equ	209

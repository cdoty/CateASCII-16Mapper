ext	startup

_ASCII16ENTRY:	public _ASCII16ENTRY
	db	'AB'	; Cartridge header
	dw	startup	; Init routine
	dw	0		; Do not add instructions to basic
	dw	0		; Device number
	dw	0		; Do not provide a tokenize basic program
	ds	6		; Reserved block

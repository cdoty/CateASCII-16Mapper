ext main_

cseg

_BANKTABLE:	public _BANKTABLE
	cp	0
	jr	nz, bankNotFound
	
	jp	main_

bankNotFound:
	jp	bankNotFound

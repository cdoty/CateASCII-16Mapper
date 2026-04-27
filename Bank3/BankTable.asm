ext bankEntry_

cseg

_BANKTABLE:	public _BANKTABLE
	cp	0
	jr	nz, bankNotFound
	
	jp	bankEntry_

bankNotFound:
	jp	bankNotFound

ext showTitle_
ext showGameOver_

cseg

_BANKTABLE:	public _BANKTABLE
	cp	0
	jr	nz, checkShowGameOver
	
	jp	showTitle_

checkShowGameOver:
	cp	1
	jr	nz, bankNotFound
	
	jp	showGameOver_

bankNotFound:
	jp	bankNotFound

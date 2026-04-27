include "SystemDefines.inc"

ext	resetSound
ext	clearRam
ext	startupDelay
ext	setupLibrary
ext setMode2
ext	clearVRAM
ext	setupInterrupt
ext	callBankFunction_

startup: public startup
	ld		sp, StackStart
	
	call	resetSound			; Reset sound to stop noise at startup
	call	clearRam			; Clear ram	
	call	startupDelay		; Delay before starting
	call	setupLibrary		; Setup library

	call	setMode2			; Set mode 2
	call	clearVRAM			; Clear VRAM

	call	setupInterrupt		; Setup interrupt
	
	ld		a, 1				; Call the main function in bank 1
	ld		e, 0
	call	callBankFunction_

endLoop:
	jp		endLoop

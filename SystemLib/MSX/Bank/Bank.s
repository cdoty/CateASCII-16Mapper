include "../../../System/SystemDefines.inc"

; A - new bank
; E - Function index to call
callBankFunction_:	public	callBankFunction_
	push	bc
	push	de

	ld		b, a				; Save new bank

	ld		a, (currentBank)	; Preserve current bank on the stack
	push	af

	ld		a, b
	ld		(currentBank), a	; Update current bank	
	ld		($7000), a			; Select new bank

	ld		a, e				; Select the function to run
	call	$8000				; Jump to the call table at the start of bank 1

	pop		af
	ld		(currentBank), a	; Update current bank	
	ld		($7000), a			; Restore previous bank

	pop		de
	pop		bc

	ret

setupBanking:	public setupBanking
	ld		a, 1							; Set current bank
	ld		(currentBank), a

	ret

getBankParam0B_:	public getBankParam0B_
	ld		a, (bankParam0)

	ret

getBankParam0W_:	public getBankParam0W_
	ld		hl, (bankParam0)

	ret
	
getBankParam1B_:	public getBankParam1B_
	ld		a, (bankParam1)

	ret

getBankParam1W_:	public getBankParam1W_
	ld		hl, (bankParam1)

	ret
	
getBankParam2B_:	public getBankParam2B_
	ld		a, (bankParam2)

	ret

getBankParam2W_:	public getBankParam2W_
	ld		hl, (bankParam2)

	ret
	
getBankParam3B_:	public getBankParam3B_
	ld		a, (bankParam3)

	ret

getBankParam3W_:	public getBankParam3W_
	ld		hl, (bankParam3)

	ret
	
getBankParam4B_:	public getBankParam4B_
	ld		a, (bankParam4)

	ret

getBankParam4W_:	public getBankParam4W_
	ld		hl, (bankParam4)

	ret
	
getBankParam5B_:	public getBankParam5B_
	ld		a, (bankParam5)

	ret

getBankParam5W_:	public getBankParam5W_
	ld		hl, (bankParam5)

	ret
	
getBankParam6B_:	public getBankParam6B_
	ld		a, (bankParam6)

	ret

getBankParam6W_:	public getBankParam6W_
	ld		hl, (bankParam6)

	ret
	
getBankParam7B_:	public getBankParam7B_
	ld		a, (bankParam7)

	ret

getBankParam7W_:	public getBankParam7W_
	ld		hl, (bankParam7)

	ret
	
setBankParam0B_:	public setBankParam0B_
	ld		(bankParam0), a

	ret

setBankParam0W_:	public setBankParam0W_
	ld		(bankParam0), hl

	ret
	
setBankParam1B_:	public setBankParam1B_
	ld		(bankParam1), a

	ret

setBankParam1W_:	public setBankParam1W_
	ld		(bankParam1), hl

	ret
	
setBankParam2B_:	public setBankParam2B_
	ld		(bankParam2), a

	ret

setBankParam2W_:	public setBankParam2W_
	ld		(bankParam2), hl

	ret
	
setBankParam3B_:	public setBankParam3B_
	ld		(bankParam3), a

	ret

setBankParam3W_:	public setBankParam3W_
	ld		(bankParam3), hl

	ret
	
setBankParam4B_:	public setBankParam4B_
	ld		(bankParam4), a

	ret

setBankParam4W_:	public setBankParam4W_
	ld		(bankParam4), hl

	ret
	
setBankParam5B_:	public setBankParam5B_
	ld		(bankParam5), a

	ret

setBankParam5W_:	public setBankParam5W_
	ld		(bankParam5), hl

	ret
	
setBankParam6B_:	public setBankParam6B_
	ld		(bankParam6), a

	ret

setBankParam6W_:	public setBankParam6W_
	ld		(bankParam6), hl

	ret
	
setBankParam7B_:	public setBankParam7B_
	ld		(bankParam7), a

	ret

setBankParam7W_:	public setBankParam7W_
	ld		(bankParam7), hl

	ret
	
dseg

currentBank:	public currentBank
	ds	1

; Bank parameters which are accessible across banks. ParamxW and ParamxB cannot both be used unless they are only used to store bytes.
bankParam0:
	ds	2

bankParam1:
	ds	2

bankParam2:
	ds	2

bankParam3:
	ds	2

bankParam4:
	ds	2

bankParam5:
	ds	2

bankParam6:
	ds	2

bankParam7:
	ds	2

#include "../SystemLib/Include/Bank.h"

void main()
{
	setBankParam0W(0x0102);
	setBankParam0B(0x03);
	setBankParam1W(0x0304);
	setBankParam1B(0x05);

	byte	bValue	= getBankParam0B();
	word	wValue	= getBankParam1W();

	callBankFunction(2, 0);	// Call showTitle() in bank 2
	callBankFunction(3, 0);	// Call startGame() in bank 3
}

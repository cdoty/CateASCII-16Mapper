#include "Game.h"
#include "../SystemLib/Include/Graphics.h"
#include "../SystemLib/Include/Bank.h"

void bankEntry()
{
	turnOnScreen();

	startGame();

	callBankFunction(2, 1);	// Call showGameOver() in bank 2

	turnOffScreen();
}

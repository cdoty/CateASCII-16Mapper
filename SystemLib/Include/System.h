// Enable IRQ
extern void enableIRQ();

// Disable IRQ
extern void disableIRQ();

// Init random seed
extern void initRandSeed();

// Get random value
extern byte rand();

// Get random value with limit
extern byte randLimit(byte _limit);

// Enable sprite magnification
extern void enableSpriteMagnification(byte _enable);

// Set start numeric char
extern void setStartNumericChar(byte _start);

// Convert value to Ascii
extern void convertValueToAscii(word _score, ptr<byte> _pString);

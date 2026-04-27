// Turn on screen
extern void turnOnScreen();

// Turn off screen
extern void turnOffScreen();

// Write to VRAM
extern void writeToVRAM(byte _value, word _dest);

// Transfer to VRAM
extern void transferToVRAM(ptr<byte> _source, word _dest, word _size);

// Wait for vblank
extern void waitForVBlank();

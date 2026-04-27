// Clear sprites
extern void clearSprites();

// Update sprites during the next VBlank
extern void updateSprites();

// Enable flicker mode (0: Disable 1: Enable)
extern void enableFlickerMode(byte _iEnable);

// Set active sprites
extern void setActiveSprites(byte _iActiveSprites);

// Set start sprites
extern void setStartSprite(byte _iStartSprite);

// Select sprite
extern void selectSprite(byte _index);

// Set sprite position
extern void setSpritePosition(byte _x, byte _y);

// Set sprite tile
extern void setSpriteTile(byte _tile);

// Set sprite color
extern void setSpriteColor(byte _color);

// Set sprite tile and color
extern void setSpriteTileAndColor(byte _tile, byte _color);

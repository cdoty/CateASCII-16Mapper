# Set the name of the output ROM.
name		= Test

# Set the output file extension. Some emulators look for specific extension.
extension	= rom

# Set the console type, based on the directories in tms9918lib.
console		= MSX

# Set the output rom size
romSize		= 131072

# Set the ROM and RAM start addresses
bank0seg	= 4000-7FFF
cseg		= 8000-BFFF
dseg	 	= E000

# Set comment settings
mameSystem	= cx5mu
cpuTag		= :maincpu

# Set the tools path.
TOOLS_PATH	= ../Tools

# Set the CATE compiler path. Bin and lib are expected to exist inside the directory.
CATE_PATH	= $(TOOLS_PATH)/Cate
BIN_PATH	= $(CATE_PATH)/bin
LIB_PATH	= $(CATE_PATH)/lib

# CATE/ASM8/Lib compile ID. (ie CATEXX.exe)
compileType	= 80

# Customize the processor type and the TMS-9918 interface type, if needed.
SharedC_S	= SystemLib/Z80/Decompression/IO/C/BitBusterDepackIRQ.s
SharedC_S	+= $(wildcard SystemLib/Z80/Graphics/IO/C/*.s)
SharedC_S	+= $(wildcard SystemLib/Z80/Graphics/Sprites/C/*.s)
SharedC_S	+= $(wildcard SystemLib/Z80/Shared/C/*.s)
SharedC_S	+= $(wildcard SystemLib/Z80/Sound/IO/AY38910/C/*.s)

SystemC_S	= SystemLib/$(console)/crt0/C/Ascii16.s
SystemC_S	+= $(wildcard SystemLib/$(console)/C/*.s)
SystemC_S	+= $(wildcard System/C/*.s)

SharedZ_S	= SystemLib/Z80/Decompression/IO/Z/BitBusterDepackIRQ.s
SharedZ_S	+= $(wildcard SystemLib/Z80/Graphics/IO/Z/*.s)
SharedZ_S	+= $(wildcard SystemLib/Z80/Graphics/Sprites/Z/*.s)
SharedZ_S	+= $(wildcard SystemLib/Z80/Shared/Z/*.s)
SharedZ_S	+= $(wildcard SystemLib/Z80/Sound/IO/AY38910/Z/*.s)

SystemZ_S	= SystemLib/$(console)/crt0/Z/Ascii16.s
SystemZ_S	+= $(wildcard SystemLib/$(console)/Z/*.s)
SystemZ_S	+= $(wildcard System/Z/*.s)

Bank1_C		= $(wildcard Bank1/*.c)
Bank1_ASM	= Bank1/BankTable.asm

Bank2_C		= $(wildcard Bank2/*.c)
Bank2_ASM	= Bank2/BankTable.asm

Bank3_C		= $(wildcard Bank3/*.c)
Bank3_ASM	= Bank3/BankTable.asm

Bank0_Obj 	= $(SystemC_S:.s=.obj)
Bank0_Obj 	+= $(SharedC_S:.s=.obj)

Bank1_Obj 	= $(SystemZ_S:.s=.obj)
Bank1_Obj 	+= $(SharedZ_S:.s=.obj)
Bank1_Obj	+= $(Bank1_ASM:.asm=.obj)
Bank1_Obj	+= $(Bank1_C:.c=.obj)

Bank2_Obj 	= $(SystemZ_S:.s=.obj)
Bank2_Obj 	+= $(SharedZ_S:.s=.obj)
Bank2_Obj	+= $(Bank2_ASM:.asm=.obj)
Bank2_Obj	+= $(Bank2_C:.c=.obj)

Bank3_Obj 	= $(SystemZ_S:.s=.obj)
Bank3_Obj 	+= $(SharedZ_S:.s=.obj)
Bank3_Obj	+= $(Bank3_ASM:.asm=.obj)
Bank3_Obj	+= $(Bank3_C:.c=.obj)

bankObjects	= $(Bank0_Obj)
bankObjects	+= $(Bank1_Obj)
bankObjects	+= $(Bank2_Obj)
bankObjects	+= $(Bank3_Obj)

libs 		= $(LIB_PATH)/cate$(compileType).lib

lists 		= $(SystemC_S:.s=.lst)
lists 		+= $(SharedC_S:.s=.lst)
lists 		+= $(SystemZ_S:.s=.lst)
lists 		+= $(SharedZ_S:.s=.lst)
lists 		+= $(Bank1_C:.c=.lst)
lists 		+= $(Bank1_ASM:.asm=.lst)
lists 		+= $(Bank2_C:.c=.lst)
lists 		+= $(Bank2_ASM:.asm=.lst)
lists 		+= $(Bank3_C:.c=.lst)
lists 		+= $(Bank3_ASM:.asm=.lst)

all: $(name).$(extension)

$(name).$(extension): Bank00.bin Bank01.bin Bank02.bin Bank03.bin
	copy /Y /B Bank*.bin $@
	$(TOOLS_PATH)/PadFile 255 $(romSize) $@
#	$(TOOLS_PATH)/CreateComments $(mameSystem) $(cpuTag) Bank00.symbols.txt $(name).$(extension) ../../mame/comments
#	$(TOOLS_PATH)/CreateSym Bank00.symbols.txt $(name).sym

Bank00.bin: $(Bank0_Obj)
	$(BIN_PATH)/LinkLE $@ $(bank0seg) $(dseg) $(Bank0_Obj)

Bank01.bin: $(Bank1_Obj) $(libs)
	$(BIN_PATH)/LinkLE $@ $(cseg) $(dseg) $(bank0seg) $(Bank1_Obj) $(libs)

Bank02.bin: $(Bank2_Obj) $(libs)
	$(BIN_PATH)/LinkLE $@ $(cseg) $(dseg) $(bank0seg) $(Bank2_Obj) $(libs)

Bank03.bin: $(Bank3_Obj) $(libs)
	$(BIN_PATH)/LinkLE $@ $(cseg) $(dseg) $(bank0seg) $(Bank3_Obj) $(libs)

clean:
	rm -f $(bankObjects)
	rm -f $(lists)
	rm -f $(name).$(extension)
	rm -f $(name).sym
	rm -f Bank*.bin
	rm -f Bank*.symbols.txt

depend:
#	makedepend -fmakefile $(Bank1_C) $(Bank2_C) $(Bank3_C) 
#	rm makefile.bak

%.asm: %.c
	$(BIN_PATH)/Cate$(compileType) $<

%.obj: %.asm
	$(BIN_PATH)/Asm$(compileType) $<
	
%.obj: %.s
	$(BIN_PATH)/Asm$(compileType) $<

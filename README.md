# Cate ASCII-16 Mapper for the CATE compiler.
A CATE compiler project demonstrating an ASCII-16 mapper using the [CATE](https://github.com/inufuto/Cate) compiler.
The code was created because CATE lacks native support for banking and is a limiting factor in it's use for larger projects.

Location $4000-$7FFF is used as fixed bank 0 and location $8000-$BFFF is used for swappable banks. The tool abuses the zero segment feature of CATE to compile the fixed bank to zseg when compiling the additional banks. This is accomplished by compiling the fixed bank code with a wrapper file specifying cseg or zseg as the target.
Each bank is compiled with a callable function to call internal functions.
Once all of the banks are compiled, they must be concatenated together into a ROM file.

There are 8 locations that can be used to share information across bank. They can either store bytes or words.
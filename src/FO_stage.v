//This module will be instantiated in FO three times along with some more functionality
module FO_stage	(						//
		output wire [15:0] FO_output,		

		input wire [15:0] FO_input,
		input wire [15:0]KOi_16bit_indexed,	
		input wire [15:0]Klli_16bit_indexed

		);


wire [15:0] a1 = FO_input ^ KOi_16bit_indexed;

wire [8:0] a,a2,c,f;
wire [6:0] b,d,e;


rom_S9 rom_9_1	(
		.address(a1[15:7]),
		.data(a)
		);

rom_S7 rom_7_1	(
		.address(a1[6:0]),
		.data(b)
		);


assign a2 = a ^ {2'b00,a1[6:0]};//confirm where to append zeros on msb or lsb??

rom_S9 rom_9_2	(
		.address(a2 ^ Klli_16bit_indexed[8:0]),
		.data(c)
		);

assign d = (b ^ a2[6:0]) ^ Klli_16bit_indexed[15:9];		//check which bits to truncate least significant or most significant

rom_S7 rom_7_2	(
		.address(d),
		.data(e)
		);


assign f = c^{2'b00,d};		//confirm where to append zeros on msb or lsb??

assign FO_output = {e^f[6:0],f};		//finally got the 16 bit value. check which bit to keep for f



endmodule




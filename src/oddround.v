
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//writing code for odd round
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module odd_round (
		output reg [31:0] round_out = 0,

		input wire [31:0] round_input_wire,        
//		input wire [63:0] Kc,
 

		input wire [15:0] KOi1,
		input wire [15:0] KOi2,	

		input wire [15:0] KOi3,
		input wire [15:0] KLi1,	

		input wire [15:0] KLi2,
		input wire [15:0] Klli1,	

		input wire [15:0] Klli2,
		input wire [15:0] Klli3,	

   		input wire clk,
	   	input wire rst		
		);


wire [15:0] FO_output_1,FO_output_2,FO_output_3,h,i;

FO_stage FO_stage_1	(						//
		.FO_output(FO_output_1),		
		.FO_input(round_input_wire[31:16]),
		.KOi_16bit_indexed(KOi1),	//KOi1[0]	
		.Klli_16bit_indexed(Klli1)	//Klli1[0]	
		);
assign h = FO_output_1 ^ round_input_wire[15:0];

FO_stage FO_stage_2	(						//
		.FO_output(FO_output_2),		
		.FO_input(round_input_wire[15:0]),
		.KOi_16bit_indexed(KOi2),	//KOi2[0]
		.Klli_16bit_indexed(Klli2)	//Klli2[0]
		);


FO_stage FO_stage_3	(						//
		.FO_output(FO_output_3),		
		.FO_input(h),
		.KOi_16bit_indexed(KOi3),	//KOi3[0]	
		.Klli_16bit_indexed(Klli3)	//Klli3[0]	
		);
assign i = h ^ FO_output_2;
wire [31:0] FO_output_combine_32bits = {i,i^FO_output_3};		//Final output of the FO Function



wire [15:0] FL_temp_1 = FO_output_combine_32bits[31:16] & KLi1;
wire [15:0] FL_temp_2 = FO_output_combine_32bits[15:0]| KLi2;
wire [15:0] FL_temp_3 = ({FL_temp_1[14:0],FL_temp_1[15]})	^	FO_output_combine_32bits[15:0];
wire [15:0] FL_temp_4 = FL_temp_3 | KLi2;


//the line below defines FL function in single statement.
wire [31:0] FL_output_32 = 	{
				({FL_temp_4[14:0],FL_temp_4[15]} ^ FO_output_combine_32bits[31:16])
				,
				FL_temp_3
				};


/// Now pssign the FL output to FO



always@(posedge clk)
if (rst)
	round_out <= 0;
else
round_out <= FL_output_32;


endmodule

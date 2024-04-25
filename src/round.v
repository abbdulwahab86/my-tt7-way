//module round_tb ();
//
//
//reg clk=0;
//
//always
//#5 clk =~clk;
//
//wire [127:0]ro1;
//
//full_kasumi test_round 	(
//			.kasumi_out(ro1),
//			.Kc(64'h568a_3775_3116_e6b0),
//			.input_data(64'h30_9880_000f_0000), //round input with modified key test vectors
////			.input_data(64'hc9ec_8618_f4f2_b5e5), //original round input key test vectors
//
//			.clk(clk),
//	        	.rst(1'b0)
//			);
//
//initial
//#2000 $display ("Round Output = 0x%h",ro1);
//
//endmodule


//A5/3 Round
//No PipeLining so far

module tt_um_full_kasumi	(
			output wire [127:0] kasumi_out,

			input wire [63:0] Kc,
			input wire [63:0] input_data,			
			input wire clk,
			input wire rst
			);

wire [63:0] one_out,two_out,three_out;

round_all8 Kasum1	(
			.round_all8_output(one_out),
		 	.Kc(Kc^64'h5555_5555_5555_5555),
			.round_input(input_data),      
		
			.clk(clk),
			.rst(rst)
			);

round_all8 Kasumi2	(
			.round_all8_output(two_out),
		 	.Kc(Kc),
			.round_input(one_out),      
		
			.clk(clk),
			.rst(rst)
			);

round_all8 Kasumi3	(
			.round_all8_output(three_out),
		 	.Kc(Kc),
			.round_input(one_out^two_out^64'h1),      
		
			.clk(clk),
			.rst(rst)
			);
assign kasumi_out = {two_out,three_out};


endmodule



module round_all8	(
			output wire [63:0] round_all8_output,
			input wire [63:0] Kc,
			input wire [63:0] round_input,      
		
			input wire clk,
			input wire rst
);

///////////////////////////////////////////////////////////

//Key Scheduler complete
/*
//Calculating Ci
wire [15:0]ci_0 = Kc[63:48]^16'h0123;
wire [15:0]ci_1 = Kc[47:32]^16'h4567;
wire [15:0]ci_2 = Kc[31:16]^16'h89ab;	 
wire [15:0]ci_3 = Kc[15:0]^16'hcdef;
wire [15:0]ci_4 = Kc[63:48]^16'hfedc;
wire [15:0]ci_5 = Kc[47:32]^16'hba98;
wire [15:0]ci_6 = Kc[31:16]^16'h7654;
wire [15:0]ci_7 = Kc[15:0]^16'h3210;
*/


wire [127:0] ci;

assign ci = 	{
		Kc[63:48]^16'h0123,
		Kc[47:32]^16'h4567,
		Kc[31:16]^16'h89ab,		 
		Kc[15:0]^16'hcdef,
		Kc[63:48]^16'hfedc,
		Kc[47:32]^16'hba98,
		Kc[31:16]^16'h7654,
		Kc[15:0]^16'h3210
		};

//Calculating Ck_m		
wire [15:0]ck_m_0 = Kc[63:48]^16'h5555;
wire [15:0]ck_m_1 = Kc[47:32]^16'h5555;
wire [15:0]ck_m_2 = Kc[31:16]^16'h5555;	 
wire [15:0]ck_m_3 = Kc[15:0]^16'h5555;
wire [15:0]ck_m_4 = Kc[63:48]^16'h5555;
wire [15:0]ck_m_5 = Kc[47:32]^16'h5555;
wire [15:0]ck_m_6 = Kc[31:16]^16'h5555;
wire [15:0]ck_m_7 = Kc[15:0]^16'h5555;


wire [15:0] KLi1_0 = Kc[63:48]<<1 | Kc[63:48]>>15; 
wire [15:0] KLi1_1 = Kc[47:32]<<1 | Kc[47:32]>>15;
wire [15:0] KLi1_2 = Kc[31:16]<<1 | Kc[31:16]>>15;	 
wire [15:0] KLi1_3 = Kc[15:0] <<1 | Kc[15:0]>>15;
wire [15:0] KLi1_4 = Kc[63:48]<<1 | Kc[63:48]>>15; 
wire [15:0] KLi1_5 = Kc[47:32]<<1 | Kc[47:32]>>15;
wire [15:0] KLi1_6 = Kc[31:16]<<1 | Kc[31:16]>>15;	 
wire [15:0] KLi1_7 = Kc[15:0] <<1 | Kc[15:0]>>15;

	

wire [15:0] KOi1_0 = Kc[47:32]<<5 | Kc[47:32]>>11;
wire [15:0] KOi1_1 = Kc[31:16]<<5 | Kc[31:16]>>11;	 
wire [15:0] KOi1_2 = Kc[15:0] <<5  | Kc[15:0]>>11;
wire [15:0] KOi1_3 = Kc[63:48]<<5 | Kc[63:48]>>11; 
wire [15:0] KOi1_4 = Kc[47:32]<<5 | Kc[47:32]>>11;
wire [15:0] KOi1_5 = Kc[31:16]<<5 | Kc[31:16]>>11;	 
wire [15:0] KOi1_6 = Kc[15:0] <<5  | Kc[15:0]>>11;
wire [15:0] KOi1_7 = Kc[63:48]<<5 | Kc[63:48]>>11;

//KOi2


wire [15:0] KOi2_0 = Kc[47:32]<<8 | Kc[47:32]>>8;
wire [15:0] KOi2_1 = Kc[31:16]<<8 | Kc[31:16]>>8;	 
wire [15:0] KOi2_2 = Kc[15:0] <<8 | Kc[15:0] >>8;
wire [15:0] KOi2_3 = Kc[63:48]<<8 | Kc[63:48]>>8; 
wire [15:0] KOi2_4 = Kc[47:32]<<8 | Kc[47:32]>>8;
wire [15:0] KOi2_5 = Kc[31:16]<<8 | Kc[31:16]>>8;	 
wire [15:0] KOi2_6 = Kc[15:0] <<8 | Kc[15:0] >>8;
wire [15:0] KOi2_7 = Kc[63:48]<<8 | Kc[63:48]>>8; 

//KOi3

wire [15:0] KOi3_0 = Kc[31:16]<<13 | Kc[31:16]>>3;	 
wire [15:0] KOi3_1 = Kc[15:0] <<13 | Kc[15:0] >>3;
wire [15:0] KOi3_2 = Kc[63:48]<<13 | Kc[63:48]>>3; 
wire [15:0] KOi3_3 = Kc[47:32]<<13 | Kc[47:32]>>3;
wire [15:0] KOi3_4 = Kc[31:16]<<13 | Kc[31:16]>>3;	 
wire [15:0] KOi3_5 = Kc[15:0] <<13 | Kc[15:0] >>3;
wire [15:0] KOi3_6 = Kc[63:48]<<13 | Kc[63:48]>>3; 
wire [15:0] KOi3_7 = Kc[47:32]<<13 | Kc[47:32]>>3;

//KLi2
wire [15:0] KLi2_0 = ci[95:80];
wire [15:0] KLi2_1 = ci[79:64];
wire [15:0] KLi2_2 = ci[63:48];
wire [15:0] KLi2_3 = ci[47:32];
wire [15:0] KLi2_4 = ci[31:16];
wire [15:0] KLi2_5 = ci[15:0];
wire [15:0] KLi2_6 = ci[127:112];
wire [15:0] KLi2_7 = ci[111:96];
		
//Klli1
wire [15:0] Klli1_0 = ci[63:48];
wire [15:0] Klli1_1 = ci[47:32];
wire [15:0] Klli1_2 = ci[31:16];
wire [15:0] Klli1_3 = ci[15:0];
wire [15:0] Klli1_4 = ci[127:112];
wire [15:0] Klli1_5 = ci[111:96];
wire [15:0] Klli1_6 = ci[95:80];
wire [15:0] Klli1_7 = ci[79:64];

//Klli2
wire [15:0] Klli2_0 = ci[79:64];
wire [15:0] Klli2_1 = ci[63:48];
wire [15:0] Klli2_2 = ci[47:32];
wire [15:0] Klli2_3 = ci[31:16];
wire [15:0] Klli2_4 = ci[15:0];
wire [15:0] Klli2_5 = ci[127:112];
wire [15:0] Klli2_6 = ci[111:96];
wire [15:0] Klli2_7 = ci[95:80];
		
//Klli3
wire [15:0] Klli3_0 = ci[15:0];
wire [15:0] Klli3_1 = ci[127:112];
wire [15:0] Klli3_2 = ci[111:96];
wire [15:0] Klli3_3 = ci[95:80];
wire [15:0] Klli3_4 = ci[79:64];
wire [15:0] Klli3_5 = ci[63:48];
wire [15:0] Klli3_6 = ci[47:32];
wire [15:0] Klli3_7 = ci[31:16];


wire [31:0] round_0_output,round_1_output,round_2_output,round_3_output,round_4_output,round_5_output,round_6_output,round_7_output;


// 
//Now running round
//Round 0
even_round  round_0	(
		.round_out(round_0_output),
		.round_input_wire(round_input[63:32]),	//MS 32 bits to even round        

 

		.KOi1(KOi1_0),
		.KOi2(KOi2_0),	

		.KOi3(KOi3_0),
		.KLi1(KLi1_0),	

		.KLi2(KLi2_0),
		.Klli1(Klli1_0),	

		.Klli2(Klli2_0),
		.Klli3(Klli3_0),	

   		.clk(clk),
		.rst(rst)		
		);

//Round 1
wire [31:0] round_1_input = round_input[31:0]^round_0_output;
odd_round  round_1	(
		.round_out(round_1_output),
		.round_input_wire(round_1_input),	//MS 32 bits to even round        

 

		.KOi1(KOi1_1),
		.KOi2(KOi2_1),	

		.KOi3(KOi3_1),
		.KLi1(KLi1_1),	

		.KLi2(KLi2_1),
		.Klli1(Klli1_1),	

		.Klli2(Klli2_1),
		.Klli3(Klli3_1),	

   		.clk(clk),
		.rst(rst)		
		);
//Round 2
wire [31:0] round_2_input = round_1_output^round_input[63:32];
even_round  round_2	(
		.round_out(round_2_output),
		.round_input_wire(round_2_input),	//MS 32 bits to even round        

 

		.KOi1(KOi1_2),
		.KOi2(KOi2_2),	

		.KOi3(KOi3_2),
		.KLi1(KLi1_2),	

		.KLi2(KLi2_2),
		.Klli1(Klli1_2),	

		.Klli2(Klli2_2),
		.Klli3(Klli3_2),	

   		.clk(clk),
		.rst(rst)		
		);
//Round 3
wire [31:0] round_3_input = round_2_output^round_1_input;
odd_round  round_3	(
		.round_out(round_3_output),
		.round_input_wire(round_3_input),	      

 

		.KOi1(KOi1_3),
		.KOi2(KOi2_3),	

		.KOi3(KOi3_3),
		.KLi1(KLi1_3),	

		.KLi2(KLi2_3),
		.Klli1(Klli1_3),	

		.Klli2(Klli2_3),
		.Klli3(Klli3_3),	

   		.clk(clk),
		.rst(rst)		
		);

//Round 4
wire [31:0] round_4_input = round_3_output^round_2_input;
even_round  round_4	(
		.round_out(round_4_output),
		.round_input_wire(round_4_input),	

 

		.KOi1(KOi1_4),
		.KOi2(KOi2_4),	

		.KOi3(KOi3_4),
		.KLi1(KLi1_4),	

		.KLi2(KLi2_4),
		.Klli1(Klli1_4),	

		.Klli2(Klli2_4),
		.Klli3(Klli3_4),	

   		.clk(clk),
		.rst(rst)		
		);
//Round 5
wire [31:0] round_5_input = round_4_output^round_3_input;
odd_round  round_5	(
		.round_out(round_5_output),
		.round_input_wire(round_5_input),	//MS 32 bits to even round        

 

		.KOi1(KOi1_5),
		.KOi2(KOi2_5),	

		.KOi3(KOi3_5),
		.KLi1(KLi1_5),	

		.KLi2(KLi2_5),
		.Klli1(Klli1_5),	

		.Klli2(Klli2_5),
		.Klli3(Klli3_5),	

   		.clk(clk),
		.rst(rst)		
		);
//Round 6
wire [31:0] round_6_input = round_5_output^round_4_input;
even_round  round_6	(
		.round_out(round_6_output),
		.round_input_wire(round_6_input),	//MS 32 bits to even round        

 

		.KOi1(KOi1_6),
		.KOi2(KOi2_6),	

		.KOi3(KOi3_6),
		.KLi1(KLi1_6),	

		.KLi2(KLi2_6),
		.Klli1(Klli1_6),	

		.Klli2(Klli2_6),
		.Klli3(Klli3_6),	

   		.clk(clk),
		.rst(rst)		
		);
//Round 7
wire [31:0] round_7_input = round_6_output^round_5_input;
odd_round  round_7(
		.round_out(round_7_output),
		.round_input_wire(round_7_input),	//MS 32 bits to even round        

 

		.KOi1(KOi1_7),
		.KOi2(KOi2_7),	

		.KOi3(KOi3_7),
		.KLi1(KLi1_7),	

		.KLi2(KLi2_7),
		.Klli1(Klli1_7),	

		.Klli2(Klli2_7),
		.Klli3(Klli3_7),	

   		.clk(clk),
		.rst(rst)		
		);

assign round_all8_output = {round_7_output^round_6_input, round_7_input};
endmodule




/*

module even_round (
		output reg [31:0] round_out=0,

		input wire [31:0] round_input_wire,        //Using 32 input *** take care of 64 bits later on
		input wire [63:0] Kc,
    		input wire clk,
	   	input wire rst		
		);


reg [31:0] round_input=0; 
always@(posedge clk)
if (rst)
	round_input <= 0;
else
round_input = round_input_wire;



///////////////////////////////////////////////////////////

//For Key Scheduler
wire [127:0] ci;





//wire [63:0] ck_m = Kc ^ 64'h5555_5555_5555_5555;
//wire [63:0] KLi1_64,KOi1_64,KOi2_64,KOi3_64;



assign ci = 	{
		Kc[63:48]^16'h0123,
		Kc[47:32]^16'h4567,
		Kc[31:16]^16'h89ab,		 
		Kc[15:0]^16'hcdef,
		Kc[63:48]^16'hfedc,
		Kc[47:32]^16'hba98,
		Kc[31:16]^16'h7654,
		Kc[15:0]^16'h3210
		};
//////////////////////////////////////////////////////////////////


wire [15:0] KLi1_0 = Kc[63:48]<<1 | Kc[63:48]>>15;
wire [15:0] KLi2_0 = ci[95:80];

wire [15:0] FL_temp_1 = round_input[31:16] & KLi1_0;
wire [15:0] FL_temp_2 = round_input[15:0]| KLi2_0;
wire [15:0] FL_temp_3 = ({FL_temp_1[14:0],FL_temp_1[15]})	^	round_input[15:0];
wire [15:0] FL_temp_4 = FL_temp_3 | KLi2_0;


//the line below defines FL function in single statement.
wire [31:0] FO_input_32 = 	{
				({FL_temp_4[14:0],FL_temp_4[15]} ^ round_input[31:16])
				,
				FL_temp_3
				};


/// Now pssign the FL output to FO





wire [15:0] FO_output_1,FO_output_2,FO_output_3,h,i;

FO_stage FO_stage_1	(						//
		.FO_output(FO_output_1),		
		.FO_input(FO_input_32[31:16]),
		.KOi_16bit_indexed(Kc[47:32]<<5 | Kc[47:32]>>11 ),	//KOi1[0]	
		.Klli_16bit_indexed(ci[63:48])				//Klli1[0]	
		);
assign h = FO_output_1 ^ FO_input_32[15:0];

FO_stage FO_stage_2	(						//
		.FO_output(FO_output_2),		
		.FO_input(FO_input_32[15:0]),
		.KOi_16bit_indexed(Kc[47:32]<<8 | Kc[47:32]>>8),	//KOi2[0]
		.Klli_16bit_indexed(ci[79:64])				//Klli2[0]
		);


FO_stage FO_stage_3	(						//
		.FO_output(FO_output_3),		
		.FO_input(h),
		.KOi_16bit_indexed(Kc[31:16]<<13 | Kc[31:16]>>3),	//KOi3[0]	
		.Klli_16bit_indexed(ci[15:0])				//Klli3[0]	
		);
assign i = h ^ FO_output_2;
wire [31:0] FO_output_combine_32bits = {i,i^FO_output_3};		//Final output of the FO Function

always@(posedge clk)
if (rst)
	round_out <= 0;
else
round_out = FO_output_combine_32bits;


endmodule
*/

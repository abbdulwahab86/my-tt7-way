
module rom_S7 (
		 input wire [6:0] address,
		output reg [6:0] data
		);

// Memory content initialization
reg [6:0] memory [127:0]; // 2^7 = 127 locations;memory[] = 7'dindexed from 0 to 127

// Initialize memory content with provided values
initial begin
memory[0] = 7'd54;
memory[1] = 7'd50;
memory[2] = 7'd62;
memory[3] = 7'd56;
memory[4] = 7'd22;
memory[5] = 7'd34;
memory[6] = 7'd94;
memory[7] = 7'd96;
memory[8] = 7'd38;
memory[9] = 7'd6;
memory[10] = 7'd63;
memory[11] = 7'd93;
memory[12] = 7'd2;
memory[13] = 7'd18;
memory[14] = 7'd123;
memory[15] = 7'd33;
memory[16] = 7'd55;
memory[17] = 7'd113;
memory[18] = 7'd39;
memory[19] = 7'd114;
memory[20] = 7'd21;
memory[21] = 7'd67;
memory[22] = 7'd65;
memory[23] = 7'd12;
memory[24] = 7'd47;
memory[25] = 7'd73;
memory[26] = 7'd46;
memory[27] = 7'd27;
memory[28] = 7'd25;
memory[29] = 7'd111;
memory[30] = 7'd124;
memory[31] = 7'd81;
memory[32] = 7'd53;
memory[33] = 7'd9;
memory[34] = 7'd121;
memory[35] = 7'd79;
memory[36] = 7'd52;
memory[37] = 7'd60;
memory[38] = 7'd58;
memory[39] = 7'd48;
memory[40] = 7'd101;
memory[41] = 7'd127;
memory[42] = 7'd40;
memory[43] = 7'd120;
memory[44] = 7'd104;
memory[45] = 7'd70;
memory[46] = 7'd71;
memory[47] = 7'd43;
memory[48] = 7'd20;
memory[49] = 7'd122;
memory[50] = 7'd72;
memory[51] = 7'd61;
memory[52] = 7'd23;
memory[53] = 7'd109;
memory[54] = 7'd13;
memory[55] = 7'd100;
memory[56] = 7'd77;
memory[57] = 7'd1;
memory[58] = 7'd16;
memory[59] = 7'd7;
memory[60] = 7'd82;
memory[61] = 7'd10;
memory[62] = 7'd105;
memory[63] = 7'd98;
memory[64] = 7'd117;
memory[65] = 7'd116;
memory[66] = 7'd76;
memory[67] = 7'd11;
memory[68] = 7'd89;
memory[69] = 7'd106;
memory[70] = 7'd0;
memory[71] = 7'd125;
memory[72] = 7'd118;
memory[73] = 7'd99;
memory[74] = 7'd86;
memory[75] = 7'd69;
memory[76] = 7'd30;
memory[77] = 7'd57;
memory[78] = 7'd126;
memory[79] = 7'd87;
memory[80] = 7'd112;
memory[81] = 7'd51;
memory[82] = 7'd17;
memory[83] = 7'd5;
memory[84] = 7'd95;
memory[85] = 7'd14;
memory[86] = 7'd90;
memory[87] = 7'd84;
memory[88] = 7'd91;
memory[89] = 7'd8;
memory[90] = 7'd35;
memory[91] = 7'd103;
memory[92] = 7'd32;
memory[93] = 7'd97;
memory[94] = 7'd28;
memory[95] = 7'd66;
memory[96] = 7'd102;
memory[97] = 7'd31;
memory[98] = 7'd26;
memory[99] = 7'd45;
memory[100] =7'd75;
memory[101] =7'd4;
memory[102] =7'd85;
memory[103] =7'd92;
memory[104] =7'd37;
memory[105] =7'd74;
memory[106] =7'd80;
memory[107] =7'd49;
memory[108] =7'd68;
memory[109] =7'd29;
memory[110] =7'd115;
memory[111] =7'd44;
memory[112] =7'd64;
memory[113] =7'd107;
memory[114] =7'd108;
memory[115] =7'd24;
memory[116] =7'd110;
memory[117] =7'd83;
memory[118] =7'd36;
memory[119] =7'd78;
memory[120] =7'd42;
memory[121] =7'd19;
memory[122] =7'd15;
memory[123] =7'd41;
memory[124] =7'd88;
memory[125] =7'd119;
memory[126] =7'd59;
memory[127] =7'd3;

end

// Read operation
always @(address) 
    data <= memory[address];


endmodule


`timescale 1ns/10ps 

module zero_flag(in, isZero);
	
	input logic [63:0] in;
	output logic isZero;
	
	logic [3:0] group1, group2, group3, group4;
	logic group1_nor, group2_nor, group3_nor, group4_nor;
	
	// Group 1: 4-input NOR
	or #50 or1 (group1[0], in[3], in[2], in[1], in[0]);
	or #50 or2 (group1[1], in[7], in[6], in[5], in[4]);
	or #50 or3 (group1[2], in[11], in[10], in[9], in[8]);
	or #50 or4 (group1[3], in[15], in[14], in[13], in[12]);
	nor #50 nor1 (group1_nor, group1[0], group1[1], group1[2], group1[3]);
	
	// Group 2: 4-input NOR
	or #50 or5 (group2[0], in[19], in[18], in[17], in[16]);
	or #50 or6 (group2[1], in[23], in[22], in[21], in[20]);
	or #50 or7 (group2[2], in[27], in[26], in[25], in[24]);
	or #50 or8 (group2[3], in[31], in[30], in[29], in[28]);
	nor #50 nor2 (group2_nor, group2[0], group2[1], group2[2], group2[3]);
	
	// Group 3: 4-input NOR
	or #50 or9 (group3[0], in[35], in[34], in[33], in[32]);
	or #50 or10 (group3[1], in[39], in[38], in[37], in[36]);
	or #50 or11 (group3[2], in[43], in[42], in[41], in[40]);
	or #50 or12 (group3[3], in[47], in[46], in[45], in[44]);
	nor #50 nor3 (group3_nor, group3[0], group3[1], group3[2], group3[3]);
	
	// Group 4: 4-input NOR
	or #50 or13 (group4[0], in[51], in[50], in[49], in[48]);
	or #50 or14 (group4[1], in[55], in[54], in[53], in[52]);
	or #50 or15(group4[2], in[59], in[58], in[57], in[56]);
	or #50 or16 (group4[3], in[63], in[62], in[61], in[60]);
	nor #50 nor4 (group4_nor, group4[0], group4[1], group4[2], group4[3]);
	
	// 64-input NOR
	and #50 and1 (isZero, group1_nor, group2_nor, group3_nor, group4_nor);
	
endmodule // zero_flag
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 14:02:45
// Design Name: 
// Module Name: display_manager
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`default_nettype none
module display_manager(
    input wire clk_1kHz, sys_rst,
	input wire [3:0] digit0, digit1, digit2, digit3, digit4, digit5, digit6, digit7,
	output wire [6:0] seg_out1, seg_out2,
	output reg [3:0] an1, an2
);

reg [1:0] scan;
reg [3:0] curr_digit1, curr_digit2;
wire [6:0] seg_temp1, seg_temp2;

always @ (posedge clk_1kHz or posedge sys_rst) begin
	if(sys_rst)
		scan <= 0;
	else begin
		scan <= scan + 1;
	end
end

always @ * begin
	case(scan)
	2'd0: begin
		an1 = 4'b1110;
		curr_digit1 = digit0;
	end
	2'd1: begin
		an1 = 4'b1101;
		curr_digit1 = digit1;
	end
	2'd2: begin
		an1 = 4'b1011;
		curr_digit1 = digit2;
	end
	2'd3: begin
		an1 = 4'b0111;
		curr_digit1 = digit3;
	end
	default: begin
		an1 = 4'b1110;
		curr_digit1 = digit0;
	end
	endcase
end
	
dis_7seg inst1 (.digit(curr_digit1), .segpins(seg_temp1));

always @ * begin
	case(scan)
	2'd0: begin
		an2 = 4'b1110;
		curr_digit2 = digit4;
	end
	2'd1: begin
		an2 = 4'b1101;
		curr_digit2 = digit5;
	end
	2'd2: begin
		an2 = 4'b1011;
		curr_digit2 = digit6;
	end
	2'd3: begin
		an2 = 4'b0111;
		curr_digit2 = digit7;
	end
	default: begin
		an2 = 4'b1110;
		curr_digit2 = digit4;
	end
	endcase
end

dis_7seg inst2 (.digit(curr_digit2), .segpins(seg_temp2));

assign seg_out1 = seg_temp1;
assign seg_out2 = seg_temp2;

endmodule

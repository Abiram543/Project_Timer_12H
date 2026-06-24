`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 12:46:37
// Design Name: 
// Module Name: hour12_clock
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
module hour12_clock(
	input wire sys_clk,
	input wire sys_rst,
	output reg [3:0] ss0, ss1,
	output reg [2:0] mm1,
	output reg [3:0] mm0,
	output reg [3:0] hh0,
	output reg hh1,
	output reg [3:0] pm
);

//States parameterization
localparam AM = 1'b0,
           PM = 1'b1;
           
// State registers
reg PS, NS;

reg ena;

reg  count_hh1;
reg [3:0] count_hh0;
reg [3:0] count_mm0;
reg [2:0] count_mm1;
reg [3:0] count_ss0;
reg [2:0] count_ss1;
reg pm_signal;

reg [26:0] count;
wire count_temp;

wire count_mm0_temp;
wire count_mm1_temp;
wire count_ss0_temp;
wire count_ss1_temp;
wire count_temp1;
wire count_temp2;
wire count_temp3;



// Present state logic
always @ (posedge sys_clk or posedge sys_rst) begin
	if(sys_rst) begin
		PS <= AM;
	end
	else begin 
	   if(ena)
	       PS <= NS;
	   else
	       PS <= PS;
	end
end

// Counter logic for counting 1Hz clock && // enable signal assertion on every 1 sec (1Hz)
always @ (posedge sys_clk or posedge sys_rst) begin
	if(sys_rst) begin
		count <= 0;
		ena <= 0;
	end
	else if (count_temp) begin
		count <= 0;
		ena <= 1;
	end
	else begin
		count <= count + 1;
		ena <= 0;
	end
end

assign count_temp = (count==27'd9999_9999);


//Timer logic
always @ (posedge sys_clk or posedge sys_rst) begin
	if(sys_rst) begin
		count_hh1 <= 1;
        count_hh0 <= 4'd2;
        count_mm0 <= 0;
        count_mm1 <= 0;
		count_ss0 <= 0;
        count_ss1 <= 0;
        pm_signal <= 0;
	end
	else begin
		if(ena) begin
			if(count_ss0_temp) begin
				count_ss0 <= 0;
				if(count_ss1_temp) begin
					count_ss1 <= 0;
					if(count_mm0_temp) begin
						count_mm0 <= 0;
						if(count_mm1_temp) begin
							count_mm1 <= 0;
							if(count_temp3) begin
							    pm_signal <= ~pm_signal;
							    count_hh1 <= count_hh1;
								count_hh0 <= count_hh0 + 1;
							end
							else if(count_temp1) begin
								count_hh0 <= 4'd1;
								count_hh1 <= 0;
							end
							else if(count_temp2) begin
								count_hh1 <= count_hh1 + 1;
								count_hh0 <= 0;
							end
							else begin
								count_hh0 <= count_hh0 + 1;
								count_hh1 <= count_hh1;
							end
						end
						else begin
							count_mm1 <= count_mm1 + 1;
						end
					end
					else begin
						count_mm0 <= count_mm0 + 1;
					end
				end
				else begin
					count_ss1 <= count_ss1 + 1;
				end
			end
			else begin
				count_ss0 <= count_ss0 + 1;
			end
		end
		else begin
			count_hh1 <= count_hh1;
            count_hh0 <= count_hh0;
            count_mm0 <= count_mm0;
            count_mm1 <= count_mm1;
            count_ss0 <= count_ss0;
            count_ss1 <= count_ss1;
		end
	end
end

//Temp counter logic
assign count_mm0_temp = (count_mm0 == 4'd9);
assign count_mm1_temp = (count_mm1 == 3'd5);
assign count_ss0_temp = (count_ss0 == 4'd9);
assign count_ss1_temp = (count_ss1 == 3'd5);
assign count_temp1 	  = (count_hh0 == 4'd2) && (count_hh1 == 1);
assign count_temp2 	  = (count_hh0 == 4'd9) && (count_hh1 != 1);
assign count_temp3    = (count_hh1 == 1) && (count_hh0 == 4'd1);


// Next State logic
always @ * begin
	case(PS)
		AM: begin
			if(pm_signal) begin
				NS = PM;
			end
			else 
				NS = AM;
		end
		PM: begin
			if(~pm_signal) begin
				NS = AM;
			end
			else 
				NS = PM;
		end
		default: NS = AM;
	endcase
end

// Output logic
always @ * begin
    ss0 = count_ss0;
    ss1 = count_ss1;
    mm0 = count_mm0;
    mm1 = count_mm1;
    hh0 = count_hh0;
    hh1 = count_hh1;
end

always @ * begin
	case(PS)
		AM: pm = 4'd10;
		PM: pm = 4'd11;
		default: pm = 4'd10;
	endcase
end

endmodule

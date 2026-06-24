`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 14:10:21
// Design Name: 
// Module Name: top
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


module top(
    input wire sys_clk, sys_rst,
    output wire [6:0] seg_out1, seg_out2,
    output wire [3:0] an1, an2
    );
    wire [3:0] ss0, ss1;
    wire [2:0] mm1;      
    wire [3:0] mm0;      
    wire [3:0] hh0;      
    wire hh1;           
    wire [3:0] pm;
    wire clk_1kHz;
    
// Core FSM Design Inst1    
hour12_clock inst1(
	.sys_clk(sys_clk),
	.sys_rst(sys_rst),
	.ss0(ss0), 
	.ss1(ss1),
	.mm1(mm1),
	.mm0(mm0),
	.hh0(hh0),
	.hh1(hh1),
	.pm(pm)
);

// 1kHz Clock
clk_div_1kHz inst2(
    .sys_clk(sys_clk), .rst(sys_rst), 
    .clk_1kHz(clk_1kHz)
    );


// Display manager
display_manager inst3(
    .clk_1kHz(clk_1kHz), .sys_rst(sys_rst),
	.digit0(pm), .digit1(4'd12), .digit2(ss0), .digit3({1'b0, ss1}), .digit4(mm0), .digit5({1'b0, mm1}), .digit6(hh0), .digit7({3'b000, hh1}),
	.seg_out1(seg_out1),
	.seg_out2(seg_out2),
	.an1(an1), 
	.an2(an2)
);


endmodule

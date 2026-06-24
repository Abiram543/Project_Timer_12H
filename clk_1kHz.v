`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 14:41:03
// Design Name: 
// Module Name: clk_1kHz
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
module clk_div_1kHz(
    input wire sys_clk, rst, 
    output reg clk_1kHz
    );
    reg [15:0]div_count;
    
    always@(posedge sys_clk or posedge rst)
    begin
        if(rst) begin
            div_count <= 0;
            clk_1kHz <= 0;
         end
         else begin
            if(div_count==16'd49999)
            begin
                div_count <= 0;
                clk_1kHz <= ~clk_1kHz;
            end
            else begin
                div_count <= div_count + 1;
               end
          end
    end
endmodule

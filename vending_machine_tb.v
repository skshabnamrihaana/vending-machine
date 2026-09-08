`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/22/2026 07:29:23 PM
// Design Name: 
// Module Name: vending_machine_tb
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



module tb_vending_machine;
    reg clk;
    reg reset;
    reg coin_5;
    reg coin_10;
    reg vend;
    wire dispense;
    wire change;

    vending_machine uut (
        .clk(clk),
        .reset(reset),
        .coin_5(coin_5),
        .coin_10(coin_10),
        .vend(vend),
        .dispense(dispense),
        .change(change)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        coin_5 = 0;
        coin_10 = 0;
        vend = 0;
        #10;

        reset = 0;
        #10;

        // Insert 5 cents (State -> S5)
        coin_5 = 1; #10; coin_5 = 0; #10;
        
        // Insert 10 cents (State -> S15)
        coin_10 = 1; #10; coin_10 = 0; #10;

        // Press vend
        vend = 1; #10; vend = 0; #10;

        // Insert 10 cents twice (20 cents total -> change)
        coin_10 = 1; #10; coin_10 = 0; #10;
        coin_10 = 1; #10; coin_10 = 0; #10;

        $finish;
    end
endmodule


    

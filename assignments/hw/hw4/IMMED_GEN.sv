`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Engineer: Bryce Melander
// Company: Cal Poly
//
// Create Date: Nov-22-2023
// Module Name: IMMED_GEN
// Target Devices: OTTER MCU on Basys3
// Description: A description of the module's purpose.
//
// Dependencies:
//
// Revisions:
//  * 0.01 - File Created
//
// Copyright (c) 2023 by Bryce Melander under MIT License. All rights
// reserved, see http://opensource.org/licenses/MIT for more details.
//////////////////////////////////////////////////////////////////////////////

module IMMED_GEN (
    input  [31:0] IR, 
    output [31:0] U_TYPE,
    output [31:0] I_TYPE,
    output [31:0] S_TYPE,
    output [31:0] B_TYPE,
    output [31:0] J_TYPE
    );

    assign U_TYPE = { IR[31:12], 12'b0 };
    assign I_TYPE = { 21'{ IR[31] }, IR[30:20] };
    assign S_TYPE = { 21'{ IR[31] }, IR[30:25], IR[11:7] };
    assign B_TYPE = { 20'{ IR[31] }, IR[7], IR[30:25], IR[11:8] };
    assign J_TYPE = { 12'{ IR[31] }, IR[19:12], IR[20], IR[30:21], 1'b0 };

endmodule

// End of File //
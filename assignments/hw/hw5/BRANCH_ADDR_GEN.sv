`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Engineer: Bryce Melander
// Company: Cal Poly
//
// Create Date: Nov-21-2023
// Module Name: BRANCH_ADDR_GEN
// Target Devices: OTTER MCU on Basys3
// Description: OTTER MCU branch address generator. Creates 3 signals that
//              conditionally change the program counter (PC).
//
// Dependencies:
//
// Revisions:
//  * 0.01 - File Created
//
// Copyright (c) 2023 by Bryce Melander under MIT License. All rights
// reserved, see http://opensource.org/licenses/MIT for more details.
//////////////////////////////////////////////////////////////////////////////

module BRANCH_ADDR_GEN (
    input [31:0] PC, RS1, I_TYPE, J_TYPE, B_TYPE,
    output logic [31:0] JALR, BRANCH, JAL
    );

    assign JALR = ( I_TYPE + RS1 );
    assign BRANCH = ( B_TYPE + PC );
    assign JAL = ( J_TYPE + PC );

endmodule

// End of File //
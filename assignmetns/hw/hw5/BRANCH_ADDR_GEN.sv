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
    input [31:0] PC,
    input [31:0] RS1,
    input [31:0] I_TYPE,
    input [31:0] J_TYPE,
    input [31:0] B_TYPE,
    output logic [31:0] JALR,
    output logic [31:0] BRANCH,
    output logic [31:0] JAL
    );

    assgin JALR = ( I_TYPE + RS1 );
    assgin BRANCH = ( B_TYPE + PC );
    assgin JAL = ( J_TYPE + PC );

endmodule

// End of File //
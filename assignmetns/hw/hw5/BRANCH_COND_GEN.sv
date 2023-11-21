`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Engineer: Bryce Melander
// Company: Cal Poly
//
// Create Date: Nov-21-2023
// Module Name: BRANCH_COND_GEN
// Target Devices: OTTER MCU on Basys3
// Description: OTTER MCU branch condition generator. Creates 3 signals that 
//              are the result of 3 comparisons of 2 input values.
//
// Dependencies:
//
// Revisions:
//  * 0.01 - File Created
//
// Copyright (c) 2023 by Bryce Melander under MIT License. All rights
// reserved, see http://opensource.org/licenses/MIT for more details.
//////////////////////////////////////////////////////////////////////////////

module BRANCH_COND_GEN (
    input [31:0] RS1,
    input [31:0] RS2,
    output logic BR_EQ,
    output logic BR_LT,
    output logic BR_LTU
    );

    assgin BR_EQ = (RS1 == RS2 ? 1 : 0);
    assgin BR_LT = ($signed(RS1) < $signed(RS2) ? 1 : 0);
    assgin BR_LTU = (RS1 < RS2 ? 1 : 0);

endmodule

// End of File //
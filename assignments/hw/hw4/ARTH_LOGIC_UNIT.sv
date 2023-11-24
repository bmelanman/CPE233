`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Engineer: Bryce Melander
// Company: Cal Poly
//
// Create Date: Nov-22-2023
// Module Name: ARTH_LOGIC_UNIT
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

module ARTH_LOGIC_UNIT (
    input [3:0] ALU_FUNC, 
    input [31:0] SRC_A, SRC_B,
    output [31:0] RESULT
    );

    reg SGND_A, SGND_B;

    assign SGND_A = $signed(SRC_A);
    assign SGND_B = $signed(SRC_B);

    // TODO: Optional?
    initial begin
        RESULT = 0;
    end

    always_comb begin
        case (ALU_FUNC)
            0b0110: RESULT <= ( SRC_A | SRC_B );    // OR
            0b0100: RESULT <= ( SRC_A ^ SRC_B );    // XOR
            0b0111: RESULT <= ( SRC_A & SRC_B );    // AND
            
            0b0000: RESULT <= ( SRC_A + SRC_B );    // ADD
            0b1000: RESULT <= ( SGND_A - SGND_B );  // SUB

            0b0001: RESULT <= ( SRC_A << SRC_B[4:0] );      // SLL
            0b0101: RESULT <= ( SRC_A >> SRC_B[4:0] );      // SRL
            0b1101: RESULT <= ( SGND_A >>> SRC_B[4:0] );    // SRA

            0b0010: RESULT <= ( SGND_A < SGND_B ? 1 : 0 );  // SLT
            0b0011: RESULT <= ( SRC_A < SRC_B ? 1 : 0 );    // SLTU

            0b1001: RESULT <= ( SRC_A );    // LUI-COPY

            default: RESULT <= 0;
        endcase
    end

endmodule

// End of File //
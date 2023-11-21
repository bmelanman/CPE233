`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Engineer: Bryce Melander
// Company: Cal Poly
//
// Create Date: Nov-21-2023
// Module Name: REG_FILE
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

module REG_FILE(
    input CLK, WR_EN,
    input [4:0] WR_ADDR,
    input [31:0] WR_DATA,
    input [31:0] ADDR1, ADDR2,
    output logic [31:0] RS1, RS2
    );

    // 32 Registers with a width of 32 bits, all initialized to 32'b0
    logic [31:0] registers [0:31] = '{default:'0};

    // Read output from registers
    assign RS1 = registers[ADDR1];
    assign RS2 = registers[ADDR2];

    // Write input to registers
    always_ff @(posedge CLK) begin

        // Don't write to x0
        if ( WR_EN && WR_ADDR != 0 ) begin
            registers[WR_ADDR] <= WR_DATA
        end
        // Else case to avoid latches
        else begin
            registers[WR_ADDR] <= registers[WR_ADDR]
        end

    end

endmodule

// End of File //
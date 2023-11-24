`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Engineer: Bryce Melander
// Company: Cal Poly
//
// Create Date: Nov-21-2023
// Module Name: PROG_COUNTER
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

module PROG_COUNTER (
    input CLK, PC_RST, PC_WRITE, [2:0] PC_SOURCE,
    input [31:0] JALR, BRANCH, JAL, MTEVC, MEPC,
    output logic [31:0] PC_COUNT
    );

    reg [31:0] PC_DIN, PC_INC4;

    assign PC_INC4 = (PC_COUNT + 4);

    initial begin
        PC_DIN = 0;
        PC_INC4 = 0;
        PC_COUNT = 0;
    end

    always_comb begin : PC_INPUT_MUX
        case (PC_COUNT)
            0b000: PC_DIN <= PC_INC4;
            0b001: PC_DIN <= JALR;
            0b010: PC_DIN <= BRANCH;
            0b011: PC_DIN <= JAL;
            0b100: PC_DIN <= MTEVC;
            0b101: PC_DIN <= MEPC;
            default: PC_DIN <= 0;
        endcase
    end

    always_ff @( CLK ) begin : PROGRAM_COUNTER
        
        // Reset gets priority over write
        if (PC_RST) 
            PC_COUNT <= 0;
        else if (PC_WRITE) 
            PC_COUNT <= PC_DIN;
        else
            PC_COUNT <= PC_COUNT;
        
    end
endmodule

// End of File //
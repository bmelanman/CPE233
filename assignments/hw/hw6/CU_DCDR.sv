`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Engineer: Bryce Melander
// Company: Cal Poly
//
// Create Date: Nov-24-2023
// Module Name: CU_DCDR
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

module CU_DCDR(
    input [6:0] OPCODE,
    input [2:0] FUNC_3,
    input FUNC_7, INT_TAKEN,
    input BR_EQ, BR_LT, BR_LTU,
    output logic [1:0] ALU_SRC_A, RF_WR_SEL,
    output logic [2:0] ALU_SRC_B, PC_Source
    output logic [3:0] ALU_FUN,
    );

    always_comb begin
        // Reset all outputs to 0
        ALU_FUN = 4'b0;
        ALU_SRC_A = 2'b0;
        ALU_SRC_B = 3'b0;
        PC_Source = 3'b0;
        RF_WR_SEL = 2'b0;
        
        case(OPCODE)
            7'b0110111: begin // LUI
                ALU_FUN = 4'b1001;
                ALU_SRC_A = 2'b01;
                //ALU_SRC_B = 2'b01;
                RF_WR_SEL = 2'b11;
            end

            7'b0110111: begin // AUIPC
                ALU_SRC_A = 2'b01;
                ALU_SRC_B = 2'b11;
                RF_WR_SEL = 2'b11;
            end

            7'b1100011: begin // B-TYPE (BEQ, BNE, BLT, BGE, BLTU, BGEU)
                case(FUNC_3)
                    3'b000: PC_Source = 3'{ 1'b0, BR_EQ, 1'b0 }; // beq
                    3'b001: PC_Source = 3'{ 1'b0, ~BR_EQ, 1'b0 }; // bne
                    3'b100: PC_Source = 3'{ 1'b0, BR_LT, 1'b0 }; // blt
                    3'b101: PC_Source = 3'{ 1'b0, ~BR_LT, 1'b0 }; // bge
                    3'b110: PC_Source = 3'{ 1'b0, BR_LTU, 1'b0 }; // bltu
                    3'b111: PC_Source = 3'{ 1'b0, ~BR_LTU, 1'b0 }; // bgeu
                    default: begin
                        // Do nothing
                    end
                endcase
            end

            7'b0000011: begin // S-TYPE (LOAD)
                ALU_SRC_B = 2'b10;
                RF_WR_SEL = 2'b10;
            end

            7'b0000011: begin // S-TYPE (STORE)
                ALU_SRC_B = 2'b10;
            end

            7'b0010011: begin // I-TYPE (ADDI, SLLI)
                RF_WR_SEL = 2'b11;
                ALU_SRC_B = 3'b001;
                ALU_FUN = 4'{ 1'b0, FUNC_3 };
            end

            7'b0110011: begin // I-TYPE: (REMAINING)
                RF_WR_SEL = 2'b11;
                ALU_FUN = 4'{ FUNC_7, FUNC_3 };
            end

            default: begin
                // Do nothing
            end
        endcase
    end
endmodule

// End of File //
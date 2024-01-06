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
    input [31:0] IR,
    input INT_TAKEN,
    input BR_EQ, BR_LT, BR_LTU,
    output logic [1:0] ALU_SRC_A, RF_WR_SEL,
    output logic [2:0] ALU_SRC_B, PC_SOURCE
    output logic [3:0] ALU_FUN,
    output logic LUI_TEST
    );

    typedef enum logic [6:0] {
        R_TYPE = 7'b0110011,
        I_TYPE = 7'b0010011,
        S_TYPE = 7'b0100011,
        B_TYPE = 7'b1100011,
        JALR   = 7'b1100111,
        JAL    = 7'b1101111,
        MEM_LD = 7'b0000011,
        LUI_CP = 7'b0110111,
        AUI_PC = 7'b0010111
    } opcode_t;

    typedef enum logic [2:0] {
        BEQ  = 3'b000,
        BGE  = 3'b101,
        BGEU = 3'b111,
        BLT  = 3'b100,
        BLTU = 3'b110,
        BNE  = 3'b001
    } branch_t;

    opcode_t OPCODE_DECODED;
    branch_t BRANCH_DECODED;
    logic [2:0] FUNC_3;
    logic FUNC_7;

    assign OPCODE_DECODED = opcode_t'(IR[6:0]);
    assign BRANCH_DECODED = branch_t'(IR[14:12]);
    assign FUNC_3 = IR[14:12];
    assign FUNC_7 = IR[30];

    always_comb begin
        // Reset all outputs to 0
        ALU_FUN = 4'b0;
        ALU_SRC_A = 2'b0;
        ALU_SRC_B = 3'b0;
        PC_SOURCE = 3'b0;
        RF_WR_SEL = 2'b0;
        LUI_TEST = 1'b0;

        case(OPCODE_DECODED)
            R_TYPE, I_TYPE: begin // R-TYPE (ADD, AND, OR, etc...)
                RF_WR_SEL = 2'b11;
                ALU_FUN = 4'{ FUNC_7, FUNC_3 };

                // I-Type uses the immediate input
                if (OPCODE_DECODED == I_TYPE) begin
                    ALU_SRC_B = 3'b001;
                end
            end

            S_TYPE: begin // S-TYPE (SB, SH, SW)
                ALU_SRC_B = 2'b10;
                RF_WR_SEL = 2'b10;
            end

            B_TYPE: begin // B-TYPE (BEQ, BNE, BLT, BGE, BLTU, BGEU)
                case(BRANCH_DECODED)
                    BEQ:  PC_SOURCE = 3'{ 0, (  BR_EQ          ), 0 }; // beq
                    BGE:  PC_SOURCE = 3'{ 0, ( ~BR_LT  | BR_EQ ), 0 }; // bge
                    BGEU: PC_SOURCE = 3'{ 0, ( ~BR_LTU | BR_EQ ), 0 }; // bgeu
                    BLT:  PC_SOURCE = 3'{ 0, (  BR_LT          ), 0 }; // blt
                    BLTU: PC_SOURCE = 3'{ 0, (  BR_LTU         ), 0 }; // bltu
                    BNE:  PC_SOURCE = 3'{ 0, ( ~BR_EQ          ), 0 }; // bne
                    default: begin
                        // Do nothing
                    end
                endcase
            end

            JAL: begin // J-TYPE (JAL)
                PC_SOURCE = 3'b011;
                RF_WR_SEL = 3'b001;
            end

            JALR: begin // J-TYPE (JALR)
                ALU_SRC_B = 3'b010;
                PC_SOURCE = 3'b001;
            end

            MEM_LD: begin // U-TYPE (LOAD)
                ALU_SRC_B = 3'b010;
                RF_WR_SEL = 2'b10;
            end

            LUI_CP: begin // U-TYPE (LUI)
                ALU_FUN = 4'b1001;
                ALU_SRC_A = 2'b01;
                ALU_SRC_B = 2'b01;
                RF_WR_SEL = 2'b11;

                // Testing
                if (4'{ FUNC_7, FUNC_3 } == ALU_FUN)
                    LUI_TEST = 1'b1;
                else
                    LUI_TEST = 1'b0;
            end

            AUI_PC: begin // U-TYPE (AUIPC)
                ALU_SRC_A = 2'b01;
                ALU_SRC_B = 2'b11;
                RF_WR_SEL = 2'b11;
            end

            default: begin
                // Do nothing
            end
        endcase
    end
endmodule

// End of File //
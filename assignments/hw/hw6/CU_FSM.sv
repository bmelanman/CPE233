`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Engineer: Bryce Melander
// Company: Cal Poly
//
// Create Date: Nov-24-2023
// Module Name: CU_FSM
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

module CU_FSM (
    input CLK, RST, INTR_EN,
    input [31:0] IR,
    output PC_WRITE, REG_WRITE, SYS_RST,
    output MEM_WE2, MEM_RDEN1, MEM_RDEN2,
    output CSR_WE, INT_TAKEN, MRET_EXEC
    );

    bit HIGH = 1, LOW  = 0;

    typedef enum {
        INIT,
        FETCH,
        EXEC,
        WR_BK
    } fsmState_t;

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

    fsmState_t PS, NS;

    opcode_t OPCODE_DECODED;
    logic [2:0] FUNC_3;

    assign OPCODE_DECODED = opcode_t'(IR[6:0]);
    assign FUNC_3 = IR[14:12];

    // Initialize outputs to 0
    initial begin
        SYS_RST     = LOW;
        CSR_WE      = LOW;
        MRET_EXEC   = LOW;
        INT_TAKEN   = LOW;
        PC_WRITE    = LOW;
        REG_WRITE   = LOW;
        MEM_WE2     = LOW;
        MEM_RDEN1   = LOW;
        MEM_RDEN2   = LOW;

        NS = INIT;
    end

    always_ff @( posedge CLK ) begin

        PS <= NS;

        // Synchronous reset
        if (RST == 1) begin
            PS <= INIT;
        end

        // Reset outputs to 0
        SYS_RST     <= LOW;
        CSR_WE      <= LOW;
        MRET_EXEC   <= LOW;
        INT_TAKEN   <= LOW;
        PC_WRITE    <= LOW;
        REG_WRITE   <= LOW;
        MEM_WE2     <= LOW;
        MEM_RDEN1   <= LOW;
        MEM_RDEN2   <= LOW;

        case (PS)
            INIT: begin
                SYS_RST <= HIGH;
                NS <= FETCH;
            end

            FETCH: begin
                MEM_RDEN1 <= HIGH;
                NS <= EXEC;
            end

            EXEC: begin
                case (OPCODE)
                    R_TYPE, I_TYPE, JALR, JAL, LUI_CP, AUI_PC: begin
                        PC_WRITE <= HIGH;
                        REG_WRITE <= HIGH;
                    end
                    S_TYPE: begin
                        PC_WRITE <= HIGH;
                        MEM_WE2 <= HIGH;
                    end
                    B_TYPE: begin
                        PC_WRITE <= HIGH;
                    end
                    MEM_LD: begin
                        MEM_RDEN2 <= HIGH;
                    end
                    default: begin
                        // Do nothing
                    end
                endcase

                if ( MEM_RDEN2 == HIGH )
                    NS <= WR_BK;
                else
                    NS <= FETCH;
            end

            WR_BK: begin
                PC_WRITE <= HIGH;
                REG_WRITE <= HIGH;
                NS <= FETCH;
            end

            default: begin
                NS <= INIT;
            end
        endcase
    end

endmodule

// End of File //
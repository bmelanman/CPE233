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
    input [6:0] OPCODE,
    input [2:0] FUNC_3,
    output PC_WRITE, REG_WRITE, RST_MODULE, 
    output MEM_WE2, MEM_RDEN1, MEM_RDEN2,
    output CSR_WE, INT_TAKEN, MRET_EXEC
    );

    typedef enum { INIT, FETCH, EXEC, WRITEBACK } fsmState_t;
    
    fsmState_t currState, nextState;

    initial begin

    end

    always_ff @( posedge CLK ) begin
        if (RST == 1) 
            currState <= INIT;
        else
            currState <= nextState;
    end
    
    always_ff @( posedge currState ) begin

    end

endmodule

// End of File //
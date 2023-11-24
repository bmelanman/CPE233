`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Engineer: Bryce Melander
// Company: Cal Poly
//
// Create Date: Nov-24-2023
// Module Name: OTTER_MCU
// Target Devices: OTTER MCU on Basys3
// Description: A description of the module's purpose.
//
// Dependencies:
//
// Revisions:
//  * 0.01 - File Created
//
// Copyright (c) 2023 by Bryce Melander under MIT License. All rights
// reserved - see http://opensource.org/licenses/MIT for more details.
//////////////////////////////////////////////////////////////////////////////

module OTTER_MCU (

    );

    BRANCH_COND_GEN B_COND_GEN(
        // Inputs
        .RS1        (),
        .RS2        (),
        // Outputs
        .BR_EQ      (),
        .BR_LT      (),
        .BR_LTU     ()
        );

    BRANCH_ADDR_GEN B_ADDR_GEN(
        // Inputs
        .PC         (),
        .RS1        (),
        .I_TYPE     (),
        .J_TYPE     (),
        .B_TYPE     (),
        // Outputs
        .JALR       (),
        .BRANCH     (),
        .JAL        ()
        );

    PROG_COUNTER    PC(
        // Inputs
        .CLK        (),
        .PC_RST     (),
        .PC_WRITE   (),
        .PC_SOURCE  (),
        .JALR       (),
        .BRANCH     (),
        .JAL        (),
        .MTEVC      (),
        .MEPC       (),
        // Outputs
        .PC_COUNT   ()
        );

    OTTER_MEM       MEM(
        // Inputs
        .MEM_CLK    (),
        .MEM_RDEN1  (),
        .MEM_RDEN2  (),
        .MEM_WE2    (),
        .MEM_ADDR1  (),
        .MEM_ADDR2  (),
        .MEM_DIN2   (),
        .MEM_SIZE   (),
        .MEM_SIGN   (),
        .IO_IN      (),
        // Outputs
        .IO_WR      (),
        .MEM_DOUT1  (),
        .MEM_DOUT2  ()
        );

    REG_FILE        REG(
        // Inputs
        .CLK        (),
        .WR_EN      (),
        .WR_ADDR    (),
        .WR_DATA    (),
        .ADDR1      (),
        .ADDR2      (),
        // Outputs
        .RS1        (),
        .RS2        ()
        );

    IMMED_GEN       I_GEN(
        // Inputs
        .IR         (), 
        // Outputs
        .U_TYPE     (),
        .I_TYPE     (),
        .S_TYPE     (),
        .B_TYPE     (),
        .J_TYPE     ()
        );

    ARTH_LOGIC_UNIT ALU (
        // Inputs
        .ALU_FUNC   (),
        .SRC_A      (),
        .SRC_B      (),
        // Outputs
        .RESULT     ()
        );

    CU_DCDR      CU_DCDR(
        // Inputs
        .OPCODE     (),
        .FUNC_3     (),
        .FUNC_7     (),
        .INT_TAKEN  (),
        .BR_EQ      (),
        .BR_LT      (),
        .BR_LTU     (),
        // Outputs
        .ALU_FUN    (),
        .ALU_SRC_A  (),
        .ALU_SRC_B  (),
        .PC_SOURCE  (),
        .RF_WR_SEL  (),
        );

    CU_FSM          CU_FSM(
        // Inputs
        .CLK        (),
        .RST        (),
        .OPCODE     (),
        .FUNC_3     (),
        .INTR_EN    (),
        // Outputs
        .PC_WRITE   (),
        .REG_WRITE  (),
        .RST_MODULE (),
        .MEM_WE2    (),
        .MEM_RDEN1  (),
        .MEM_RDEN2  (),
        .CSR_WE     (),
        .INT_TAKEN  (),
        .MRET_EXEC  () 
        );

    initial begin

    end

    always_comb begin

    end

endmodule

// End of File //
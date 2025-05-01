//------------------------------------------------------------------------------
// File        : alu_if.sv
//  Project    : Verification UVM Framework for Nova ALU
//  Author     : Omar Ashraf Abd El Mongy
//  Created On : 1/5/2025
//  Version    : 1.0
// Description: 
//   This file defines the interface for the ALU (Arithmetic Logic Unit) signals.
//   The interface provides the necessary signals for interacting with the ALU, 
//   including control signals, data inputs/outputs, and flag indicators.
//   - alu_rst_n: Active-low reset for the ALU.
//   - alu_in1: First input operand for ALU operations.
//   - alu_in2: Second input operand for ALU operations.
//   - alu_op: Operation code that defines the ALU operation (e.g., ADD, SUB, AND, OR).
//   - alu_out: Output result of the ALU operation.
//   - alu_v_flag: ALU overflow flag (set when overflow occurs).
//   - alu_z_flag: ALU zero flag (set when the result is zero).
//   - alu_c_flag: ALU carry-out flag (set for operations that generate a carry-out).
//   - alu_n_flag: ALU negative flag (set when the result is negative).
//
// Purpose: 
//   The interface encapsulates the ALU's I/O and control signals in a reusable and 
//   modular form, which can be connected to the ALU component in the testbench.
//------------------------------------------------------------------------------

// Prevent multiple inclusions of this file
`ifndef ALU_IF_SV
    `define ALU_IF_SV

    interface alu_if(input clk);
        logic        alu_rst_n;   // Active-low reset for ALU
        logic [31:0] alu_in1;     // First operand for ALU operation
        logic [31:0] alu_in2;     // Second operand for ALU operation
        logic [3:0]  alu_op;      // ALU operation code
        logic [31:0] alu_out;     // ALU output result
        logic        alu_v_flag;  // ALU overflow flag
        logic        alu_z_flag;  // ALU zero flag
        logic        alu_c_flag;  // ALU carry-out flag
        logic        alu_n_flag;  // ALU negative flag
    endinterface

`endif

//==============================================================================
// File        : NovaALU.v
// Project     : Nova ALU - Arithmetic Logic Unit
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
// Description : 
//   This module implements a parameterized Arithmetic Logic Unit (ALU) capable 
//   of performing basic arithmetic and logic operations including ADD, SUB, AND,
//   OR, XOR, SHIFT operations, and Set-on-Less-Than.
//==============================================================================

module NovaALU #(
    parameter N = 32 // Data width
)(
    input  wire         clk,       // Clock signal
    input  wire         rst_n,     // Active-low reset
    input  wire [N-1:0] A,         // First operand
    input  wire [N-1:0] B,         // Second operand
    input  wire [3:0]   ALU_Sel,   // Operation select
    output reg  [N-1:0] ALU_Result,// Result of ALU operation
    output wire         Zero,      // Zero flag
    output wire         CarryOut,  // Carry flag (for addition/subtraction)
    output wire         Overflow,  // Overflow flag
    output wire         Negative   // Negative flag
);

    // Temporary result with an extra bit for detecting carry
    reg [N:0] tmp_result;

    // ALU operation
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            ALU_Result <= 0;
        end
        else begin
            case(ALU_Sel)
                4'b0000: begin // ADD
                    tmp_result <= {1'b0, A} + {1'b0, B};
                    ALU_Result <= tmp_result[N-1:0];
                end

                4'b0001: begin // SUB
                    tmp_result <= {1'b0, A} - {1'b0, B};
                    ALU_Result <= tmp_result[N-1:0];
                end

                4'b0010: ALU_Result <= A & B;       // AND
                4'b0011: ALU_Result <= A | B;       // OR
                4'b0100: ALU_Result <= A ^ B;       // XOR
                4'b0101: ALU_Result <= A << 1;      // Logical shift left
                4'b0110: ALU_Result <= A >> 1;      // Logical shift right
                4'b0111: ALU_Result <= (A < B) ? 1 : 0; // Set if less than (unsigned)
                // Default case
                default: ALU_Result <= 0;       
            endcase
        end
    end
    // Status flags
    assign Zero     = (ALU_Result == 0);   // Zero flag
    assign Negative = ALU_Result[N-1];     // MSB indicates negative in signed numbers
    assign Overflow = ((ALU_Sel == 0) && (A[N-1] == B[N-1]) && (ALU_Result[N-1] != A[N-1])) | // Over flow flag
                      ((ALU_Sel == 1) && (A[N-1] != B[N-1]) && (ALU_Result[N-1] != A[N-1]));
    assign CarryOut = ((ALU_Sel == 0) && tmp_result[N]) | ((ALU_Sel == 1) && tmp_result[N]); // Carry Out flag
endmodule

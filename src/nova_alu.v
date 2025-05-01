module NovaALU #(
    parameter N = 32
)(
    input  wire         clk,
    input  wire         rst_n, //Active Low Reset 
    input  wire [N-1:0] A,
    input  wire [N-1:0] B,
    input  wire [3:0]   ALU_Sel,
    output reg  [N-1:0] ALU_Result,
    output wire         Zero,
    output reg          CarryOut,
    output reg          Overflow,
    output wire         Negative
);

    reg [N:0] tmp_result; // One extra bit for carry

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            CarryOut   <= 0;
            Overflow   <= 0;
            ALU_Result <= 0;
        end
        else 
            case(ALU_Sel)
                4'b0000: begin // ADD
                    tmp_result <= {1'b0, A} + {1'b0, B};
                    ALU_Result <= tmp_result[N-1:0];
                    CarryOut   <= tmp_result[N];
                    Overflow   <= (A[N-1] == B[N-1]) && (ALU_Result[N-1] != A[N-1]);
                end

                4'b0001: begin // SUB
                    tmp_result <= {1'b0, A} - {1'b0, B};
                    ALU_Result <= tmp_result[N-1:0];
                    CarryOut   <= tmp_result[N]; // Borrow is not simply the carry bit
                    Overflow   <= (A[N-1] != B[N-1]) && (ALU_Result[N-1] != A[N-1]);
                end

                4'b0010: ALU_Result <= A & B;  // AND
                4'b0011: ALU_Result <= A | B;  // OR
                4'b0100: ALU_Result <= A ^ B;  // XOR
                4'b0101: ALU_Result <= A << 1; // Shift left
                4'b0110: ALU_Result <= A >> 1; // Logical right shift
                4'b0111: ALU_Result <= (A < B) ? 1 : 0; // SLT unsigned

                default: ALU_Result <= 0;
            endcase
    end
    // Flags
    assign Zero     = (ALU_Result == 0);
    assign Negative = ALU_Result[N-1];

endmodule

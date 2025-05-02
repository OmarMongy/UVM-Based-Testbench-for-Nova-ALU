// ***************************************************************************
// ALU Scoreboard Class
//
// This class defines a scoreboard for the ALU (Arithmetic Logic Unit) in a
// UVM (Universal Verification Methodology) testbench. The scoreboard is responsible 
// for comparing the actual results from the ALU with the expected results generated 
// by a reference model, as well as checking the flags (Zero, Negative, CarryOut, 
// and Overflow) for correctness. This class also utilizes a configuration object 
// (`alu_env_config`) for controlling result and flag checking based on the test plan.
//
// The scoreboard performs the following operations:
// - It computes expected ALU results based on the operation and input values using 
//   the reference model.
// - It compares the expected results to the actual results from the ALU.
// - It compares the expected flags to the actual flags for correctness.
//
// File        : alu_scoreboard.sv
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
// ***************************************************************************

class alu_scoreboard extends uvm_scoreboard;

  // UVM component utility macro for the alu_scoreboard class
  `uvm_component_utils(alu_scoreboard)

  // Scoreboard configuration handler: Holds configuration for the scoreboard
  alu_env_config scb_config;

  // Analysis export to receive ALU monitor items for comparison
  // This export is used to collect monitored items for result and flag comparison
  uvm_analysis_imp_item #(alu_item_mon, alu_scoreboard) port_item;

  // Constructor for the ALU scoreboard class
  // Initializes the analysis export port_item
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
    port_item = new("port_item", this);  // Instantiate the analysis port to receive items
  endfunction

  // Reference model function to compute expected ALU result and flags
  // @param item - The ALU item to be processed and compared
  // @param expected_result - The expected ALU result to be updated
  // @param exp_zero - The expected Zero flag to be updated
  // @param exp_negative - The expected Negative flag to be updated
  // @param exp_carry - The expected CarryOut flag to be updated
  // @param exp_overflow - The expected Overflow flag to be updated
  function void reference_model(alu_item_mon item, ref logic [31:0] expected_result,
                                ref bit exp_zero, ref bit exp_negative,
                                ref bit exp_carry, ref bit exp_overflow);
    logic signed [31:0] a, b, result;

    // Initialize input values and flags
    a = item.in1;
    b = item.in2;
    result = 0;
    exp_zero = 0;
    exp_negative = 0;
    exp_carry = 0;
    exp_overflow = 0;

    // Compute result based on the ALU operation code
    case (item.op)
      4'b0000: result = a + b;                         // ADD
      4'b0001: result = a - b;                         // SUB
      4'b0010: result = a & b;                         // AND
      4'b0011: result = a | b;                         // OR
      4'b0100: result = a ^ b;                         // XOR
      4'b0101: result = a << 1;                        // Shift left
      4'b0110: result = a >> 1;                        // Shift Right
      4'b0111: result = (a < b) ? 1 : 0;               // SLT
      default: result = 0;                             // Undefined opcode
    endcase

    // Update expected results and flags
    expected_result = result;
    exp_zero = (result == 0);
    exp_negative = result[31];

    // Carry and Overflow calculations for ADD/SUB
    if (item.op == 4'b0000) begin  // ADD
      exp_carry = ((a[31] & b[31]) | ((a[31] | b[31]) & ~result[31]));
      exp_overflow = ((a[31] == b[31]) && (result[31] != a[31]));
    end else if (item.op == 4'b0001) begin // SUB
      exp_carry = ((a[31] & b[31]) | ((a[31] | b[31]) & ~result[31]));
      exp_overflow = ((a[31] != b[31]) && (result[31] != a[31]));
    end
  endfunction

  // Task to compare actual ALU results and flags with expected values
  // This task checks if the actual result and flags match the expected values
  // and reports errors if there is a mismatch.
  // @param item - The ALU item to be checked against the reference model
  virtual task write_item(alu_item_mon item);
    logic [31:0] expected_result;
    bit exp_zero, exp_negative, exp_carry, exp_overflow;

    // Call reference model to compute expected values
    reference_model(item, expected_result, exp_zero, exp_negative, exp_carry, exp_overflow);

    // Check if result checking is enabled and compare the expected and actual results
    if(scb_config.get_chk_rslt()) begin
      if (item.rslt !== expected_result) begin
        `uvm_error(get_type_name(), $sformatf("Mismatch result: expected=0d%0d, actual=0d%0d", expected_result, item.rslt))
      end
    end

    // Check if flag checking is enabled and compare the expected and actual flags
    if(scb_config.get_chk_flg()) begin
      if (item.Zero !== exp_zero)
        `uvm_error(get_type_name(), $sformatf("Mismatch Zero flag: expected=%0b, actual=%0b", exp_zero, item.Zero))
      if (item.Negative !== exp_negative)
        `uvm_error(get_type_name(), $sformatf("Mismatch Negative flag: expected=%0b, actual=%0b", exp_negative, item.Negative))
      if (item.CarryOut !== exp_carry)
        `uvm_error(get_type_name(), $sformatf("Mismatch CarryOut flag: expected=%0b, actual=%0b", exp_carry, item.CarryOut))
      if (item.Overflow !== exp_overflow)
        `uvm_error(get_type_name(), $sformatf("Mismatch Overflow flag: expected=%0b, actual=%0b", exp_overflow, item.Overflow))
    end  
  endtask

endclass

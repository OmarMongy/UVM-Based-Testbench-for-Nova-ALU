///////////////////////////////////////////////////////////////////////////////
// File:        testbench.sv
// Author:      Omar A. Mongy 
// Date:        1/5/2025
// Description: Testbench module. It contains the instance of the DUT and the 
//              logic to start the UVM test and UVM phases.
///////////////////////////////////////////////////////////////////////////////

`include "alu_test_pkg.sv"

module testbench;

  import uvm_pkg::*;
  import alu_test_pkg::*;

  reg clk_tb;

  // Clock generator
  initial begin
    clk_tb = 0;    
    forever begin
      // Generate a 100MHz clock
      clk_tb = #5ns ~clk_tb;
    end
  end

  // Interface instance
  alu_if alu_if_tb(.clk(clk_tb));

  // Start simulation
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    // Set virtual interface
    uvm_config_db#(virtual alu_if)::set(null, "uvm_test_top.env.agent", "vif", alu_if_tb);

    // Start UVM test and phases
    run_test(""); // Add The Test Name Here!
  end
  
  // DUT instantiation
  NovaALU dut (
    .clk       (clk_tb),
    .rst_n     (alu_if_tb.alu_rst_n),
    .A         (alu_if_tb.alu_in1),
    .B         (alu_if_tb.alu_in2),
    .ALU_Sel   (alu_if_tb.alu_op),
    .ALU_Result(alu_if_tb.alu_out),
    .Overflow  (alu_if_tb.alu_v_flag),
    .Zero      (alu_if_tb.alu_z_flag),
    .CarryOut  (alu_if_tb.alu_c_flag),
    .Negative  (alu_if_tb.alu_n_flag)
  );

endmodule

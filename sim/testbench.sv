//==============================================================================
// File        : testbench.sv
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
// Description : 
//   Top-level SystemVerilog testbench that instantiates the ALU DUT, connects 
//   the UVM interface, and launches the UVM test sequence using alu_main_test.
//==============================================================================

`include "alu_test_pkg.sv"

module testbench;

  import uvm_pkg::*;          // Import UVM base package
  import alu_test_pkg::*;     // Import test package containing test classes

  reg clk_tb;                 // Clock signal for testbench

  // Clock generation: 100MHz clock => 10ns period => toggle every 5ns
  initial begin
    clk_tb = 0;    
    forever #5ns clk_tb = ~clk_tb;
  end

  // Interface instance connected to the DUT
  alu_if alu_if_tb (.clk(clk_tb));

  // DUT instantiation
  NovaALU dut (
    .clk        (clk_tb),
    .rst_n      (alu_if_tb.alu_rst_n),
    .A          (alu_if_tb.alu_in1),
    .B          (alu_if_tb.alu_in2),
    .ALU_Sel    (alu_if_tb.alu_op),
    .ALU_Result (alu_if_tb.alu_out),
    .Overflow   (alu_if_tb.alu_v_flag),
    .Zero       (alu_if_tb.alu_z_flag),
    .CarryOut   (alu_if_tb.alu_c_flag),
    .Negative   (alu_if_tb.alu_n_flag)
  );

  // Start simulation and UVM test
  initial begin
    // Dump waveform for viewing in GTKWave
    $dumpfile("dump.vcd");
    $dumpvars;

    // Set virtual interface for the UVM test environment
    uvm_config_db#(virtual alu_if)::set(null, "uvm_test_top.env.agent", "vif", alu_if_tb);

    // Run the UVM test - specify test name here
    run_test("alu_main_test");
  end

endmodule

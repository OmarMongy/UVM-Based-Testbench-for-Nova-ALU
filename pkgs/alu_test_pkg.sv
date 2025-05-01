//==============================================================================
// File        : alu_test_pkg.sv
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
// Description : 
//   This UVM package includes the base test and a main test to verify the ALU 
//   functionality. It instantiates the environment and runs sequences for reset 
//   and stimulus generation.
//==============================================================================

`ifndef ALU_TEST_PKG_SV
`define ALU_TEST_PKG_SV

  // UVM Macros and Environment package includes
  `include "uvm_macros.svh"
  `include "alu_env_pkg.sv"

package alu_test_pkg;

  import uvm_pkg::*;              // Import UVM base classes
  import alu_env_pkg::*;         // Import ALU environment
  import alu_agent_pkg::*;       // Import ALU agent and sequences

  // Base test class that builds the environment
  class alu_test_base extends uvm_test;
    alu_env env;                 // Environment handle

    `uvm_component_utils(alu_test_base)

    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction

    // Build phase to construct the environment
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = alu_env::type_id::create("env", this);
    endfunction
  endclass

  // Main test class extending the base test
  class alu_main_test extends alu_test_base;
    `uvm_component_utils(alu_main_test)

    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction

    // Run phase for executing reset and stimulus sequences
    virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);

      // Raise objection to keep simulation alive
      phase.raise_objection(this, "TEST_DONE");

      // Reset sequence: Apply 5 randomized resets
      begin
        alu_sequence_reset seq_rst = alu_sequence_reset::type_id::create("seq_rst");
        repeat(5) begin
          void'(seq_rst.randomize());
          seq_rst.start(env.agent.sequencer);
        end
      end

      // Main functional sequence: 100 random operations
      begin
        alu_sequence_simple seq_simple = alu_sequence_simple::type_id::create("seq_simple");
        repeat(100) begin
          void'(seq_simple.randomize());
          env.env_config.set_chk_flg(0); // Disable internal checks if needed
          seq_simple.start(env.agent.sequencer);
        end
      end

      // End of test message
      `uvm_info("DEBUG", "this is the end of the test", UVM_LOW)

      // Drop objection to end simulation
      phase.drop_objection(this, "TEST_DONE");
    endtask
  endclass

endpackage

`endif

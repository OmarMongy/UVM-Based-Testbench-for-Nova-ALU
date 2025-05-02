//------------------------------------------------------------------------------
// Title       : ALU Edge/Boundary Case Test
// File        : alu_edge_case_test.sv
// Description : UVM test for verifying ALU behavior with boundary inputs.
//               Applies extreme values like all-zeroes and all-ones to in1/in2
//               and executes a wide range of opcodes.
//               Also exercises repeated resets to validate robustness.
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//------------------------------------------------------------------------------
// Notes       :
// - Focuses on testing corner cases such as:
//     * Zero and maximum values (0x0000_0000, 0xFFFF_FFFF)
//     * Sequential resets
// - Useful for uncovering overflow, carry, or underflow issues.
// - Designed to be run under the alu_test_base infrastructure.
//------------------------------------------------------------------------------

//  Boundary/Edge case test class extending the base test
  class alu_edge_case_test extends alu_test_base;
    `uvm_component_utils(alu_edge_case_test)

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
          void'(seq_simple.randomize() with {
            in1 inside {32'h0, 32'hFFFF_FFFF};
            in2 inside {32'h0, 32'hFFFF_FFFF};
            op  inside {[0:7]};
          });
          env.env_config.set_chk_flg(1); // Disable internal checks if needed
          env.agent.agt_config.set_has_checks(1); // Disable assertion checks if needed
          seq_simple.start(env.agent.sequencer);
        end
      end

      // End of test message
      `uvm_info("DEBUG", "this is the end of the test", UVM_LOW)

      // Drop objection to end simulation
      phase.drop_objection(this, "TEST_DONE");
    endtask
  endclass

//------------------------------------------------------------------------------
// Title       : ALU Basic Operations Test
// File        : alu_basic_operations_test.sv
// Description : UVM test class that verifies basic ALU functionality
//               by applying fixed operand values and a specific operation.
//               This test ensures the ALU performs known operations correctly.
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//------------------------------------------------------------------------------
// Notes       :
// - Applies a reset sequence before main testing.
// - Repeats the same ALU operation (e.g., op = 0) with fixed inputs.
// - Useful as a smoke or regression test for basic ALU functionality.
//------------------------------------------------------------------------------
// Basic operations test class extending the base test
  class alu_basic_operations_test extends alu_test_base;
    `uvm_component_utils(alu_basic_operations_test)

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
        repeat(1000) begin
          void'(seq_simple.randomize() with {
            in1 inside {[32'h0 : 32'hFFFF_FFFF]};
            in2 inside {[32'h0 : 32'hFFFF_FFFF]};
            op  inside {[0:7]};
          });
          env.env_config.set_chk_flg(1); // Disable internal checks if needed
          seq_simple.start(env.agent.sequencer);
        end
      end

      // End of test message
      `uvm_info("DEBUG", "this is the end of the test", UVM_LOW)

      // Drop objection to end simulation
      phase.drop_objection(this, "TEST_DONE");
    endtask
  endclass

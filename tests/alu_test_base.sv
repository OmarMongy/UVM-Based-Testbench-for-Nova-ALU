//------------------------------------------------------------------------------
// Title       : ALU Base Test
// File        : alu_test_base.sv
// Description : UVM base test class that instantiates the ALU verification environment.
//               All specialized ALU tests (e.g., random, edge, reset) should extend this.
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//------------------------------------------------------------------------------
// Notes       :
// - Contains the build_phase where the testbench environment is created.
// - Acts as the common parent for all test scenarios.
//------------------------------------------------------------------------------
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

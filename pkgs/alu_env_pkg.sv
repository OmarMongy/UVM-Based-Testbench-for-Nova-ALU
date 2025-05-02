//------------------------------------------------------------------------------
// File        : alu_env_pkg.sv
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
// Description: 
//   This package defines the UVM environment for testing the ALU (Arithmetic Logic 
//   Unit) design. It includes the configuration, coverage, scoreboard, and agent 
//   components necessary to perform functional verification of the ALU module.
//   - alu_env_config: Configuration class to enable coverage, result, and flag checks.
//   - alu_coverage: Class to collect and report coverage data on ALU flags and operations.
//   - alu_scoreboard: Scoreboard for comparing expected and actual ALU outputs based on
//     reference models for various operations.
//   - alu_env: The main environment class that integrates the components, including the agent,
//     scoreboard, coverage, and configuration settings.
//
// Dependencies:
//   - alu_agent_pkg.sv: Includes the agent and monitor for ALU operations.
//   - uvm_pkg: Standard UVM library for verification.
//
//------------------------------------------------------------------------------

`ifndef ALU_ENV_PKG
  `define ALU_ENV_PKG

  `include "alu_agent_pkg.sv"

  package alu_env_pkg;

    import uvm_pkg::*;
    import alu_agent_pkg::*;
    `include "uvm_macros.svh"

  class alu_env_config extends uvm_component;

    // Enable Collectiong Coverage
    bit unsigned has_coverage;
    // Enable Checking The ALU Result
    bit unsigned chk_rslt;
    // Enable Checking The ALU Flags
    bit unsigned chk_flg;

    `uvm_component_utils(alu_env_config)

    function new(string name = "", uvm_component parent);
        super.new(name, parent);
        has_coverage = 1;
        chk_rslt     = 1;
        chk_flg      = 1;
    endfunction

    virtual function void set_has_coverage(bit value_cov);
      has_coverage = value_cov;
    endfunction

    virtual function bit get_has_coverage();
      return has_coverage;
    endfunction

    virtual function void set_chk_rslt(bit value_cr);
      chk_rslt = value_cr;
    endfunction

    virtual function bit get_chk_rslt();
      return chk_rslt;
    endfunction

    virtual function void set_chk_flg(bit value_cf);
      chk_flg = value_cf;
    endfunction

    virtual function bit get_chk_flg();
      return chk_flg;
    endfunction
  endclass

`uvm_analysis_imp_decl(_item)  //_item => the name that will be used in creation of the port

  class alu_coverage extends uvm_component;
    // Port for receiving the collected item
    uvm_analysis_imp_item #(alu_item_mon, alu_coverage) port_item; 
    
    `uvm_component_utils(alu_coverage)
    
    covergroup cover_item with function sample(alu_item_mon item);
      option.per_instance = 1; //collect coverage for each instance of agent

      Overflow : coverpoint item.Overflow {
        option.comment = "ALU Overflow Flag";
      }
      Zero : coverpoint item.Zero {
        option.comment = "ALU Zero Flag";
      }
      CarryOut : coverpoint item.CarryOut {
        option.comment = "ALU CarryOut Flag";
      }
      Negative : coverpoint item.Negative {
        option.comment = "ALU Negative Flag";
      }    
      OpCode : coverpoint item.op {
        option.comment = "ALU Op-Code";
      }
    endgroup
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      port_item = new("port_item", this);
      cover_item = new();
      cover_item.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_item")); //mapping cover item due to the verf. plan
    endfunction

    virtual function void write_item(alu_item_mon item);
      cover_item.sample(item);
    endfunction
    
  endclass

  class alu_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(alu_scoreboard)
  // Scoreboard configuration handler
  alu_env_config scb_config;
  // Analysis export to receive itemactions from the monitor
  uvm_analysis_imp_item #(alu_item_mon, alu_scoreboard) port_item;

  // Constructor
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
    port_item = new("port_item", this);  
  endfunction

  // Reference model function to compute expected ALU result
  function void reference_model(alu_item_mon item, ref logic [31:0] expected_result,
                                ref bit exp_zero, ref bit exp_negative,
                                ref bit exp_carry, ref bit exp_overflow);
    logic signed [31:0] a, b, result;

    a = item.in1;
    b = item.in2;
    result = 0;
    exp_zero = 0;
    exp_negative = 0;
    exp_carry = 0;
    exp_overflow = 0;

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

    expected_result = result;
    exp_zero = (result == 0);
    exp_negative = result[31];

    // Example Carry and Overflow calculation for ADD/SUB
    if (item.op == 4'b0000) begin  // ADD
      exp_carry = ((a[31] & b[31]) | ((a[31] | b[31]) & ~result[31]));
      exp_overflow = ((a[31] == b[31]) && (result[31] != a[31]));
    end else if (item.op == 4'b0001) begin // SUB
      exp_carry = ((a[31] & b[31]) | ((a[31] | b[31]) & ~result[31]));
      exp_overflow = ((a[31] != b[31]) && (result[31] != a[31]));
    end
  endfunction

  // Compare actual with expected values
  virtual task write_item(alu_item_mon item);
    logic [31:0] expected_result;
    bit exp_zero, exp_negative, exp_carry, exp_overflow;

    reference_model(item, expected_result, exp_zero, exp_negative, exp_carry, exp_overflow);
    if(scb_config.get_chk_rslt()) begin
      if (item.rslt !== expected_result) begin
        `uvm_error(get_type_name(), $sformatf("Mismatch result: expected=0d%0d, actual=0d%0d", expected_result, item.rslt))
      end
    end
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

    // Environment class
    class alu_env extends uvm_env;

      `uvm_component_utils(alu_env)

      // Agent handler
      alu_agent agent;
      // Environment configuration handler
      alu_env_config env_config;
      // Coverage handler
      alu_coverage coverage;
      // Scoreboard handler
      alu_scoreboard scoreboard;

      // Constructor
      function new(string name = "", uvm_component parent);
        super.new(name, parent);
      endfunction

      // Build phase: create the agent
      virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent      = alu_agent::type_id::create("agent", this);

        env_config = alu_env_config::type_id::create("env_config", this);

        scoreboard = alu_scoreboard::type_id::create("scoreboard", this);

        if(env_config.get_has_coverage()) begin
          coverage = alu_coverage::type_id::create("coverage", this);
        end
      endfunction

      virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        scoreboard.scb_config = env_config;

        agent.monitor.output_port.connect(scoreboard.port_item);

        if(env_config.get_has_coverage()) begin
          agent.monitor.output_port.connect(coverage.port_item);
        end
      endfunction
    endclass

  endpackage

`endif

      

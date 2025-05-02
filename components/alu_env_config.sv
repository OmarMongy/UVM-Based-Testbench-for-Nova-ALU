// ***************************************************************************
// ALU Environment Configuration Class
//
// This class defines the environment configuration for an ALU (Arithmetic Logic Unit) 
// testbench in UVM (Universal Verification Methodology). It includes control 
// parameters for enabling coverage collection, result checking, and flag checking.
//
// The class provides functions to set and get the values of these parameters. 
// These parameters can be used to control the behavior of the ALU verification 
// environment based on different scenarios (coverage, result checking, and flag checking).
//
// File        : alu_env_config.sv
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
// ***************************************************************************
class alu_env_config extends uvm_component;

    // Enable Collection of Coverage
    // Controls whether coverage collection is enabled during the simulation.
    bit unsigned has_coverage;

    // Enable Checking the ALU Result
    // Controls whether the ALU result is checked during the simulation.
    bit unsigned chk_rslt;

    // Enable Checking the ALU Flags
    // Controls whether the ALU flags (e.g., zero, carry, overflow) are checked.
    bit unsigned chk_flg;

    // UVM component utility macro for alu_env_config class
    `uvm_component_utils(alu_env_config)

    // Constructor function for initializing default values of parameters
    function new(string name = "", uvm_component parent);
        super.new(name, parent);
        has_coverage = 1; // Default: coverage collection enabled
        chk_rslt     = 1; // Default: ALU result checking enabled
        chk_flg      = 1; // Default: ALU flag checking enabled
    endfunction

    // Set the coverage collection flag
    // @param value_cov - Boolean value to set coverage collection flag
    virtual function void set_has_coverage(bit value_cov);
      has_coverage = value_cov;
    endfunction

    // Get the current coverage collection flag status
    // @return has_coverage - Current status of coverage collection flag
    virtual function bit get_has_coverage();
      return has_coverage;
    endfunction

    // Set the ALU result checking flag
    // @param value_cr - Boolean value to set ALU result checking flag
    virtual function void set_chk_rslt(bit value_cr);
      chk_rslt = value_cr;
    endfunction

    // Get the current ALU result checking flag status
    // @return chk_rslt - Current status of ALU result checking flag
    virtual function bit get_chk_rslt();
      return chk_rslt;
    endfunction

    // Set the ALU flag checking flag
    // @param value_cf - Boolean value to set ALU flag checking flag
    virtual function void set_chk_flg(bit value_cf);
      chk_flg = value_cf;
    endfunction

    // Get the current ALU flag checking flag status
    // @return chk_flg - Current status of ALU flag checking flag
    virtual function bit get_chk_flg();
      return chk_flg;
    endfunction

endclass

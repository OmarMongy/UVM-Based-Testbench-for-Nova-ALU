//-----------------------------------------------------------------------------
// File         : alu_config.sv
// Description  : ALU Configuration Component for the Agent UVM Testbench
//               This class defines a UVM component that manages the ALU's 
//               configuration, including the setup of the virtual interface 
//               (`alu_vif`) and controls for the ALU's active or passive 
//               state. The class includes getters and setters for the virtual 
//               interface and active/passive control, and checks the configuration 
//               during the start of the simulation phase.
//               
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//-----------------------------------------------------------------------------

`ifndef ALU_CONFIG_SV
`define ALU_CONFIG_SV

// Import necessary UVM packages
`include "uvm_macros.svh"
`include "alu_vif.sv"

// Define the ALU configuration component class
class alu_config extends uvm_component;
    `uvm_component_utils(alu_config)

    // Virtual interface for ALU
    local alu_vif vif;
    
    // Control for active or passive mode
    local uvm_active_passive_enum active_passive;

    // Constructor
    function new(string name = "", uvm_component parent);
        super.new(name, parent);
        active_passive = UVM_ACTIVE; // Default to active agent
    endfunction

    // Getter for the virtual interface
    virtual function alu_vif get_vif();
        return vif;
    endfunction

    // Setter for the virtual interface
    virtual function void set_vif(alu_vif value);
      if (vif == null) begin
        vif = value; // Set the virtual interface if not already set
      end
      else begin
        `uvm_fatal("ALGORITHM_ISSUE", "Trying to set the ALU virtual interface more than once")
      end
    endfunction

    // Start of simulation phase callback
    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        
        if (get_vif() == null) begin
            `uvm_fatal("ALGORITHM_ISSUE", "The ALU virtual interface is not configured at \"Start of simulation\" phase")
        end
        else begin
            `uvm_info("ALU_CONFIG", "The ALU virtual interface is configured at \"Start of simulation\" phase", UVM_DEBUG)
        end
    endfunction
    
    // Setter for the active/passive control
    virtual function void set_active_passive(uvm_active_passive_enum value);
        active_passive = value;
    endfunction

    // Getter for the ALU active/passive control
    virtual function uvm_active_passive_enum get_active_passive();
        return active_passive;
    endfunction
endclass

`endif // ALU_CONFIG_SV

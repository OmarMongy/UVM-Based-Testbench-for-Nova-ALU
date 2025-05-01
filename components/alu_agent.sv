//-----------------------------------------------------------------------------
// File         : alu_agent.sv
// Description  : ALU Agent for UVM Testbench
//               This class defines a UVM agent that integrates the ALU driver, 
//               sequencer, and monitor components. The agent is responsible 
//               for coordinating the operation of the ALU components and 
//               managing the virtual interface configuration. It also supports 
//               active/passive configuration for flexibility in simulation.
//               
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//-----------------------------------------------------------------------------

`ifndef ALU_AGENT_SV
`define ALU_AGENT_SV

// Import necessary UVM packages
`include "uvm_macros.svh"
`include "alu_config.sv"
`include "alu_driver.sv"
`include "alu_sequencer.sv"
`include "alu_monitor.sv"
`include "alu_if.sv"

// Define the ALU agent class
class alu_agent extends uvm_agent;
    
    `uvm_component_utils(alu_agent)
    
    // Agent configuration handler    
    alu_config agt_config;
    // Agent driver handler    
    alu_driver driver;
    // Agent sequencer handler    
    alu_sequencer sequencer;
    // Agent monitor handler    
    alu_monitor monitor;

    // Constructor for the ALU agent
    function new(string name = "", uvm_component parent);
        super.new(name, parent);  // Call the base class constructor
    endfunction

    // Build phase: Create components and configure agent
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create the agent configuration and monitor components
        agt_config = alu_config::type_id::create("agt_config", this);
        monitor = alu_monitor::type_id::create("monitor", this);

        // If agent is active, create the driver and sequencer components
        if(agt_config.get_active_passive() == UVM_ACTIVE) begin
            driver = alu_driver::type_id::create("driver", this);
            sequencer = alu_sequencer::type_id::create("sequencer", this);
        end 
    endfunction

    // Connect phase: Set up virtual interface and component connections
    virtual function void connect_phase(uvm_phase phase);
      alu_vif vif;
      string      vif_name = "vif";
      
      super.connect_phase(phase);
      
      // Get the ALU virtual interface from the configuration database
      if(!uvm_config_db#(virtual alu_if)::get(this, "", vif_name, vif)) begin
        `uvm_fatal("ALU_NO_VIF", $sformatf("Could not get from the database the ALU virtual interface using name \"%0s\"", vif_name))
      end
      else begin
        // Set the virtual interface in the agent configuration
        agt_config.set_vif(vif);
      end
       
      // Set up the monitor configuration
      monitor.mon_config = agt_config;
   
      // If agent is active, configure the driver and sequencer
      if(agt_config.get_active_passive() == UVM_ACTIVE) begin
        driver.drv_config = agt_config;
        driver.seq_item_port.connect(sequencer.seq_item_export);  // Connect sequencer to driver
      end
    endfunction

endclass

`endif // ALU_AGENT_SV

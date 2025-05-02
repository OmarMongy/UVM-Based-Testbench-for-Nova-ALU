///////////////////////////////////////////////////////////////////////////////
// =============================================================================
//  File       : alu_agent_pkg.sv
//  Project    : Verification UVM Framework for Nova ALU
//  Author     : Omar Ashraf Abd El Mongy
//  Created On : 1/5/2025
//  Version    : 1.0
// =============================================================================
//  Description:
//
//  This SystemVerilog package `alu_agent_pkg` defines a complete UVM-based
//  ALU agent implementation used for driving and
//  monitoring ALU interfaces in a modular testbench.
//
//  It encapsulates all required components to instantiate, configure, and
//  interact with an ALU agent as part of a Universal Verification Methodology
//  (UVM) environment.
//
//  The agent supports both active (driving) and passive (monitoring) modes
//  and includes configuration options such as agent-level control,
//  checking assertions and built-in sequences.
//
//  This package is intended to be shared across different simple
//  projects, enabling consistent verification methodology and reuse.
//
// -----------------------------------------------------------------------------
//  Package Contents:
//
//  - alu_types.sv               : Defines enumerations, macros, and constants
//
//  - alu_item_base.sv           : Base class for ALU transactions
//  - alu_item_drv.sv            : Driver-side transaction extension
//  - alu_item_mon.sv            : Monitor-side transaction representation
//
//  - alu_agent_config.sv        : Agent configuration class with flags like
//                                     `is_active`
//  - alu_driver.sv              : Drives stimulus on the ALU interface
//  - alu_monitor.sv             : Monitors and captures ALU transactions
//  - alu_sequencer.sv           : Manages ALU sequences
//  - alu_agent.sv               : UVM agent that instantiates and connects
//                                     driver, monitor, and sequencer
//
//  - alu_sequence_base.sv       : Base class for reusable sequences
//  - alu_sequence_simple.sv     : Simple directed sequence
///////////////////////////////////////////////////////////////////////////////
`ifndef ALU_AGENT_PKG_SV
	`define ALU_AGENT_PKG_SV
    `include "uvm_macros.svh"
      `include "alu_if.sv"

package alu_agent_pkg;

import uvm_pkg::*;
    //Virtual interface type
    typedef virtual alu_if alu_vif;

    //ALU data
    typedef bit[31:0] alu_data;

    //ALU Flags Response
    typedef enum bit {ALU_VF_PASS = 0, ALU_VF_FAIL = 1} Overflow;
    typedef enum bit {ALU_ZF_PASS = 0, ALU_ZF_FAIL  = 1} Zero;
    typedef enum bit {ALU_CF_PASS = 0, ALU_CF_FAIL = 1} CarryOut;
    typedef enum bit {ALU_NF_PASS = 0, ALU_NF_FAIL  = 1} Negative;

    class alu_item_base extends uvm_sequence_item;

    //first argument
    rand alu_data in1;
    //second argument
    rand alu_data in2;   
    //op-code
    randc alu_data op;
    //rst
    rand bit unsigned rst;

    `uvm_object_utils(alu_item_base)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
    virtual function string convert2string();
      string result = $sformatf("rst: %0b, in1: %0d, in2: %0d, op: %0b", rst, in1, in2, op);
      
      return result;
    endfunction
  endclass
  class alu_item_drv extends alu_item_base;

   `uvm_object_utils(alu_item_drv)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
    virtual function string convert2string();
      string result = super.convert2string();
      
        result = $sformatf("%s", result);
      
      return result;
    endfunction
    
  endclass
  class alu_item_mon extends alu_item_base;
     //ALU Response
      Overflow Overflow;
      Zero Zero;
      CarryOut CarryOut;
      Negative Negative;
     //Result
      alu_data rslt;

    `uvm_object_utils(alu_item_mon)
    
    function new (string name = "");
      super.new(name);
    endfunction
    
    virtual function string convert2string();
      string result = super.convert2string();
      
      result = $sformatf("%s, ALU Result: %0d ,ALU Response (O.Z.C.N): %0s %0s %0s %0s", result, rslt, Overflow.name()
                                                                                                      , Zero.name()
                                                                                                      , CarryOut.name()
                                                                                                      , Negative.name());
      return result;
    endfunction
    
  endclass
class alu_config extends uvm_component;
    `uvm_component_utils(alu_config)

     //Virtual interface
    local alu_vif vif;
    //Active/Passive control
    local uvm_active_passive_enum active_passive;
    
    function new(string name = "", uvm_component parent);
        super.new(name, parent);
        active_passive  = UVM_ACTIVE; // by default active agent
    endfunction

    //Getter for the virtual interface
    virtual function alu_vif get_vif();
        return vif;
    endfunction
    //Setter for the virtual interface
    virtual function void set_vif(alu_vif value);
      if(vif == null) begin
        vif = value;
      end
      else begin
        `uvm_fatal("ALGORITHM_ISSUE", "Trying to set the ALU virtual interface more than once")
      end
    endfunction
    //Setter for the Checking the assertions  
    virtual function get_has_checks();
      return has_checks;
    endfunction
    //Getter for the Checking the assertions  
    virtual function set_has_checks(bit value);
      	has_checks = value;
      
      if(vif != null) begin
        vif.has_checks = has_checks;
      end
      endfunction
	
    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      
      if(get_vif() == null) begin
        `uvm_fatal("ALGORITHM_ISSUE", "The ALU virtual interface is not configured at \"Start of simulation\" phase")
      end
      else begin
        `uvm_info("ALU_CONFIG", "The ALU virtual interface is configured at \"Start of simulation\" phase", UVM_DEBUG)
      end
    endfunction
    
    //Setter for the Active/Passive control
    virtual function void set_active_passive(uvm_active_passive_enum value);
    	active_passive = value;
    endfunction
    //Getter for the ALU Active/Passive control
    virtual function uvm_active_passive_enum get_active_passive();
    	return active_passive;
    endfunction
endclass

class alu_driver extends uvm_driver#(.REQ(alu_item_drv));
   
    `uvm_component_utils(alu_driver)
    //Driver configuration handler 
    alu_config drv_config;
  
 function new(string name = "", uvm_component parent);
    super.new(name, parent);
  endfunction
   
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      drive_transactions();
    end
  endtask
  //Task for driving all transactions
  protected virtual task drive_transactions ();
	  begin	  
      	forever begin
          		alu_item_drv item;
          		seq_item_port.get_next_item(item);
          		drive_transaction(item);
          		seq_item_port.item_done();
      		end
    	end
  	endtask

    virtual task drive_transaction(alu_item_drv item);
      alu_vif vif = drv_config.get_vif();
    	`uvm_info("DEBUG", $sformatf("Driving \"%0s\": %0s", item.get_full_name(), item.convert2string()), UVM_NONE);

            vif.alu_rst_n  = item.rst;
            vif.alu_in1    = item.in1;
            vif.alu_in2    = item.in2;
            vif.alu_op     = item.op;  
            repeat(2) @(negedge vif.clk);   
    endtask
endclass

class alu_monitor extends uvm_monitor;
  
    //Pointer to agent configuration
    alu_config mon_config;
  
    uvm_analysis_port#(alu_item_mon) output_port;
    `uvm_component_utils(alu_monitor)
    
 function new(string name = "", uvm_component parent);
    super.new(name, parent);  
    output_port = new("output_port", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);   
    forever begin	
          collect_transaction();
      	end
  endtask
  
  protected virtual task collect_transaction();
    alu_vif vif = mon_config.get_vif();
    alu_item_mon item = alu_item_mon::type_id::create("item");
    forever begin
      // Wait for ALU to signal done
      @(negedge vif.clk);
      item.in1      = vif.alu_in1;
      item.in2      = vif.alu_in2;
      item.op       = vif.alu_op;
      item.rst      = vif.alu_rst_n;
      @(negedge vif.clk);
      item.rslt     = vif.alu_out;
      item.Overflow = Overflow'(vif.alu_v_flag);
      item.Zero     = Zero'(vif.alu_z_flag);
      item.CarryOut = CarryOut'(vif.alu_c_flag);
      item.Negative = Negative'(vif.alu_n_flag);

      output_port.write(item);
      `uvm_info("DEBUG", $sformatf("Monitored item : %0s", item.convert2string()) , UVM_NONE)
    end
  endtask
endclass

class alu_sequencer extends uvm_sequencer#(.REQ(alu_item_drv));
    
    `uvm_component_utils(alu_sequencer)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

class alu_agent extends uvm_agent;
    `uvm_component_utils(alu_agent)
    //Agent configuration handler    
    alu_config agt_config;
    //Agent driver handler    
    alu_driver driver;
    //Agent sequencer handler    
    alu_sequencer sequencer;
    //Agent monitor handler    
    alu_monitor monitor;

    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agt_config = alu_config::type_id::create("agt_config", this);
        monitor = alu_monitor::type_id::create("monitor", this);

        if(agt_config.get_active_passive() == UVM_ACTIVE) begin
            driver = alu_driver::type_id::create("driver", this);
            sequencer = alu_sequencer::type_id::create("sequencer", this);
        end 
    endfunction

    virtual function void connect_phase(uvm_phase phase);
      alu_vif vif;
      string      vif_name = "vif";
      
      super.connect_phase(phase);
      
      if(!uvm_config_db#(virtual alu_if)::get(this, "", vif_name, vif)) begin
        `uvm_fatal("ALU_NO_VIF", $sformatf("Could not get from the database the ALU virtual interface using name \"%0s\"", vif_name))
      end
      else begin
        agt_config.set_vif(vif);
      end
      	monitor.mon_config = agt_config;
   
      if(agt_config.get_active_passive() == UVM_ACTIVE) begin
        driver.drv_config = agt_config;
        driver.seq_item_port.connect(sequencer.seq_item_export);
      end
    endfunction
    
endclass
  class alu_sequence_base extends uvm_sequence#(.REQ(alu_item_drv));
    
    `uvm_declare_p_sequencer(alu_sequencer)
    
    `uvm_object_utils(alu_sequence_base)
    
    function new(string name = "");
      super.new(name);
    endfunction

  endclass
        
  class alu_sequence_simple extends alu_sequence_base;
  rand alu_item_drv item;

  `uvm_object_utils(alu_sequence_simple)

  function new(string name = "");
    super.new(name);
  endfunction

  virtual task body();
    item = alu_item_drv::type_id::create("item");
    start_item(item);
    if (!item.randomize() with {
      item.rst == 1;
      item.in1 inside {[0:10]};
      item.in2 inside {[20:25]};
      item.op  inside {[0:7]};
    }) begin
      `uvm_error("ALU_SEQ", "Randomization failed.")
    end
    finish_item(item);
  endtask

endclass
  class alu_sequence_reset extends alu_sequence_base;
    
    //Item to drive
    rand alu_item_drv item;
    `uvm_object_utils(alu_sequence_reset)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
    virtual task body();
       alu_item_drv item = alu_item_drv::type_id::create("item");
      void'(item.randomize() with {
      	item.in1 == 0;
        item.in2 == 0;
        item.op  == 0; 
        item.rst == 0;
      });
      start_item(item);
      finish_item(item);
    endtask

  endclass   
endpackage
        
`endif

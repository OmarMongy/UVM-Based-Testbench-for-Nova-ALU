//-----------------------------------------------------------------------------
// File         : alu_monitor.sv
// Description  : ALU Monitor Component for UVM Testbench
//               This class defines a UVM monitor responsible for observing 
//               the ALU's output during simulation. It captures transaction 
//               data such as input values, operation, and ALU result flags 
//               at each clock cycle and writes the monitored data to an 
//               analysis port. The monitor continuously samples the ALU output 
//               and provides the results for further processing or analysis.
//               
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//-----------------------------------------------------------------------------

`ifndef ALU_MONITOR_SV
`define ALU_MONITOR_SV

// Import necessary UVM packages
`include "uvm_macros.svh"
`include "alu_item_mon.sv"
`include "alu_config.sv"

// Define the ALU monitor class
class alu_monitor extends uvm_monitor;

    // Pointer to agent configuration
    alu_config mon_config;

    // Analysis port for monitoring data
    uvm_analysis_port#(alu_item_mon) output_port;

    `uvm_component_utils(alu_monitor)
    
    // Constructor for the monitor
    function new(string name = "", uvm_component parent);
        super.new(name, parent);  
        output_port = new("output_port", this);  // Create the output port
    endfunction
  
    // Run phase: continuously collects transactions
    task run_phase(uvm_phase phase);
        super.run_phase(phase);   
        forever begin
            collect_transaction();  // Collect transactions during the run phase
        end
    endtask
  
    // Task for collecting ALU transaction data
    protected virtual task collect_transaction();
        alu_vif vif = mon_config.get_vif();  // Get the virtual interface for the ALU
        alu_item_mon item = alu_item_mon::type_id::create("item");  // Create a new transaction item

        forever begin
            // Wait for the ALU to signal done by detecting a negative edge of the clock
            @(negedge vif.clk);
            
            // Capture the ALU input values and operation code
            item.in1      = vif.alu_in1;
            item.in2      = vif.alu_in2;
            item.op       = vif.alu_op;
            item.rst      = vif.alu_rst_n;

            // Wait for another negative edge of the clock to capture the ALU result and flags
            @(negedge vif.clk);
            
            // Capture ALU output result and flags (Overflow, Zero, CarryOut, Negative)
            item.rslt     = vif.alu_out;
            item.Overflow = Overflow'(vif.alu_v_flag);
            item.Zero     = Zero'(vif.alu_z_flag);
            item.CarryOut = CarryOut'(vif.alu_c_flag);
            item.Negative = Negative'(vif.alu_n_flag);

            // Write the collected data to the output analysis port
            output_port.write(item);

            // Log the monitored transaction for debugging
            `uvm_info("DEBUG", $sformatf("Monitored item : %0s", item.convert2string()), UVM_NONE)
        end
    endtask

endclass

`endif // ALU_MONITOR_SV

//-----------------------------------------------------------------------------
// File         : alu_driver.sv
// Description  : ALU Driver Component for UVM Testbench
//               This class defines a UVM driver responsible for driving ALU 
//               transactions in the simulation. It retrieves transaction 
//               items from the sequence, processes them, and drives the values 
//               to the ALU virtual interface. It continuously drives transactions 
//               during the simulation run phase and ensures proper interaction 
//               with the ALU model via the virtual interface.
//               
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//-----------------------------------------------------------------------------

`ifndef ALU_DRIVER_SV
`define ALU_DRIVER_SV

// Import necessary UVM packages
`include "uvm_macros.svh"
`include "alu_item_drv.sv"
`include "alu_config.sv"

// Define the ALU driver class
class alu_driver extends uvm_driver#(.REQ(alu_item_drv));
  
    `uvm_component_utils(alu_driver)
    
    // Driver configuration handler
    alu_config drv_config;
  
    // Constructor
    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction
   
    // Run phase: continuously drives transactions
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            drive_transactions();
        end
    endtask
    
    // Task for driving all transactions
    protected virtual task drive_transactions();
    begin
        forever begin
            alu_item_drv item;
            seq_item_port.get_next_item(item);  // Get the next transaction item from the sequence
            drive_transaction(item);            // Drive the transaction to the ALU virtual interface
            seq_item_port.item_done();          // Mark the item as done
        end
    end
    endtask

    // Task for driving a single transaction
    virtual task drive_transaction(alu_item_drv item);
        alu_vif vif = drv_config.get_vif();  // Retrieve the virtual interface for the ALU
        `uvm_info("DEBUG", $sformatf("Driving \"%0s\": %0s", item.get_full_name(), item.convert2string()), UVM_NONE);

        // Set ALU control signals and input values
        vif.alu_rst_n  = item.rst;
        vif.alu_in1    = item.in1;
        vif.alu_in2    = item.in2;
        vif.alu_op     = item.op;  

        // Wait for two negative clock edges before continuing
        repeat(2) @(negedge vif.clk);   
    endtask

endclass

`endif // ALU_DRIVER_SV

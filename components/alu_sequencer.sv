//-----------------------------------------------------------------------------
// File         : alu_sequencer.sv
// Description  : ALU Sequencer Component for UVM Testbench
//               This class defines a UVM sequencer that is responsible for 
//               generating and sequencing ALU transactions during simulation. 
//               The sequencer interacts with the ALU driver and provides 
//               transaction items (inputs, operation codes, and reset signal) 
//               to drive the ALU under test.
//               
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//-----------------------------------------------------------------------------

`ifndef ALU_SEQUENCER_SV
`define ALU_SEQUENCER_SV

// Import necessary UVM packages
`include "uvm_macros.svh"
`include "alu_item_drv.sv"

// Define the ALU sequencer class
class alu_sequencer extends uvm_sequencer#(.REQ(alu_item_drv));

    `uvm_component_utils(alu_sequencer)
    
    // Constructor for the sequencer
    function new(string name = "", uvm_component parent);
        super.new(name, parent);  // Call the base class constructor
    endfunction

endclass

`endif // ALU_SEQUENCER_SV

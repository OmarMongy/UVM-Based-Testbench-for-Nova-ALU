//-----------------------------------------------------------------------------
// File         : alu_sequence_reset.sv
// Description  : Reset ALU sequence class
//               This class extends the base ALU sequence class and defines a 
//               reset sequence for the ALU. The sequence sets the inputs to 
//               zero and applies a reset operation to the ALU.
//               
// Project      : Verification UVM Framework for Nova ALU
// Author       : Omar Ashraf Abd El Mongy
// Date         : 1/5/2025
// Version      : 1.0
//-----------------------------------------------------------------------------

`ifndef ALU_SEQUENCE_RESET_SV
`define ALU_SEQUENCE_RESET_SV

// Import necessary UVM packages
`include "uvm_macros.svh"
`include "alu_item_drv.sv"
`include "alu_sequence_base.sv"

// Define the reset ALU sequence class
class alu_sequence_reset extends alu_sequence_base;

    // Declare the random sequence item
    rand alu_item_drv item;

    // Register the class with UVM's factory
    `uvm_object_utils(alu_sequence_reset)

    // Constructor for the reset ALU sequence
    function new(string name = "");
        super.new(name);  // Call the base class constructor
    endfunction

    // The main body of the reset sequence
    virtual task body();
        // Create a new sequence item of type alu_item_drv
        item = alu_item_drv::type_id::create("item");

        // Randomize the sequence item with constraints for reset operation
        void'(item.randomize() with {
            item.in1 == 0;    // Set operand 1 to 0
            item.in2 == 0;    // Set operand 2 to 0
            item.op  == 0;    // Set operation code to 0 (e.g., no operation or reset)
            item.rst == 0;    // Set reset signal to 0 (active reset)
        });

        // Start the item in the sequence
        start_item(item);

        // Finish the item and notify the sequencer
        finish_item(item);
    endtask

endclass

`endif // ALU_SEQUENCE_RESET_SV

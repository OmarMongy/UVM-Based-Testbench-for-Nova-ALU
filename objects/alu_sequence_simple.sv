//-----------------------------------------------------------------------------
// File         : alu_sequence_simple.sv
// Description  : Simple ALU sequence class
//               This class extends the base ALU sequence class and defines a 
//               simple sequence for generating ALU operations. It randomizes 
//               the input values, including reset, operands, and the operation 
//               code, before starting and finishing the sequence item.
//               
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//-----------------------------------------------------------------------------

`ifndef ALU_SEQUENCE_SIMPLE_SV
`define ALU_SEQUENCE_SIMPLE_SV

// Define the simple ALU sequence class
class alu_sequence_simple extends alu_sequence_base;

    // Declare the random sequence item
    rand alu_item_drv item;

    // Register the class with UVM's factory
    `uvm_object_utils(alu_sequence_simple)

    // Constructor for the simple ALU sequence
    function new(string name = "");
        super.new(name);  // Call the base class constructor
    endfunction

    // The main body of the sequence
    virtual task body();
        // Create a new sequence item of type alu_item_drv
        item = alu_item_drv::type_id::create("item");

        // Start the item in the sequence
        start_item(item);

        // Randomize the sequence item with specified constraints
        if (!item.randomize() with {
            item.rst == 1;  // Ensure reset is active
            item.in1 inside {[0:10]};  // Operand 1 is between 0 and 10
            item.in2 inside {[20:25]};  // Operand 2 is between 20 and 25
            item.op  inside {[0:7]};  // Operation code is between 0 and 7
        }) begin
            `uvm_error("ALU_SEQ", "Randomization failed.")  // Error if randomization fails
        end

        // Finish the item and notify the sequencer
        finish_item(item);
    endtask

endclass

`endif // ALU_SEQUENCE_SIMPLE_SV

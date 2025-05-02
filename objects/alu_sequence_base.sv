//-----------------------------------------------------------------------------
// File         : alu_sequence_base.sv
// Description  : Base class for ALU sequence
//               This class defines a base sequence for driving ALU operations 
//               in a UVM testbench. It specifies the type of sequence item
//               (alu_item_drv) and provides functionality for creating the 
//               sequence with the associated sequencer (alu_sequencer).
//               
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//-----------------------------------------------------------------------------

`ifndef ALU_SEQUENCE_BASE_SV
`define ALU_SEQUENCE_BASE_SV

// Define the ALU sequence base class
class alu_sequence_base extends uvm_sequence#(.REQ(alu_item_drv));

    `uvm_declare_p_sequencer(alu_sequencer)  // Declare the sequencer for the sequence

    `uvm_object_utils(alu_sequence_base)  // Register the class with UVM's factory

    // Constructor for the ALU sequence base
    function new(string name = "");
      super.new(name);  // Call the base class constructor
    endfunction

endclass

`endif // ALU_SEQUENCE_BASE_SV

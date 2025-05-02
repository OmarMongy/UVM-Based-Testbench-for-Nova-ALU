//-----------------------------------------------------------------------------
// File         : alu_item_base.sv
// Description  : ALU Sequence Item Base Class for UVM Testbench
//               This class represents the base sequence item for the ALU
//               testbench. It includes randomized fields for the input data,
//               operation code, and reset signal, which are used in the UVM
//               sequences for generating ALU test vectors.
//               
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//-----------------------------------------------------------------------------
`ifndef ALU_ITEM_BASE_SV
`define ALU_ITEM_BASE_SV

// Define the ALU sequence item base class
class alu_item_base extends uvm_sequence_item;

    // ALU input 1
    rand alu_data in1; // First operand for ALU operation
    
    // ALU input 2
    rand alu_data in2; // Second operand for ALU operation

    // ALU operation code
    randc alu_data op; // Operation code for the ALU (e.g., ADD, SUB, AND, etc.)
    
    // Reset signal
    rand bit unsigned rst; // Reset signal for the ALU

    // UVM Object utilities
    `uvm_object_utils(alu_item_base)
    
    // Constructor
    function new(string name = "");
      super.new(name); // Call the parent class constructor
    endfunction

    // Convert class data to a string for easy display
    virtual function string convert2string();
      string result = $sformatf("rst: %0b, in1: %0d, in2: %0d, op: %0b", rst, in1, in2, op);
      
      return result; // Return the formatted string
    endfunction

endclass

`endif // ALU_ITEM_BASE_SV

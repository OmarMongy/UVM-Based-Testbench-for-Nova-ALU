//-----------------------------------------------------------------------------
// File         : alu_item_mon.sv
// Description  : ALU Monitor Sequence Item Class for UVM Testbench
//               This class extends the ALU sequence item base class and is
//               used to capture and report ALU responses and results. It
//               overrides the `convert2string()` function to provide a
//               customized string representation of the ALU result and
//               response flags (Overflow, Zero, CarryOut, Negative).
//               
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//-----------------------------------------------------------------------------

`ifndef ALU_ITEM_MON_SV
`define ALU_ITEM_MON_SV

// Import necessary UVM packages
`include "uvm_macros.svh"
`include "alu_item_base.sv"

// Define the ALU monitor sequence item class
class alu_item_mon extends alu_item_base;

    // ALU Response Flags
    Overflow Overflow;
    Zero Zero;
    CarryOut CarryOut;
    Negative Negative;

    // ALU Result
    alu_data rslt;

    // UVM Object utilities
    `uvm_object_utils(alu_item_mon)
    
    // Constructor
    function new(string name = "");
      super.new(name); // Call the parent class constructor
    endfunction

    // Override convert2string to customize string representation
    virtual function string convert2string();
      string result = super.convert2string(); // Get the common base class data
      
      // Append ALU result and response flags (Overflow, Zero, CarryOut, Negative)
      result = $sformatf("%s, ALU Result: %0d ,ALU Response (O.Z.C.N): %0s %0s %0s %0s", 
                         result, rslt, 
                         Overflow.name(), 
                         Zero.name(), 
                         CarryOut.name(), 
                         Negative.name());
                         
      return result; // Return the final formatted string
    endfunction

endclass

`endif // ALU_ITEM_MON_SV

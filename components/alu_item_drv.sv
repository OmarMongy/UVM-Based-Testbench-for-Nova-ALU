//-----------------------------------------------------------------------------
// File         : alu_item_drv.sv
// Description  : ALU Sequence Item Driver Class for UVM Testbench
//               This class extends the ALU sequence item base class and is
//               used as the driver for ALU sequence items. It overrides
//               the `convert2string()` function to customize the string
//               representation for the driver-specific behavior.
//               
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
//-----------------------------------------------------------------------------

`ifndef ALU_ITEM_DRV_SV
`define ALU_ITEM_DRV_SV

// Import necessary UVM packages
`include "uvm_macros.svh"
`include "alu_item_base.sv"

// Define the ALU sequence item driver class
class alu_item_drv extends alu_item_base;

    // UVM Object utilities
    `uvm_object_utils(alu_item_drv)
    
    // Constructor
    function new(string name = "");
      super.new(name); // Call the parent class constructor
    endfunction

    // Override convert2string to customize string representation
    virtual function string convert2string();
      string result = super.convert2string(); // Call the base class method to get the common data
      
      // Add any driver-specific details here, for now it's just a pass-through
      result = $sformatf("%s", result); // Format the result string
      
      return result; // Return the final formatted string
    endfunction

endclass

`endif // ALU_ITEM_DRV_SV

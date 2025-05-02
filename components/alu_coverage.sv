// ***************************************************************************
// ALU Coverage Class
//
// This class defines a coverage component for the ALU (Arithmetic Logic Unit)
// within a UVM (Universal Verification Methodology) testbench. The `alu_coverage`
// class collects coverage on various ALU flags and operation codes by sampling
// data from an `alu_item_mon` monitor.
//
// This component is used for tracking ALU behavior, such as overflow, zero, carry-out,
// and negative flags, as well as the opcode being executed. It helps ensure thorough 
// verification of the ALU's functionality by checking the status of these flags during
// simulation.
//
// File        : alu_coverage.sv
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
// ***************************************************************************

`uvm_analysis_imp_decl(_item)  // _item => the name that will be used in creation of the port

class alu_coverage extends uvm_component;

    // Port for receiving the collected item from the monitor
    // This port connects to the `alu_item_mon` monitor to receive monitored data
    uvm_analysis_imp_item #(alu_item_mon, alu_coverage) port_item; 

    // UVM component utility macro for the alu_coverage class
    `uvm_component_utils(alu_coverage)

    // Coverage group definition for ALU flags and operation codes
    // This group defines the coverage points to be collected during simulation
    covergroup cover_item with function sample(alu_item_mon item);
        option.per_instance = 1; // Collect coverage for each instance of agent

        // Coverage points for ALU flags and operation codes
        Overflow : coverpoint item.Overflow {
            option.comment = "ALU Overflow Flag";
        }
        Zero : coverpoint item.Zero {
            option.comment = "ALU Zero Flag";
        }
        CarryOut : coverpoint item.CarryOut {
            option.comment = "ALU CarryOut Flag";
        }
        Negative : coverpoint item.Negative {
            option.comment = "ALU Negative Flag";
        }    
        OpCode : coverpoint item.op {
            option.comment = "ALU Op-Code";
        }
    endgroup

    // Constructor function for the ALU coverage class
    // Initializes the `port_item` and `cover_item` objects and sets the instance name
    function new(string name = "", uvm_component parent);
        super.new(name, parent);
        port_item = new("port_item", this); // Instantiate the port_item for receiving data
        cover_item = new(); // Instantiate the coverage group
        cover_item.set_inst_name($sformatf("%s_%s", get_full_name(), "cover_item")); // Mapping cover item to verification plan
    endfunction

    // Function to write the collected item and sample it for coverage
    // @param item - the ALU monitor item to be sampled for coverage collection
    virtual function void write_item(alu_item_mon item);
        cover_item.sample(item); // Sample the provided item for coverage collection
    endfunction

endclass

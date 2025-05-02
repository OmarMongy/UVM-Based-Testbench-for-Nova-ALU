// ***************************************************************************
// ALU Environment Class
//
// This class defines the environment for the ALU (Arithmetic Logic Unit) 
// verification component in a UVM (Universal Verification Methodology) testbench. 
// The environment class is responsible for creating and connecting the 
// key components needed for ALU verification, such as the agent, coverage, 
// scoreboard, and environment configuration.
//
// The ALU environment is designed to handle the following tasks:
// - Create and configure the ALU agent, which handles the driving of stimulus 
//   and collection of monitored items.
// - Set up the scoreboard to compare actual results with expected results.
// - Integrate coverage collection to track code coverage based on the test plan.
// - Handle environment configuration, such as enabling/disabling coverage or 
//   result checking based on the configuration object.
//
// File        : alu_env.sv
// Project     : Verification UVM Framework for Nova ALU
// Author      : Omar Ashraf Abd El Mongy
// Date        : 1/5/2025
// Version     : 1.0
// ***************************************************************************

class alu_env extends uvm_env;

  // UVM component utility macro for the alu_env class
  `uvm_component_utils(alu_env)

  // Agent handler: The ALU agent is responsible for generating stimulus 
  // and monitoring the DUT (Design Under Test)
  alu_agent agent;

  // Environment configuration handler: Contains configuration settings for 
  // the environment, such as whether coverage is enabled or result checking is active.
  alu_env_config env_config;

  // Coverage handler: Manages coverage collection if enabled in the environment configuration.
  alu_coverage coverage;

  // Scoreboard handler: Holds the scoreboard to check actual results against expected values.
  alu_scoreboard scoreboard;

  // Constructor for the ALU environment class
  // Initializes the ALU environment component
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase: Create instances of the components used in the environment
  // This phase sets up the environment components: agent, configuration, scoreboard, 
  // and coverage if enabled.
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the ALU agent
    agent      = alu_agent::type_id::create("agent", this);

    // Create the environment configuration handler
    env_config = alu_env_config::type_id::create("env_config", this);

    // Create the scoreboard handler
    scoreboard = alu_scoreboard::type_id::create("scoreboard", this);

    // Create the coverage handler if coverage is enabled
    if(env_config.get_has_coverage()) begin
      coverage = alu_coverage::type_id::create("coverage", this);
    end
  endfunction

  // Connect phase: Connect the components in the environment
  // This phase sets up the necessary connections between the agent, scoreboard, 
  // and coverage components, including linking the monitor output to the scoreboard 
  // and coverage components if enabled in the configuration.
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect the scoreboard to the environment configuration
    scoreboard.scb_config = env_config;

    // Connect the agent monitor output port to the scoreboard port
    agent.monitor.output_port.connect(scoreboard.port_item);

    // Connect the agent monitor output port to the coverage port if enabled
    if(env_config.get_has_coverage()) begin
      agent.monitor.output_port.connect(coverage.port_item);
    end
  endfunction

endclass

`include "agent_i2c.sv"
`include "agent_cic.sv"
`include "agent_fir.sv"
`include "cic_scoreboard.sv"
`include "fir_scoreboard.sv"

class environment extends uvm_env;  
  `uvm_component_utils(environment)
  
  // Agents
  // i2c_agent i2c_agt;
  cic_agent cic_agt;
  fir_agent fir_agt;
  cic_scoreboard cic_sb;
  fir_scoreboard fir_sb;

  virtual dut_if dut_vif;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
	
  function void build_phase(uvm_phase phase);
    // Create agents
    // i2c_agt = i2c_agent::type_id::create("i2c_agt", this);
    cic_agt = cic_agent::type_id::create("cic_agt", this);
    fir_agt = fir_agent::type_id::create("fir_agt", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    //interface from database 
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", dut_vif))
      `uvm_fatal("NOVIF", "No se ha encontrado dut_vif en uvm_config_db")

    // Pasar virtual interface al agente
    // i2c_agt.vif = dut_vif;
    cic_agt.vif = dut_vif;
    fir_agt.vif = dut_vif;
    cic_agt.monitor.port.connect(cic_sb.analysis_port);
    fir_agt.monitor.port.connect(fir_sb.analysis_port);
  endfunction
endclass : environment

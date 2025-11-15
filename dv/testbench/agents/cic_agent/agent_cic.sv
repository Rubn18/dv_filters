`ifndef _CIC_AGT
`define _CIC_AGT

`include "transaction_cic.sv"
`include "monitor_cic.sv"
`include "driver_cic.sv"

class cic_agent extends uvm_agent;
  `uvm_component_utils(cic_agent)
  
  cic_driver driver;
  uvm_sequencer#(cic_tr) m_seqr;
  cic_monitor monitor;
  virtual dut_if vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    driver = cic_driver::type_id::create("cic_drv", this);
    monitor = cic_monitor::type_id::create("cic_mon", this);
    m_seqr = uvm_sequencer#(cic_tr)::type_id::create("m_seqr", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(m_seqr.seq_item_export);
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
  endtask : run_phase
endclass : cic_agent

`endif // _CIC_AGT

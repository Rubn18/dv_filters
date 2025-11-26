`ifndef _FIR_AGT
`define _FIR_AGT

`include "transaction_fir.sv"
`include "monitor_fir.sv"
`include "driver_fir.sv"
`include "fir_enable_sequence.sv"

class fir_agent extends uvm_agent;
  `uvm_component_utils(fir_agent)
  
  fir_driver driver;
  fir_enable_sequencer m_seqr;
  fir_monitor monitor;
  virtual dut_if vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    driver = fir_driver::type_id::create("fir_drv", this);
    monitor = fir_monitor::type_id::create("fir_mon", this);
    m_seqr = fir_enable_sequencer::type_id::create("m_seqr", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(m_seqr.seq_item_export);
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
  endtask : run_phase
endclass : fir_agent

`endif // _FIR_AGT

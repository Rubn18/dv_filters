`ifndef _MONITOR_CIC
`define _MONITOR_CIC

class cic_monitor extends uvm_monitor;
  `uvm_component_utils(cic_monitor)

  uvm_analysis_port #(cic_tr) port;
  virtual dut_if dut_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    port = new("port", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", dut_vif))
      `uvm_fatal("NOVIF", "No se ha encontrado dut_vif en uvm_config_db")
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    cic_tr tr;
    fork
      forever begin
        @(posedge dut_vif.clk);
        tr = cic_tr::type_id::create("tr", this);
        tr.data_in        = dut_vif.data_in;
        tr.data_in_ready  = dut_vif.data_in_ready;
        tr.data_out       = dut_vif.cic_data_out;
        tr.data_out_ready = dut_vif.cic_out_ready;
        tr.enable         = dut_vif.enable;
        tr.reset_n        = dut_vif.reset_n;
        tr.clear          = dut_vif.clear;
        tr.filter_dec_factor = dut_vif.filter_dec_factor;
        port.write(tr);
      end
    join_none;
  endtask : run_phase

endclass : cic_monitor

`endif // _MONITOR_CIC

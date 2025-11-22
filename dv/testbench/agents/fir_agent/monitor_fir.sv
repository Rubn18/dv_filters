`ifndef _MONITOR_FIR
`define _MONITOR_FIR

class fir_monitor extends uvm_monitor;
  `uvm_component_utils(fir_monitor)

  uvm_analysis_port #(fir_tr) port;
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
    fir_tr tr;
    fork
      forever begin
        @(posedge dut_vif.clk);
        tr = fir_tr::type_id::create("tr", this);
        tr.data_in   = dut_vif.cic_data_out;
        tr.in_ready  = dut_vif.cic_out_ready;
        tr.data_out  = dut_vif.fir_data_out;
        tr.out_ready = dut_vif.fir_out_ready;
        tr.fir_enable    = dut_vif.fir_enable;
        tr.reset_n   = dut_vif.reset_n;
        tr.coef0     = dut_vif.coef0;
        tr.coef1     = dut_vif.coef1;
        tr.coef2     = dut_vif.coef2;
        tr.div       = dut_vif.div;
        port.write(tr);
      end
    join_none;
  endtask : run_phase

endclass : fir_monitor

`endif // _MONITOR_FIR
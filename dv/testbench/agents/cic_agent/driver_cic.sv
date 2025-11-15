`ifndef _DRIVER_CIC
`define _DRIVER_CIC

`include "transaction_cic.sv"

class cic_driver extends uvm_driver #(cic_tr);
  `uvm_component_utils(cic_driver)

  virtual dut_if dut_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    // obtención de la interfaz a través del uvm_config_db
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", dut_vif))
      `uvm_fatal("NOVIF", "No se ha encontrado dut_vif en uvm_config_db")
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    cic_tr tr;
    forever begin
      seq_item_port.get_next_item(tr);

      // drive DUT signals
      dut_vif.data_in       <= tr.data_in;
      dut_vif.data_in_ready <= tr.data_in_ready;
      dut_vif.clear         <= tr.clear;
      dut_vif.filter_dec_factor <= tr.filter_dec_factor;
      dut_vif.enable        <= tr.enable;

      seq_item_port.item_done(); // indicar que se ha completado
      @(posedge dut_vif.clk);    // sincronización opcional
    end
  endtask : run_phase

endclass : cic_driver

`endif // _DRIVER_CIC
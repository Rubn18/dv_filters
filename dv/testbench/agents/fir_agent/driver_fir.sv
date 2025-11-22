`ifndef _DRIVER_FIR
`define _DRIVER_FIR

`include "transaction_fir.sv"

class fir_driver extends uvm_driver #(fir_tr);
  `uvm_component_utils(fir_driver)

  virtual dut_if dut_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", dut_vif))
      `uvm_fatal("NOVIF", "No se ha encontrado dut_vif en uvm_config_db")
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    fir_tr tr;
    forever begin
      seq_item_port.get_next_item(tr);

      // drive DUT signals
      dut_vif.cic_data_out <= tr.data_in;  // entrada al FIR
      dut_vif.cic_out_ready <= tr.in_ready;

      dut_vif.fir_data_out <= tr.data_out; // salida FIR
      dut_vif.fir_out_ready <= tr.out_ready;

      dut_vif.coef0 <= tr.coef0;
      dut_vif.coef1 <= tr.coef1;
      dut_vif.coef2 <= tr.coef2;
      dut_vif.div   <= tr.div;

      dut_vif.fir_enable  <= tr.fir_enable;
      dut_vif.reset_n <= tr.reset_n;

      seq_item_port.item_done();
      @(posedge dut_vif.clk); // sincronización opcional
    end
  endtask : run_phase

endclass : fir_driver

`endif // _DRIVER_FIR
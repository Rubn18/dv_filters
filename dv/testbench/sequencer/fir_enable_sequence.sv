`include "transaction_fir.sv"

class fir_enable_sequence extends uvm_sequence#(fir_tr);
  `uvm_object_utils(fir_enable_sequence)
  virtual dut_if vif;

  function new(string name="fir_enable_sequence");
    super.new(name);
  endfunction

  task body();
    fir_tr tr;
    bit values[4] = '{0,0,1,1}; // combinaciones FIR

    foreach (values[i]) begin
      tr = fir_tr::type_id::create($sformatf("fir_tr_%0d", i));
      tr.fir_enable = values[i];
      tr.coef0 = vif.coef0;
      tr.coef1 = vif.coef1;
      tr.coef2 = vif.coef2;
      tr.div = vif.div;
      tr.data_in = vif.cic_data_out;
      tr.in_ready = vif.cic_out_ready;
      tr.data_out = vif.fir_data_out;
      tr.out_ready = vif.fir_out_ready;
      tr.reset_n = vif.reset_n;
      start_item(tr);
      finish_item(tr);

      repeat (12) @(posedge vif.clk);
    end
  endtask
endclass
typedef uvm_sequencer#(fir_tr) fir_enable_sequencer;
`include "transaction_cic.sv"

class cic_enable_sequence extends uvm_sequence#(cic_tr);
  `uvm_object_utils(cic_enable_sequence)
  virtual dut_if vif;

  function new(string name="cic_enable_sequence");
    super.new(name);
  endfunction

  task body();
    cic_tr tr;
    bit values[4] = '{0,1,0,1}; // combinaciones CIC

    foreach (values[i]) begin
      tr = cic_tr::type_id::create($sformatf("cic_tr_%0d", i));
      tr.cic_enable = values[i];
      tr.data_in = vif.data_in;
      tr.data_in_ready = vif.data_in_ready;
      tr.clear = vif.clear;
      tr.filter_dec_factor = vif.filter_dec_factor;
      
      start_item(tr);
      finish_item(tr);

      repeat (12) @(posedge vif.clk);
    end
  endtask
endclass
typedef uvm_sequencer#(cic_tr) cic_enable_sequencer;
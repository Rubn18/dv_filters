`ifndef _FIR_TR
`define _FIR_TR

  import uvm_pkg::*;

  class fir_tr extends uvm_sequence_item;
  // `uvm_object_utils(fir_tr)
    bit fir_enable;
    bit reset_n;
    logic signed [7:0] coef0;
    logic signed [7:0] coef1;
    logic signed [7:0] coef2;
    logic signed [7:0] div;
    logic signed [7:0] data_in;
    logic signed [7:0] data_out;
    bit out_ready;
    bit in_ready;

    function new(string name="");
      super.new(name);
    endfunction
    
    `uvm_object_utils_begin(fir_tr)
      `uvm_field_int(fir_enable, UVM_ALL_ON)
      `uvm_field_int(reset_n, UVM_ALL_ON)
      `uvm_field_int(coef0, UVM_ALL_ON)
      `uvm_field_int(coef1, UVM_ALL_ON)
      `uvm_field_int(coef2, UVM_ALL_ON)
      `uvm_field_int(div, UVM_ALL_ON)
      `uvm_field_int(data_in, UVM_ALL_ON)
      `uvm_field_int(data_out, UVM_ALL_ON)
      `uvm_field_int(out_ready, UVM_ALL_ON)
      `uvm_field_int(in_ready, UVM_ALL_ON)
    `uvm_object_utils_end
  endclass : fir_tr

`endif
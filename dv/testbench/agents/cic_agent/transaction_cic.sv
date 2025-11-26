`ifndef _CIC_TR
`define _CIC_TR

import uvm_pkg::*;

class cic_tr extends uvm_sequence_item;
  // `uvm_object_utils(cic_tr)
  bit cic_enable;
  bit reset_n;
  logic signed [7:0] data_in;
  bit clear;
  logic [$clog2($clog2(8+1))-1:0] filter_dec_factor;
  logic signed [7:0] data_out;
  bit data_out_ready;
  bit data_in_ready;

  function new(string name="");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(cic_tr)
    `uvm_field_int(cic_enable, UVM_ALL_ON)
    `uvm_field_int(reset_n, UVM_ALL_ON)
    `uvm_field_int(data_in, UVM_ALL_ON)
    `uvm_field_int(clear, UVM_ALL_ON)
    `uvm_field_int(filter_dec_factor, UVM_ALL_ON)
    `uvm_field_int(data_out, UVM_ALL_ON)
    `uvm_field_int(data_out_ready, UVM_ALL_ON)
    `uvm_field_int(data_in_ready, UVM_ALL_ON)
  `uvm_object_utils_end
endclass : cic_tr

`endif
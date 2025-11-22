`ifndef _CIC_TR
`define _CIC_TR

import uvm_pkg::*;

class cic_tr extends uvm_sequence_item;
  `uvm_object_utils(cic_tr)

  bit cic_enable;
  bit reset_n;
  logic signed [7:0] data_in;
  bit clear;
  logic [$clog2($clog2(8+1))-1:0] filter_dec_factor;
  logic signed [7:0] data_out;
  bit data_out_ready;
  bit data_in_ready;

  function new(string name = "cic_tr"); super.new(name); endfunction

endclass : cic_tr

`endif
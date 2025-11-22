`ifndef _FIR_TR
`define _FIR_TR

import uvm_pkg::*;

class fir_tr extends uvm_sequence_item;
`uvm_object_utils(fir_tr)

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

  function new(string name = "fir_tr"); super.new(name); endfunction

endclass : fir_tr

`endif
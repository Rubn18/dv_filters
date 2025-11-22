`ifndef _DUT_IF
`define _DUT_IF

interface dut_if();
  logic clk;		//chip clock
  logic reset_n;	//chip reset
  logic signed [7:0] data_in;

  // CIC
  logic clear;
  logic cic_enable;
  logic data_in_ready;

  logic [$clog2($clog2(8+1))-1:0] filter_dec_factor;

  logic signed [8-1:0] cic_data_out;
  logic cic_out_ready;

  // FIR
  logic fir_enable;
  logic in_ready;

  logic signed [8-1:0] fir_data_out;
  logic fir_out_ready;

  logic signed [7:0] coef0;
  logic signed [7:0] coef1;
  logic signed [7:0] coef2;

  logic signed [7:0] div;

  // i2c
  //following signals only for system-level verification. You can remove them for block-level
  tri1 sclk;
  tri1 sdata;   //be aware with inout signals. It is an opendrain that must be driven by someone continiuously
   
  //internal variables to manage inout signals
  logic sda_drive;			//I2C interface. data
  logic scl_drive;			//I2C interface. clock
      
  logic sda_val;
  logic scl_val;
  
  //glue logic
  assign sdata = sda_drive ? sda_val : 'z;
  assign sclk = scl_drive ? scl_val : 'z;

endinterface

`endif // _DUT_IF

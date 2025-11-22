import uvm_pkg::*;
`include "uvm_macros.svh"

`include "dut_if.sv"
`include "lib_test.sv"
`include "adc_dms_model.sv"

module top;
  // Interface
  dut_if dut_if();


  // FIR
  fir #(.WIDTH(8)) dut_fir (
      .clk       (dut_if.clk),
      .reset_n   (dut_if.reset_n),
      .enable    (dut_if.fir_enable),

      .in_ready  (dut_if.data_in_ready),
      .data_in   (dut_if.data_in),
      .data_out  (dut_if.fir_data_out),
      .out_ready (dut_if.fir_out_ready),

      .coef0     (dut_if.coef0),
      .coef1     (dut_if.coef1),
      .coef2     (dut_if.coef2),
      .div       (dut_if.div)
  );

 
  // === CIC ===
  cic dut_cic (
      .resetn            (dut_if.reset_n),
      .clk               (dut_if.clk),
      .clear             (dut_if.clear),
      .enable            (dut_if.cic_enable),

      .data_in           (dut_if.data_in),
      .data_in_ready     (dut_if.data_in_ready),
      .filter_dec_factor (dut_if.filter_dec_factor),

      .data_out_ready    (dut_if.cic_out_ready),
      .data_out          (dut_if.cic_data_out)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);

    $shm_open("waves.shm");
    $shm_probe("ASM");
  end

  initial begin
    dut_if.clk = 0;
    forever #5 dut_if.clk = ~dut_if.clk;  // Reloj
  end

  initial begin
    dut_if.reset_n = 0;
    dut_if.cic_enable  = 0;
    dut_if.fir_enable  = 0;
    dut_if.clear   = 0;

    repeat(5) @(posedge dut_if.clk);
    dut_if.reset_n = 1;

    repeat(3) @(posedge dut_if.clk);
      dut_if.cic_enable  = 1;
      dut_if.fir_enable  = 1;
  end


  initial begin
    uvm_config_db#(virtual dut_if)::set(null, "", "dut_vif", dut_if);
    run_test();  // +UVM_TESTNAME=test_filtros
  end

endmodule : top

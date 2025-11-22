// TEST: T_RESET
// - reset_n = 0
// - Espera unos ciclos
// - Comprueba que todas las salidas están a su valor inicial

class test_reset extends base_test;
  `uvm_component_utils(test_reset)

  function new(string name = "test_reset", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_name(), "** TEST RESET **", UVM_LOW)

    // reset_n = 0
    env.dut_vif.reset_n <= 0;

    // Valores random entrada
    env.dut_vif.cic_enable         <= 1;
    env.dut_vif.fir_enable         <= 1;
    env.dut_vif.data_in        <= $random;
    env.dut_vif.data_in_ready  <= 1;
    env.dut_vif.clear          <= 1;
    env.dut_vif.coef0          <= $random;
    env.dut_vif.coef1          <= $random;
    env.dut_vif.coef2          <= $random;
    env.dut_vif.div            <= $random;

    // Esperar reloj
    repeat (5) @(posedge env.dut_vif.clk);

    // Ver salida

    // CIC
    if (env.dut_vif.cic_data_out     !== 0) `uvm_error("RESET", "cic_data_out no esta a 0 durante reset")
    if (env.dut_vif.cic_out_ready    !== 0) `uvm_error("RESET", "cic_out_ready no esta a 0 durante reset")
    if (env.dut_vif.cic_out_ready   !== 0) `uvm_error("RESET", "data_out_ready no esta a 0 durante reset")

    // FIR
    if (env.dut_vif.fir_data_out     !== 0) `uvm_error("RESET", "fir_data_out no esta a 0 durante reset")
    if (env.dut_vif.fir_out_ready    !== 0) `uvm_error("RESET", "fir_out_ready no esta a 0 durante reset")

    `uvm_info(get_name(), "Reset comprobado correctamente", UVM_LOW)

    // Terminar Test
    env.dut_vif.reset_n <= 1;
    repeat (5) @(posedge env.dut_vif.clk);

    phase.drop_objection(this);
  endtask : run_phase

endclass : test_reset

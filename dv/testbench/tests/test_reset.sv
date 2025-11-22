// TEST: T_RESET
// - Ver señal antes de reset
// - reset_n = 0
// - Espera unos ciclos
// - Comprueba que todas las salidas están a su valor inicial
// - reser_n = 1 -> ver señal otra vez

class test_reset extends base_test;
  `uvm_component_utils(test_reset)

  function new(string name = "test_reset", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info(get_name(), "** TEST RESET **", UVM_LOW)

    // Ver señal
    `uvm_info(get_name(), "Generando signal antes del reset", UVM_LOW)

    env.dut_vif.reset_n           <= 1;
    env.dut_vif.cic_enable        <= 1;
    env.dut_vif.fir_enable        <= 1;
    env.dut_vif.data_in           <= 8'hAA;
    env.dut_vif.data_in_ready     <= 1;
    env.dut_vif.clear             <= 0;
    env.dut_vif.filter_dec_factor <= 3;
    env.dut_vif.coef0             <= 1;
    env.dut_vif.coef1             <= 2;
    env.dut_vif.coef2             <= 3;
    env.dut_vif.div               <= 1;

    repeat(15) @(posedge env.dut_vif.clk);

    if (env.dut_vif.cic_out_ready === 0 && env.dut_vif.fir_out_ready === 0)
      `uvm_error("PRE_RESET", "Ningun filtro responde antes del reset")


    // Reset
    `uvm_info(get_name(), "Entrando en reset_n = 0", UVM_LOW)

    env.dut_vif.reset_n <= 0;
    repeat(3) @(posedge env.dut_vif.clk);

    // CIC
    if (env.dut_vif.cic_data_out  !== 0)
      `uvm_error("RESET", "cic_data_out no esta a 0 en reset")

    if (env.dut_vif.cic_out_ready !== 0)
      `uvm_error("RESET", "cic_out_ready no esta a 0 en reset")

    // FIR
    if (env.dut_vif.fir_data_out  !== 0)
      `uvm_error("RESET", "fir_data_out no esta a 0 en reset")

    if (env.dut_vif.fir_out_ready !== 0)
      `uvm_error("RESET", "fir_out_ready no esta a 0 en reset")

    `uvm_info(get_name(), "Salidas inicializadas correctamente durante reset", UVM_LOW)


    // Salir de reset
    `uvm_info(get_name(), "Saliendo de reset (reset_n = 1)", UVM_LOW)

    env.dut_vif.reset_n <= 1;
    repeat(13) @(posedge env.dut_vif.clk);

    // Volvemos a meter una entrada válida
    env.dut_vif.data_in        <= 8'hAA;
    env.dut_vif.data_in_ready  <= 1;

    repeat(15) @(posedge env.dut_vif.clk);

    // Comprobar que los filtros vuelven a funcionar
    if (env.dut_vif.cic_out_ready === 0 && env.dut_vif.fir_out_ready === 0)
      `uvm_error("POST_RESET", "Ningun filtro responde tras salir del reset")
    else `uvm_info(get_name(), "Filtros vuelven a funcionar tras reset, test OK", UVM_LOW)

    phase.drop_objection(this);
  endtask : run_phase

endclass : test_reset


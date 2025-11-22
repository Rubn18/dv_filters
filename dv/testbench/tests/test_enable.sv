// TEST: T_CIC_FIR_EN
// - Esperar top termine (ciclo reloj)
// - Poner cic_enable = 0 y fir_enable = 0
// - Comprobar salida
// - Hacerlo lo mismo con todas las posibles combinaciones (00, 01, 10, 11)

class test_enable extends base_test;
  `uvm_component_utils(test_enable)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info(get_name(), "** TEST ENABLE  **", UVM_LOW)

    // Dejar que el bloque initial del top termine
    #200ns;

    // cic=0, fir=0
    env.dut_vif.cic_enable <= 0;
    env.dut_vif.fir_enable <= 0;
    `uvm_info(get_name(), "cic=0, fir=0", UVM_LOW)
    #200ns;
   `uvm_info(get_name(), $sformatf("CIC=0 FIR=0: cic_data=%0h fir_data=%0h", env.dut_vif.cic_data_out, env.dut_vif.fir_data_out), UVM_LOW)

    // cic=1, fir=0
    env.dut_vif.cic_enable <= 1;
    env.dut_vif.fir_enable <= 0;
    `uvm_info(get_name(), "cic=1, fir=0", UVM_LOW)
    #200ns;
    `uvm_info(get_name(), $sformatf("CIC=1 FIR=0: cic_data=%0h fir_data=%0h", env.dut_vif.cic_data_out, env.dut_vif.fir_data_out), UVM_LOW)


    // cic=0, fir=1
    env.dut_vif.cic_enable <= 0;
    env.dut_vif.fir_enable <= 1;
    `uvm_info(get_name(), "cic=0, fir=1", UVM_LOW)
    #200ns;
    `uvm_info(get_name(), $sformatf("CIC=0 FIR=1: cic_data=%0h fir_data=%0h", env.dut_vif.cic_data_out, env.dut_vif.fir_data_out), UVM_LOW)

    // cic=1, fir=1
    env.dut_vif.cic_enable <= 1;
    env.dut_vif.fir_enable <= 1;
    `uvm_info(get_name(), "cic=1, fir=1", UVM_LOW)
    #200ns;
    `uvm_info(get_name(), $sformatf("CIC=1 FIR=1: cic_data=%0h fir_data=%0h", env.dut_vif.cic_data_out, env.dut_vif.fir_data_out), UVM_LOW)

    phase.drop_objection(this);
  endtask

endclass : test_cic_fir_en

class test_io_check extends base_test;
  `uvm_component_utils(test_io_check)


  function new(string name="test_io_check", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info(get_type_name(), "TEST IO CHECK: Iniciando test de entradas", UVM_LOW)

    // Inicializar señales
    env.dut_vif.reset_n           <= 1;
    env.dut_vif.data_in_ready     <= 1;
    env.dut_vif.clear             <= 0;
    env.dut_vif.filter_dec_factor <= 3;
    env.dut_vif.coef0             <= 1;
    env.dut_vif.coef1             <= 2;
    env.dut_vif.coef2             <= 3;
    env.dut_vif.div               <= 1;

    repeat (5) @(posedge env.dut_vif.clk);

    // BUCLE: repetir 600 iteraciones
    for (int i = 0; i < 600; i++) begin

      // Rand input
      env.dut_vif.data_in <= $urandom_range(0, 255);

      // CIC enable
      env.dut_vif.cic_enable <= 1;
      env.dut_vif.fir_enable <= 0;

      repeat (3) @(posedge env.dut_vif.clk);

      `uvm_info("TEST_IO", 
        $sformatf("[Iter %0d] CIC_OUT = %0d para DATA_IN=%0d", 
        i, env.dut_vif.cic_data_out, env.dut_vif.data_in),
        UVM_LOW)

      // FIR enable
      env.dut_vif.cic_enable <= 1;
      env.dut_vif.fir_enable <= 1;

      repeat (3) @(posedge env.dut_vif.clk);

      `uvm_info("TEST_IO", 
        $sformatf("[Iter %0d] FIR_OUT = %0d para DATA_IN=%0d", 
        i, env.dut_vif.fir_data_out, env.dut_vif.data_in),
        UVM_LOW)

      // Pequeña espera
      repeat (2) @(posedge env.dut_vif.clk);
    end

    phase.drop_objection(this);
  endtask
endclass
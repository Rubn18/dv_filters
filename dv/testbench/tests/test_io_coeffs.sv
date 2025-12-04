class test_io_coeffs extends base_test;
  `uvm_component_utils(test_io_coeffs)

  function new(string name="test_io_coeffs", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info(get_type_name(), "TEST_IO_COEFFS: Iniciando test", UVM_LOW)

    env.dut_vif.reset_n       <= 1;
    env.dut_vif.data_in_ready <= 1;
    env.dut_vif.clear         <= 0;

    // Entrada fija
    env.dut_vif.data_in <= 25;

    repeat (10) @(posedge env.dut_vif.clk);

    for (int i = 0; i < 600; i++) begin

      // Randomizar coeficientes del CIC
      env.dut_vif.filter_dec_factor <= $urandom_range(0, 2);

      // Randomizar coeficientes del FIR
      env.dut_vif.coef0 <= $urandom_range(0, 255);
      env.dut_vif.coef1 <= $urandom_range(0, 255);
      env.dut_vif.coef2 <= $urandom_range(0, 255);
      env.dut_vif.div   <= $urandom_range(0, 255);

      // Activar CIC y desactivar FIR
      env.dut_vif.cic_enable <= 1;
      env.dut_vif.fir_enable <= 0;

      repeat (4) @(posedge env.dut_vif.clk);
    /*
      `uvm_info("TEST_IO_COEFF",
        $sformatf(
          "[Iter %0d] CIC_OUT=%0d | IN=%0d | dec=%0d",
          i, env.dut_vif.cic_data_out, env.dut_vif.data_in, env.dut_vif.filter_dec_factor
        ),
        UVM_LOW
      )*/

      // Activar FIR también
      env.dut_vif.fir_enable <= 1;

      repeat (4) @(posedge env.dut_vif.clk);
        /*
      `uvm_info("TEST_IO_COEFF",
        $sformatf(
          "[Iter %0d] FIR_OUT=%0d | IN=%0d | coef={%0d,%0d,%0d} div=%0d",
          i, env.dut_vif.fir_data_out, fixed_input,
          env.dut_vif.coef0, env.dut_vif.coef1, env.dut_vif.coef2, env.dut_vif.div
        ),
        UVM_LOW)*/

      repeat (2) @(posedge env.dut_vif.clk);
    end

    phase.drop_objection(this);
  endtask
endclass

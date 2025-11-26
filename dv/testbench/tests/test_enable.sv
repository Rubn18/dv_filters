// class cic_fir_enable_sequence extends uvm_sequence#(uvm_sequence_item);
//   `uvm_object_utils(cic_fir_enable_sequence)

//   virtual dut_if vif; // puntero a la interfaz del DUT

//   function new(string name="cic_fir_enable_sequence");
//     super.new(name);
//   endfunction

//   task body();
//     // Array con combinaciones de enable: {cic, fir}
//     int enable_combinations [4][2] = '{'{0,0},'{1,0},'{0,1},'{1,1}};
//     /*
//     foreach(enable_combinations[i]) begin
//       // Aplicar enable directamente al DUT
//       vif.cic_enable <= enable_combinations[i][0];
//       vif.fir_enable <= enable_combinations[i][1];

//       `uvm_info(get_name(), $sformatf("Aplicando CIC=%0b FIR=%0b", vif.cic_enable, vif.fir_enable), UVM_LOW)

//       // Esperar 15 ciclos de reloj para estabilizar
//       repeat (15) @(posedge vif.clk);
//     end
//     */
//     for(int i = 0;i<2;i++) begin
//       for(int j=0;j<2;j++) begin
//         vif.cic_enable <= i;
//         vif.fir_enable <= j;

//         `uvm_info(get_name(), $sformatf("Aplicando CIC=%0b FIR=%0b", vif.cic_enable, vif.fir_enable), UVM_LOW)
        
//         // Esperar 15 ciclos de reloj para estabilizar
//         repeat (15) @(posedge vif.clk);
//       end
//     end
//   endtask
// endclass

// class test_enable extends base_test;
//   `uvm_component_utils(test_enable)

//   cic_fir_enable_sequence seq;

//   function new(string name="test_enable", uvm_component parent=null);
//     super.new(name, parent);
//   endfunction

//   task run_phase(uvm_phase phase);
//     super.run_phase(phase);
//     phase.raise_objection(this);
//     `uvm_info(get_name(), "Test Enable CIC y FIR", UVM_LOW)

//     // Inicialización de señales
//     env.dut_vif.reset_n           <= 1;
//     env.dut_vif.data_in           <= $urandom_range(0, 255);
//     env.dut_vif.data_in_ready     <= 1;
//     env.dut_vif.clear             <= 0;
//     env.dut_vif.filter_dec_factor <= 3;
//     env.dut_vif.coef0             <= 1;
//     env.dut_vif.coef1             <= 2;
//     env.dut_vif.coef2             <= 3;
//     env.dut_vif.div               <= 1;

//     // Crear y ejecutar la secuencia
//     seq = cic_fir_enable_sequence::type_id::create("seq");
//     seq.vif = env.dut_vif; // pasar la interfaz
//     seq.start(null); // start secuencia sin sequencer, actúa directamente sobre la interfaz

//     phase.drop_objection(this);
//   endtask
// endclass

class test_enable extends base_test;
  `uvm_component_utils(test_enable)

  function new(string name="test_enable", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    // super.run_phase(phase);
    cic_enable_sequence cic_seq;
    fir_enable_sequence fir_seq;

    phase.raise_objection(this);

    `uvm_info(get_name(), "Arrancando test_enable", UVM_LOW)
    // Inicialización de señales del DUT
    env.dut_vif.reset_n           <= 1;
    env.dut_vif.data_in           <= 15;
    env.dut_vif.data_in_ready     <= 1;
    env.dut_vif.clear             <= 0;

    // Parámetros del CIC
    env.dut_vif.filter_dec_factor <= 3;

    // Parámetros del FIR
    env.dut_vif.coef0             <= 1;
    env.dut_vif.coef1             <= 2;
    env.dut_vif.coef2             <= 3;
    env.dut_vif.div               <= 1;

    repeat (10) @(posedge env.dut_vif.clk);
  
    // Crear las secuencias
    cic_seq = cic_enable_sequence::type_id::create("cic_seq");
    cic_seq.vif = env.dut_vif;

    fir_seq = fir_enable_sequence::type_id::create("fir_seq");
    fir_seq.vif = env.dut_vif;

    // Ejecutar en paralelo
    fork
      cic_seq.start(env.cic_agt.m_seqr);
      fir_seq.start(env.fir_agt.m_seqr);
    join

    phase.drop_objection(this);
  endtask
endclass

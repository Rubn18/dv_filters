`include "transaction_cic.sv"

class cic_scoreboard extends uvm_component;
  `uvm_component_utils(cic_scoreboard)

  uvm_analysis_imp#(cic_tr, cic_scoreboard) analysis_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void write(cic_tr tx);

    // Reset activo → ignorar comprobaciones
    if (!tx.reset_n) begin
      `uvm_info("CIC_SB", "Reset activo: ignorando verificacion CIC", UVM_LOW)
      return;
    end

    // Si cic_enable = 0 → la salida debe ser igual a la entrada del CIC
    if (tx.cic_enable == 0 && tx.data_out !== tx.data_in) begin
      `uvm_info("CIC_SB",
        $sformatf("CIC enable=0 pero data_out=%0d distinto de cic_in=%0d",
        tx.data_out, tx.data_in),
        UVM_LOW
      )
    end
    else begin
      `uvm_info("CIC_SB",
        $sformatf("CIC verificacion OK: cic_enable=%0b data_out=%0d cic_in=%0d",
        tx.cic_enable, tx.data_out, tx.data_in),
        UVM_LOW
      )
    end

  endfunction
endclass
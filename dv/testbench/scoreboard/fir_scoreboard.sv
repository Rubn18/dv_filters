`include "transaction_fir.sv"

class fir_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fir_scoreboard)

  uvm_analysis_imp#(fir_tr, fir_scoreboard) analysis_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void write(fir_tr tx);
    // Reset activo -> ignorar comprobaciones
    if (!tx.reset_n) begin
      rst_fir_chk: assert(tx.data_out === 0) else
        $error("[FIR_SB] ERROR: Reset = 0 pero data_out distinto de 0");
    end

    // Si fir_enable = 0 -> data_out debe ser igual a data_in
    if (tx.fir_enable == 0) begin
      // ASSERT CRÍTICO
      en_fir_chk: assert(tx.data_out === tx.data_in)
        else begin
          $error("[FIR_SB] ERROR: FIR disabled pero data_out=%0d distinto de cic_in=%0d",
                 tx.data_out, tx.data_in);
        end

    end else begin
      `uvm_info("FIR_SB", $sformatf(
        "FIR verificacion OK: fir_enable=%0b data_out=%0d data_in=%0d",
        tx.fir_enable, tx.data_out, tx.data_in), UVM_LOW)
    end
  endfunction
endclass
`include "transaction_cic.sv"

class cic_scoreboard extends uvm_component;
  `uvm_component_utils(cic_scoreboard)

  uvm_analysis_imp#(cic_tr, cic_scoreboard) analysis_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void write(cic_tr tx);

    // Reset activo → no se verifica
    if (!tx.reset_n) begin
      rst_cic_chk: assert(tx.data_out === 0) else
        $error("[CIC_SB] ERROR: Reset = 0 pero data_out distinto de 0");
    end

    // Si cic_enable = 0 ⇒ la salida debe igualar la entrada del CIC
    if (tx.cic_enable == 0) begin
      
      // ASSERT CRÍTICO
      en_cic_chk: assert(tx.data_out === tx.data_in)
        else begin
          $error("[CIC_SB] ERROR: CIC disabled pero data_out=%0d distinto de cic_in=%0d",
                 tx.data_out, tx.data_in);
        end
    end
    else begin
      // CIC habilitado → solo información (opcional)
      `uvm_info("CIC_SB",
        $sformatf("CIC activo: cic_enable=%0b data_out=%0d cic_in=%0d",
        tx.cic_enable, tx.data_out, tx.data_in),
        UVM_LOW)
    end
  endfunction
endclass

// apb_scoreboard.sv
class apb_scoreboard;

  typedef struct {
    logic [7:0] addr;
    logic [31:0] data;
  } apb_txn_t;

  mailbox #(apb_txn_t) mon2scb;

  function new(mailbox #(apb_txn_t) mon2scb);
    this.mon2scb = mon2scb;
  endfunction

  task run();
    apb_txn_t txn;
    forever begin
      mon2scb.get(txn);
      $display("[%0t] SCOREBOARD: Addr=0x%0h Data=0x%0h", $time, txn.addr, txn.data);
    end
  endtask
endclass


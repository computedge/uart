class scoreboard;
	mailbox #(apb_transaction) mon2sb;

  function new(mailbox #(apb_transaction) mon2sb);
    this.mon2sb = mon2sb;
  endfunction

  task run();
    apb_transaction tr;
    forever begin
      mon2sb.get(tr);
      // Simple check: just print or compare against expected behavior
      $display("[SCOREBOARD] ADDR=0x%0h DATA=0x%0h WRITE=%0b",
                tr.paddr, tr.pdata, tr.write);
    end
  endtask

endclass

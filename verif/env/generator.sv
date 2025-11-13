class generator;
	 mailbox #(apb_transaction) gen2drv;

  function new(mailbox #(apb_transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task run();
    apb_transaction tr;
    repeat (10) begin
      tr = new();
      assert(tr.randomize() with { paddr inside {[8'h1:8'h6]}; pdata inside {[8'h01:8'h10]}; });
      gen2drv.put(tr);
    end
  endtask

  // Task write
  //task write_uart_reg (logic [)
endclass

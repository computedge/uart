class env;
	driver      drv;
  	monitor     mon;
  	generator   gen;
  	scoreboard  sb;

  mailbox #(apb_transaction) gen2drv = new();
  mailbox #(apb_transaction) mon2sb  = new();

  virtual uart_intf vif;

  function new(virtual uart_intf vif);
    this.vif = vif;
    drv = new(vif.uart_driver);
    mon = new(vif.uart_monitor, mon2sb);
    gen = new(gen2drv);
    sb  = new(mon2sb);
  endfunction

  task run();
    fork
      gen.run();
      drive_loop();
      mon.run();
      sb.run();
    join_none
  endtask

  task drive_loop();
    apb_transaction tr;
    drv.reset_signals();
    forever begin
      gen2drv.get(tr);
      drv.drive(tr);
    end
  endtask

endclass

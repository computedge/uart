// apb_monitor.sv
class monitor;
  virtual uart_intf vif;

  function new(virtual uart_intf vif);
    this.vif = vif;
  endfunction

  task run();
    forever begin
      @(vif.cb_mon);
      if (vif.cb_mon.PSEL && vif.cb_mon.PENABLE) begin
        $display("[%0t] APB %s addr=0x%0h data=0x%0h",
                 $time,
                 vif.cb_mon.PWRITE ? "WRITE" : "READ",
                 vif.cb_mon.PADDR,
                 vif.cb_mon.PWRITE ? vif.cb_mon.PWDATA : vif.cb_mon.PRDATA);
      end
    end
  endtask
endclass


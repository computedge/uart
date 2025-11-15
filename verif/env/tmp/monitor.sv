class monitor;
	virtual uart_intf.uart_monitor vif;
	mailbox #(apb_transaction) mon2sb;

	function new (virtual uart_intf.uart_monitor vif, mailbox #(apb_transaction) mon2sb);
		this.vif = vif;
		this.mon2sb =  mon2sb;
	endfunction
	
	task run();
		apb_transaction tr;
		forever begin
			@(posedge vif.PCLK);
			if(vif.PSEL && vif.PENABLE) begin
				tr = new(vif.PWRITE, vif.PADDR, vif.PWDATA);
				mon2sb.put(tr);
				tr.display("MONITOR");
			end
		end
	endtask
endclass

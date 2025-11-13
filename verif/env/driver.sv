class driver;
	virtual uart_intf.uart_driver vif;

	function new(virtual uart_intf.uart_driver vif);
		this.vif =  vif;
	endfunction



	task reset_signals();
		vif.PSEL 	<= 0;
		vif.PENABLE 	<= 0;
		vif.PWRITE 	<= 0;
		vif.PADDR 	<= 0;
		vif.PWDATA 	<= 0;
	endtask

	task drive (apb_transaction tr);
		@(posedge vif.PCLK)
		vif.PSEL	<= 1;
		vif.PADDR	<= tr.paddr;
		vif.PWRITE	<= tr.write;
		vif.PWDATA	<= tr.pdata;
		vif.PENABLE	<= 0;

		@(posedge vif.PCLK);
		vif.PENABLE	<= 1;
		wait (vif.PREADY);

		@(posedge vif.PCLK);
		vif.PSEL	<= 0;
		vif.PENABLE	<= 0;
		tr.display("DRIVER");
	endtask
endclass
